import 'package:flutter/material.dart';
import 'home_view.dart';


void main() {
  runApp(const App());
}

// This is adapted from the starter Flutter app, just
// to get us going. Some of the comments are from that
// original starter counter app.
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Bike Kollective',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: const HomeView(),
    );
  }
}

