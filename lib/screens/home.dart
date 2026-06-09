import 'package:auth_project/models/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Login? user;
  TextEditingController newName = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) getUserData();
    });
  }

  getUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    print('UID: $uid');

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();


      if (doc.exists && mounted) {
        setState(() {
          user = Login.fromMap(doc.data() as Map<String, dynamic>);
        });
      }

  }

  updateName() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'fullName': newName.text.trim(),
    });
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome ${user?.fullName ?? 'User'}'),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Change the name you want'),
                    content: TextField(
                      controller: newName,
                      decoration: InputDecoration(hintText: 'Enter Name'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          updateName();
                          Navigator.pop(context);
                        },
                        child: Text('Change'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Change Name?',style: TextStyle(color: Colors.blueAccent),),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
              },
              child: Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}
