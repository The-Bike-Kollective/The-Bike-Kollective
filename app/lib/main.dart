import 'package:flutter/material.dart';
import 'package:the_bike_kollective/add-bike-page.dart';
import 'package:the_bike_kollective/bike_list_view.dart';
import 'home_view.dart';
//import 'models.dart';
import 'mock_data.dart';
import 'profile_view.dart';
import 'bike_list_view.dart';
import 'Login/user_agreement.dart';
//import 'photos.dart';
import 'get-photo.dart';

void main() {
  fillMockList();
  //print(mockList.bikes[0].name);
  //convertImageToBase64();
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
          primarySwatch: Colors.blue,
        ),
        //home: const HomeView(),
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => const HomeView(),
          ProfileView.routeName: (context) => ProfileView(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/bike-list': (context) => BikeListView(bikeList: mockList),
          // TODO: We will need to change the user to the current user at some point.
          AddBikePage.routeName: (context) => const AddBikePage(),
          // When google redirects user to agreement page
          '/user-agreement': (context) => AgreementPage(),
          GetPhoto.routeName: (context) => const GetPhoto()
        }
      );
  }
}
