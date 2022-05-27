import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'dart:math';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:the_bike_kollective/Login/helperfunctions.dart';
import 'package:the_bike_kollective/login_functions.dart';


// information/instructions: sign-in widget
// @params: none
// @return: none
// bugs: none
// TODO:
// 1. change Signin button to Google standards (UI/UX)
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName = '/login';

  @override
  Login createState() => Login();
}
class Login extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    initLink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text(
            'Google Sign-in',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: const Center(
            child: ElevatedButton(
          child: Text('Google Sign-in'),
          onPressed: launchURLInApp,
        )
      )
    );
  }
}

