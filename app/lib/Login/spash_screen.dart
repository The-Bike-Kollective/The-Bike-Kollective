import 'dart:async';
import 'package:flutter/material.dart';
import 'package:the_bike_kollective/profile_view.dart';
import 'package:the_bike_kollective/models.dart';
import 'package:the_bike_kollective/Login/post_model.dart';
import 'package:http/http.dart';
import 'package:the_bike_kollective/Login/user_agreement.dart';
import 'package:the_bike_kollective/Login/helperfunctions.dart';
import 'dart:convert';
import 'package:the_bike_kollective/access_token.dart';

// information/instructions: splash page shows  "loading". meanwhile front-end
// receives auth code status from back-end after google sign-in
// @params: no param
// @return: nothing returned
// bugs: no known bugs
// TODO:
// 1. Pass in user data to profile screen to update [username]
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    postState(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("The Bike Kollective"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Loading, please wait...',
              style: Theme.of(context).textTheme.headline6,
            ),
            CircularProgressIndicator(
              //value: controller.value,
              semanticsLabel: 'Loading...please wait',
            ),
          ],
        ),
      ),
    );
  }
}
void postState(context) async {
  Customer user;
  final String state = getState();

  //post request with state
  var response = await post(
      Uri.parse(
          "http://ec2-54-71-143-21.us-west-2.compute.amazonaws.com:5000/users/signin"),
      body: {"state": state});

  //response from back-end with user data
  debugPrint('Response body: ${response.body}');

  //if response succesful
  if (response.statusCode == 200) {
    final res = json.decode(response.body);
    user = Customer.fromJson(res["user"]);
    //if user is a new user, then direct to agreement page
    if (user.signedWaiver == false) {
      //assign access token to global variable for front-end use
      accessToken01 = user.accessToken;
      //push user to agreement page
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => AgreementPage())));
//need to pass through user information to end up at profile page
      //access_token: user.accessToken, test: 'Teddy bear'))));
      //if an existing user
    } else if (user.signedWaiver == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => ProfileView(user: testUser))));
    }
  } else {
    // show error
    print("Try Again");
  }
}
