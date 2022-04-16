import 'package:flutter/material.dart';
import 'package:the_bike_kollective/mainscreen.dart';
import 'home_view.dart';
import 'mainscreen.dart';

void main() {
  runApp(const App());
}


// information/instructions: Flutter Widget, renders the MainScreen 
// widget. This widget is the root of the application. The class 
// also contains ThemeData(), which will hold a lot of the style info.
// @params: no params
// @return: nothing returned
// bugs: no known bugs
// TODO: Fill in themeData info. 
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Bike Kollective',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

