import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                  bottom: 12,
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
                          'Go ahead and set up your account',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          textAlign: TextAlign.start,
                          'Sign in-up to enjoy the best managing experience',
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: Offset(0, -30),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: DefaultTabController(
                  length: 2,
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
                          tabs: [
                            Tab(text: 'Login'),
                            Tab(text: 'Register'),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Tab content
                      Expanded(
                        child: TabBarView(children: [LoginForm(), Register()]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

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
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                border: InputBorder.none,
                hintText:'E-mail ID',hintStyle: TextStyle(
                  color: Colors.black)),
            ),
          ),
          SizedBox(height: 20,),
           Container(
            height: 60,
            width: 380,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Color(0xffE2E8F0),
            ),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                border: InputBorder.none,
                hintText:'Password',hintStyle: TextStyle(
                  color: Colors.black)),
            ),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Forget Password?',style: TextStyle(
                color: Colors.blue
              ),)
            ],
          ),
          SizedBox(height: 10,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff2563EB),
              fixedSize: Size(380, 65)
            ),
            onPressed: (){},
           child:Text('Login',style: TextStyle(color: Colors.white,fontSize: 20),)),
           SizedBox(height: 20),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 50.0),
             child: Row(
              children: [
                Expanded(child: 
                Divider(
                  color: Colors.grey.shade400,
                  thickness: 1,
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('or login with',style: TextStyle(fontSize: 14,color: Colors.grey.shade500),),
                ),
                Expanded(child: 
                Divider(
                  color: Colors.grey.shade400,
                  thickness: 1,
                )),
              ],
             ),
           ),
           SizedBox(height: 20,),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xffE2E8F0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child:Row(
                  children: [
                    Image.asset('assets/google.jpeg',fit: BoxFit.cover,
                    height: 25,
                    width: 25,),
                    SizedBox(width: 10,),
                    Text('Google',style: TextStyle(
                      color: Colors.black,
                      fontSize: 20
                    ),)
                  ],
                ),
              )
            ],
           )
        ],
      ),
    );
  }
}

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
