import 'package:auth_project/screens/forget_pass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.40,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/bg.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Positioned(
                    bottom: 25,
                    left: 4,
                    right: 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30.0,
                        horizontal: 5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textAlign: TextAlign.start,
                            _tabController.index == 0
                                ? 'Go ahead and set up your account'
                                : 'Create your Account',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            textAlign: TextAlign.start,
                            'Sign in-up to enjoy the best managing experience',
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.60,
              child: Transform.translate(
                offset: Offset(0, -30),
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        // Tab buttons
                        Container(
                          width: 350,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xffE2E8F0),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            tabs: [
                              Tab(text: 'Login'),
                              Tab(text: 'Register'),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        // Tab content
                        SizedBox(
                          height: 420,
                          child: TabBarView(
                            controller: _tabController,
                            children: [LoginForm(), Register()],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleIn = GoogleSignIn();
  signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Oops Erorr $e')));
    }
  }

  signInwithGoggle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleIn.signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 380,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Color(0xffE2E8F0),
            ),
            child: TextField(
              controller: email,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                border: InputBorder.none,
                hintText: 'E-mail ID',
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 60,
            width: 380,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Color(0xffE2E8F0),
            ),
            child: TextField(
              controller: password,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                border: InputBorder.none,
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ForgetPass()),
                  );
                },
                child: Text(
                  'Forget Password?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff2563EB),
              fixedSize: Size(380, 65),
            ),
            onPressed: () {
              signIn();
            },
            child: Text(
              'Login',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Row(
              children: [
                Expanded(
                  child: Divider(color: Colors.grey.shade400, thickness: 1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'or login with',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ),
                Expanded(
                  child: Divider(color: Colors.grey.shade400, thickness: 1),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => signInwithGoggle(),
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0xffE2E8F0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/google.jpeg',
                        fit: BoxFit.cover,
                        height: 25,
                        width: 25,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Google',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phoneno = TextEditingController();
  
  signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.text.trim(),
            password: password.text.trim(),
          );

      print('Auth done — uid: ${userCredential.user!.uid}'); // ← add

      await userCredential.user!.updateDisplayName(name.text.trim());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'uid': userCredential.user!.uid,
            'fullName': name.text.trim(),
            'email': email.text.trim(),
            'phone': phoneno.text.trim(),
            'createdAt':FieldValue.serverTimestamp(),
          });

      print('Firestore save done'); 
    } catch (e) {
      print('Error in signUp: $e'); 
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('something Wrong : $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 380,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color(0xffE2E8F0),
          ),
          child: TextField(
            controller: name,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person),
              border: InputBorder.none,
              hintText: 'Full Name',
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 60,
          width: 380,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color(0xffE2E8F0),
          ),
          child: TextField(
            controller: email,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.mail),
              border: InputBorder.none,
              hintText: 'E-mail ID',
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 60,
          width: 380,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color(0xffE2E8F0),
          ),
          child: TextField(
            controller: password,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.lock),
              border: InputBorder.none,
              hintText: 'Password',
              hintStyle: TextStyle(color: Colors.black),
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 60,
          width: 380,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Color(0xffE2E8F0),
          ),
          child: TextField(
            controller: phoneno,
            maxLength: 10,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.phone),
              border: InputBorder.none,
              hintText: 'Phone No',
              hintStyle: TextStyle(color: Colors.black),
              counterText: '',
              contentPadding: EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
        SizedBox(height: 50),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff2563EB),
            fixedSize: Size(380, 65),
          ),
          onPressed: () {
            signUp();
          },
          child: Text(
            'Register',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    );
  }
}
