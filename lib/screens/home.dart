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
  TextEditingController newName = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool isPasswordVisible = false;

  updateName() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'fullName': newName.text.trim(),
    });
  }

  delteAcc(String password) async {
    final user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      await user.delete();
    } catch (e) {
      Text('Error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Enter password to confirm'),
                  content: TextField(
                    controller: pass,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        icon: isPasswordVisible
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                      ),
                    ),
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
                        delteAcc(pass.text.trim());
                        Navigator.pop(context);
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Login user = Login.fromMap(
              snapshot.data!.data() as Map<String, dynamic>,
            );
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome ${user.fullName}'),
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
                    child: Text(
                      'Change Name?',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
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
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
