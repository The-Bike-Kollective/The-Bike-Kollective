import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:the_bike_kollective/Login/helperfunctions.dart';

// information/instructions: this function listens 
// for dynamic link and redirects user to the 
// loading page
// @params: none
// @return: none
// bugs: none
// TODO: none
void initLink() {
   FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      Get.toNamed('/spash-screen');
  }).onError((error) {
    // Handle errors
    bool? kDebugMode;
    if (kDebugMode!) {
      print(error.message);
    }
    }
  );
}

// information/instructions: this function holds the
// Google Sign-in launch URL with parameters such as
// the client ID, requested scope, etc
// @params: none
// @return: none
// bugs: none
// TODO: none
_launchURLInApp() async {
  getRandomizedString();
  final String sstate = getState();

  final urlState = 'state=' + sstate + '&';
  final host = 'accounts.google.com';
  //final path = '/o/oauth2/v2/auth/oauthchooseaccount';
  final path = '/o/oauth2/v2/auth/oauthchooseaccount?';
  final access_type = 'access_type=offline&';
  final prompt = 'prompt=consent&';
  final scope =
      'scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email&include_granted_scopes=true&';
  final response_type = 'response_type=code&';
  final client_id =
      'client_id=701199836944-k9grqhb7tl30mm974iv62k6ge3ha2cqs.apps.googleusercontent.com&';
  final redirect_uri =
      'redirect_uri=http%3A%2F%2Fec2-54-71-143-21.us-west-2.compute.amazonaws.com%3A5000%2Fprofile&flowName=GeneralOAuthFlow';

  final url = 'https://$host$path$access_type$prompt$scope$urlState$response_type$client_id$redirect_uri';
  
  final queryParamerters = {
    'state' : sstate,
    'access_type': 'offline',
    'prompt': 'consent',
    'scope' : 'https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email&include_granted_scopes=true',
    'response_type' : 'code',
    'client_id' : '701199836944-k9grqhb7tl30mm974iv62k6ge3ha2cqs.apps.googleusercontent.com',
    'redirect_uri' : 'http%3A%2F%2Fec2-54-71-143-21.us-west-2.compute.amazonaws.com%3A5000%2Fprofile&flowName=GeneralOAuthFlow'
  };

  // final Uri url = Uri(  
  //   scheme: 'https',
  //   host: host,
  //   path: path,
  //   queryParameters: queryParamerters
  // );


  if (await canLaunch(url)) {
    print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
    print(url);
    await launch(url);
  } else {
    throw 'could not launch $url';
  }
}

// information/instructions: sign-in widget
// @params: none
// @return: none
// bugs: none
// TODO:
// 1. change Signin button to Google standards (UI/UX)
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

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
          onPressed: _launchURLInApp,
        )
      )
    );
  }
}

