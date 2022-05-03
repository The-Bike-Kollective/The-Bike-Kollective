import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// information/instructions: this function is called whenver
//the user clicks the "Sign in With Google" button. THis is
//linked to the Google auth link
// @params: no params
// @return: nothing returned
// bugs: no known bugs
// TODO:
// 1. Remove email and pw (only using google login for now)
_launchURLInApp() async {
  const host = 'accounts.google.com';
  const path = '/o/oauth2/v2/auth/oauthchooseaccount?access_type=offline&';
  const prompt = 'prompt=consent&';
  const scope =
      'scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email&include_granted_scopes=true&';
  const client_id =
      'client_id=701199836944-k9grqhb7tl30mm974iv62k6ge3ha2cqs.apps.googleusercontent.com&';
  const redirect_uri =
      'redirect_uri=http%3A%2F%2F127.0.0.1%3A5000%2Fprofile&flowName=GeneralOAuthFlow';
  const url =
      'https://$host$path$prompt$scope&response_type=code&$client_id$redirect_uri';


if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'could not launch $url';
  }
}

// information/instructions: sign-in widget
// @params: no params
// @return: nothing returned
// bugs: no known bugs
// TODO:
// 1. Remove email and pw (only using google login for now)
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            'Google Sign-in',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Center(
            child: ElevatedButton(
          child: Text('Google Sign-in'),
          onPressed: _launchURLInApp,
        )));
  }
}
