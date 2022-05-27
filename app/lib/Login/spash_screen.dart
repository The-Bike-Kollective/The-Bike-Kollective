import 'package:flutter/material.dart';
import 'package:the_bike_kollective/requests.dart';

// information/instructions: splash page shows  "loading". meanwhile front-end
// receives auth code status from back-end after google sign-in
// @params: no param
// @return: nothing returned
// bugs: no known bugs
// TODO:
// 1. Pass in user data to profile screen to update [username]
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const routeName = '/splash-screen';
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    postState(context);// see requests.dart
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("The Bike Kollective"),
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
            const CircularProgressIndicator(
              //value: controller.value,
              semanticsLabel: 'Loading...please wait',
            ),
          ],
        ),
      ),
    );
  }
}

