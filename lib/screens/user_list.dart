import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  bool _isDecending = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: UserSearchDelegate());
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isDecending = !_isDecending;
              });
            },
            icon: _isDecending
                ? Icon(Icons.arrow_downward)
                : Icon(Icons.arrow_upward),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('createdAt', descending: _isDecending)
            .snapshots(),
        builder: (context, snapshot) {
          print('docs count: ${snapshot.data?.docs.length}');
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error ${snapshot.error}'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['fullName']),
                subtitle: Text(data['email']),
                trailing: Text(
                  data['createdAt'] != null
                      ? (data['createdAt'] as Timestamp)
                            .toDate()
                            .toString()
                            .substring(0, 10)
                      : 'No Date',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class UserSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: Icon(Icons.clear_outlined)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildUserList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildUserList();
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('fullName', isGreaterThanOrEqualTo: query)
          .where('fullName', isLessThan: query + 'z')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('User not found'));
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> data =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            return ListTile(
              title: Text(data['fullName']),
              subtitle: Text(data['email']),
            );
          },
        );
      },
    );
  }
}
