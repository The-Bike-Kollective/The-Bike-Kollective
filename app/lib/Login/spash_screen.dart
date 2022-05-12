import 'dart:async';
import 'package:flutter/material.dart';
import 'package:the_bike_kollective/profile_view.dart';
import 'package:the_bike_kollective/models.dart';

// information/instructions: splash page shows logo 
// and shows app is "loading". meanwhile front-end 
// receives auth code status from back-end after google sign-in
// @params: no params
// @return: nothing returned
// bugs: no known bugs
// TODO: 
// 1. create GET request to back-end to receive auth code status
// 1a. if previous user, receive user info and direct to user's profile page
// 1b. if new user, direct user to agreement page, then user's profile page
// 2. replace flutter icon with bike kollective logo (loading image)
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // initDynamicLinks();

    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileView(user: testUser))));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text("Loading...")),
      body: Center(
        child: Container(
          color: Colors.white,
          child: FlutterLogo(size: MediaQuery.of(context).size.height),
        ),
      ),
    ));
  }
}
