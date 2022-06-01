import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'dart:math';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:the_bike_kollective/Login/helperfunctions.dart';
import 'global_values.dart';



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
launchURLInApp() async {
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
  
//  final redirect_uri ='redirect_uri=http%3A%2F%2Fec2-35-166-192-222.us-west-2.compute.amazonaws.com%3A5000%2Fprofile&flowName=GeneralOAuthFlow';

// use for backup server
String redirect_uri = backUpServerRedirectUri;


  final url = 'https://$host$path$access_type$prompt$scope$urlState$response_type$client_id$redirect_uri';
  
  

  if (await canLaunch(url)) {
    print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
    print(url);
    await launch(url);
  } else {
    throw 'could not launch $url';
  }
}
