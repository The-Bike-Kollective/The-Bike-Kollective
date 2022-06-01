import 'package:flutter/material.dart';
import 'MenuDrawer.dart';
import 'Login/login_page.dart';

// information/instructions: Flutter Widget; This is the home view, when the
//user first opesn the app and is not signed in.
// @params: no params
// @return: nothing returned
// bugs: no known bugs
class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  final String aboutUs = "We help communities share bikes.";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('The Bike Kollective'),
        ),
        endDrawer: const MenuDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/bikes.png'),
            Text(aboutUs),
            const HomeButtonGroup()
          ],
        ));
  }
}

// information/instructions: Stateless Flutter Widget, to be rendered by
// the HomeView widget. Contains the three buttons on the
//main homescreen.
// @params: no params
// @return: nothing returned
// bugs: no known bugs
class HomeButtonGroup extends StatelessWidget {
  const HomeButtonGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
            debugPrint('sign in clicked');
          },
          child: const Text('Sign In/Create Account'),
        ),
      
        OutlinedButton(
          onPressed: () {
            debugPrint('Quit Clicked');
          },
          child: const Text('Quit'),
        ),
      ],
    );
  }
}