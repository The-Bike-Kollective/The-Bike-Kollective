import 'package:flutter/material.dart';
import 'MenuDrawer.dart';
import 'Login/login_page.dart';
import 'style.dart';

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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/bikes.png'),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Text(aboutUs, 
                style: pagesStyle['italicSubtitle'],
                textAlign: TextAlign.center
              ),
            ),
            
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
        SizedBox(
          child: OutlinedButton(
            style: buttonStyle['main'],
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
              debugPrint('sign in clicked');
            },
            child: const Text('Sign In/Create Account'),
          ),
          width: 200, 
        ),
        SizedBox(
          child: OutlinedButton(
            style: buttonStyle['main'],
              onPressed: () {
                debugPrint('Quit Clicked');
              },
              child: const Text('Quit'),
          ),
          width: 200
          
        )
      ]
    );
        
  }
}