import 'dart:io';
import 'package:auth_project/models/login.dart';
import 'package:auth_project/screens/user_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController newName = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool isPasswordVisible = false;
  File? image;
  bool loading = false;

  pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  uploadImage() async {
    try {
      setState(() {
        loading = true;
      });
      if (image == null) return;
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final ref = FirebaseStorage.instance
          .ref()
          .child('profiles')
          .child('$uid.jpeg');
      await ref.putFile(image!);
      String url = await ref.getDownloadURL();
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'photoUrl': url,
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('error $e')));
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  updateName() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'fullName': newName.text.trim(),
    });
  }

  ddelteAcc(String password) async {
    final user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;
    try {
      String provider = user.providerData[0].providerId;
      print('Provider: $provider');

      if (provider == 'google.com') {
        // Google reauth
        print('Google reauth starting');
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          print('Google sign in cancelled');
          return;
        }
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await user.reauthenticateWithCredential(credential);
        print('Reauth done');
      } else {
        // Email reauth
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
        print('Email reauth done');
      }

      // Delete Firestore → same for both providers
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
      print('Firestore deleted');

      // Delete Auth account → same for both providers
      await user.delete();
      print('Auth deleted');

      // Sign out Google
      await GoogleSignIn().signOut();
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
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
                        ddelteAcc(pass.text.trim());
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
          if (snapshot.hasData && snapshot.data!.exists) {
            Login user = Login.fromMap(
              snapshot.data!.data() as Map<String, dynamic>,
            );
            return loading
                ? CircularProgressIndicator()
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => pickImage(),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: user.photoUrl != null
                                ? NetworkImage(user.photoUrl!)
                                : image != null
                                ? FileImage(image!) as ImageProvider
                                : AssetImage('assets/default.jpeg')
                                      as ImageProvider,
                            child: image == null && user.photoUrl == null
                                ? Icon(Icons.camera_alt, size: 30)
                                : null,
                          ),
                        ),
                        SizedBox(height: 20),
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
                                  decoration: InputDecoration(
                                    hintText: 'Enter Name',
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
                        SizedBox(height: 20,),
                        ElevatedButton(
                          onPressed: () async {
                            uploadImage();
                          },
                          child: Icon(Icons.upload),
                        ),
                        SizedBox(height: 100),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(280, 55),
                            backgroundColor: Colors.blueAccent,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => UserList()),
                            );
                          },
                          child: Text(
                            'View All user',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
