import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';

// information/instructions: this function is called by 
// the _launchURLInApp function to generate the last
// parameter of randomized characters
// @params: none
// @return: return randomized string
// bugs: none
// TODO: none
String generateRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

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

// information/instructions: this function is called whenver
//the user clicks the "Sign in With Google" button. THis is
//linked to the Google auth link
// @params: no params
// @return: nothing returned
// bugs: no known bugs
// TODO:
// 1. Remove email and pw (only using google login for now)
_launchURLInApp() async {
  String stateGoogle = generateRandomString(10); 

  final googleLogin = "http://ec2-54-71-143-21.us-west-2.compute.amazonaws.com:5000/login";
  final url = '$googleLogin';

  if (await canLaunch(url)) {
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
class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text(
            'Create Account',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: const Center(
            child: ElevatedButton(
          child: Text('Google Create Account'),
          onPressed: _launchURLInApp,
        )
      )
    );
  }
}
