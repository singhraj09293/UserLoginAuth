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

    print('Doc exists: ${doc.exists}'); 
    print('Doc data: ${doc.data()}');
    setState(() {
      if (doc.exists && mounted) {
        setState(() {
          user = Login.fromMap(doc.data() as Map<String, dynamic>);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome ${user?.fullName ??  'User'}',
            ),
            Text('E-Mail :${user?.email ?? 'E-mail iD'}'),
            Text('Phone No:- ${user?.phone ?? '+91XXXXXXXXXX'}'),
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
