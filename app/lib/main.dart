import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_bike_kollective/Login/login_page.dart';
import 'package:the_bike_kollective/get-photo.dart';
import 'add_bike_page.dart';
import 'package:the_bike_kollective/bike_list_view.dart';
import 'home_view.dart';
import 'profile_view.dart';
import 'bike_list_view.dart';
import 'Login/user_agreement.dart';
import 'Login/spash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'return-bike-form.dart';

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainPage());
}

// information/instructions: Flutter Widget, renders the MainScreen
// widget. This widget is the root of the application. The class
// also contains ThemeData(), which will hold a lot of the style info.
// @params: no params
// @return: nothing returned
// bugs: no known bugs
// TODO: Fill in themeData info.


///  WE MIGHT BE ABLE TO DELETE THIS, AND JUST HAVE THE MAIN FUNCTION
///  GO TO APP INSTEAD, BUT I LET IT IN CASE THAT'S WRONG. I THINK IT MIGHT
///  JUST BE A VESTIGE THAT IS NO LONGER NEEDED, LIKE THE APPENDIX.
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  App createState() => App();
}

class App extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'The Bike Kollective',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const HomeView(),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const HomeView(),
        ProfileView.routeName: (context) => const ProfileView(),
        BikeListView.routeName: (context) => const BikeListView(),
        '/spash-screen': (context) => const SplashScreen(),
        ReturnBikeForm.routeName: (context) => ReturnBikeForm(),
        // user is directed to agreement page if first time making account
        AgreementPage.routeName: (context) => AgreementPage(),
        GetPhoto.routeName: (context) => const GetPhoto(),
        AddBikePage.routeName: (context) => AddBikePage(),
        LoginPage.routeName: (context) => const LoginPage()
      },
    );
  }
}