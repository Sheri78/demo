import 'dart:developer';
import 'dart:io';
import 'package:chat_app/helper/dialogs.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../api/apis.dart';
import '../../main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleGoogleBtnClick() {
    Dialogs.showProgressBar(context); // for hiding progress bar indicator
    _signInWithGoogle().then((user) async {
      Navigator.pop(context); // for hiding progress bar indicator
      if (user != null) {
        log('User:${user.user}');
        log('User:${user.additionalUserInfo}');

        if ((await APIs.userExists())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
        } else {
          await APIs.createUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomeScreen()));
          });
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      Dialogs.showSnakbar(context, 'something went wrong check internet');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
     mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        // padding: EdgeInsets.symmetric(vertical: 30),
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.deepOrangeAccent,
          Colors.deepOrange,
          Colors.orange,
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Welcome Back!',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(60),
                      topLeft: Radius.circular(60))),
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 60,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(225, 95, 27, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10)),
                          ]),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: 'Email or Phone Number',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                ),
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none
                              ),

                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text('Forget Password',style: TextStyle(color: Colors.grey),),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.deepOrange
                      ),
                      child: Center(
                        child: Text('Login',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      ),
                    ),
                    SizedBox(height: 80,),
                    Positioned(
                        top: mq.height * .63,
                        left: mq.width * .10,
                        width: mq.width * .8,
                        height: mq.height * .06,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 223, 255, 187),
                            // backgroundColor: Color.fromARGB(255, 223, 255, 187),
                          ),
                          onPressed: () {
                            _handleGoogleBtnClick();
                          },
                          label: RichText(
                              text: TextSpan(
                                  style: TextStyle(color: Colors.black54, fontSize: 19),
                                  children: [
                                    TextSpan(text: 'Login with '),
                                    TextSpan(
                                        text: 'Google',
                                        style: TextStyle(fontWeight: FontWeight.w500)),
                                  ])),
                          icon: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Image.asset(
                              'images/google.png',
                              height: mq.height * .05,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
      // body: Stack(
      //   children: [
      //     AnimatedPositioned(
      //         duration: Duration(seconds: 1),
      //         top: mq.height * .15,
      //         right: _isAnimate ? mq.width * .25 : -mq.width * .5,
      //         width: mq.width * .5,
      //         child: Image.asset('images/chat.png')),
      //     Positioned(
      //         top: mq.height * .63,
      //         left: mq.width * .10,
      //         width: mq.width * .8,
      //         height: mq.height * .06,
      //         child: ElevatedButton.icon(
      //           style: ElevatedButton.styleFrom(
      //             backgroundColor: Color.fromARGB(255, 223, 255, 187),
      //           ),
      //           onPressed: () {
      //             _handleGoogleBtnClick();
      //           },
      //           label: RichText(
      //               text: TextSpan(
      //                   style: TextStyle(color: Colors.black, fontSize: 19),
      //                   children: [
      //                 TextSpan(text: 'Login with '),
      //                 TextSpan(
      //                     text: 'Google',
      //                     style: TextStyle(fontWeight: FontWeight.w700)),
      //               ])),
      //           icon: Image.asset(
      //             'images/google.png',
      //             height: mq.height * .05,
      //           ),
      //         )),
      //   ],
      // ),
    );
  }
}
