import 'package:flutter/material.dart';
//import 'package:the_bike_kollective/Login/access_token.dart';
//import 'package:the_bike_kollective/global_values.dart';
import 'package:the_bike_kollective/profile_view.dart';
import 'models.dart';
import 'MenuDrawer.dart';
import 'requests.dart';
import 'mock_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'access_token.dart';
import 'global_values.dart';

// information/instructions: 
// @params: 
// @return: 
// bugs: no known bugs

// information/instructions: This class creates an object that 
// is passed to AddBikePage when navigating to that page.
// That route contains a function which can access it. It seems
// weird because the AddBikePage class doesn't take an argument
// according to the class declaration, but you pass it anyway,
// and it is accessed in the build method as an argument. 
// The object contains an image file encoded in base 64. 
// @params: none
// @return: none
// bugs: no known bugs
class BikeFormArgument {
  final String imageStringBase64;
  BikeFormArgument(this.imageStringBase64);
}


// information/instructions: This page view has a form that users
// fill out with bike data. When they submit it, a new bike is
// added to the database.
// @params: User
// @return: Page with form.
// bugs: no known bugs
class AddBikePage extends StatelessWidget {
  const AddBikePage({ Key? key, /*required this.user*/}) : 
    super(key: key);
  //final User user;
  static const routeName = '/new-bike-form';
  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!
    .settings.arguments as BikeFormArgument;
    return Scaffold( 
        appBar: AppBar(
          title: const Text('The Bike Kollective'),
          leading: (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null,
        ),
        endDrawer: const MenuDrawer(),
        body: AddBikeForm(user: currentUser, imageStringBase64: args.imageStringBase64)
    );
  }
}


// information/instructions: This is the form that is rendered inside
// of the newBike page view. 
// @params: User(), the same user supplied to the page view is passed
// to this widget
// @return: form for usker to fill out. When user taps submit, the
// input is validated, converted to JSON and sent to the database.
// bugs: no known bugs
class AddBikeForm extends StatefulWidget {
  const AddBikeForm({  Key? key, 
                      required this.user,
                      required this.imageStringBase64 }) :
                        super(key: key);
  final User user;
  final String imageStringBase64;
  @override
  State<AddBikeForm> createState() => _AddBikeFormState();
}

// State object that goes with AddBikeForm.
class _AddBikeFormState extends State<AddBikeForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  var bikeData = {};

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            // The validator receives the text that the user has entered.
            decoration: const InputDecoration(
              icon: Icon(Icons.pedal_bike),
              hintText: '[Give the bike a name.]',
              labelText: 'Name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please give the bike a name. (example: "Big Red" ';
              }
              return null;
            },
            onSaved: (String? value) {//save value of 'Name' field.
              bikeData["name"] = value;
            },
          ),  
          
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.lock),
              hintText: '[Enter the lock combination.]',
              labelText: 'Lock Combintation',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the lock combination. (example: "102259" ';
              }
              return null;
            },
            onSaved: (String? value) {
              bikeData["lock_combination"] = int.parse(value!);
            },
          ),
          ElevatedButton(
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();
                print('test before getImageLink() access Token: ');
                  print(getAccessToken());
                Future imageLink = getImageDownloadLink(widget.imageStringBase64);
                imageLink.then((value) {
                  bikeData['image'] = value;
                  print('test before createBike() access Token: ');
                  print(getAccessToken()); //NULL
                  createBike(bikeData);
                  Navigator.pushNamed(context, ProfileView.routeName);
                }); 
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Adding bike to the database.')),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}


// information/instructions: Creates a bike on the data base. Use 
// must select a photo from the gallery.
// @params: none
// @return: 
// bugs: no known bugs
// TODO:
  //get permission from user to access location
  // get users location to be saved as bike's current location.
  // add spinning wheel for pictures not yet loaded
Future createBike(bikeData) async {
  print('createBike()');
  print('accessToken: ');
  print(getAccessToken());

  bikeData['location_long'] = 25;
  bikeData['location_lat'] = -25;
  // We might eventually have the user choose size and types via
  // dropdown menus. I think Ali wanted to do something with this,
  // so for now I'm leaving them as hard coded values. 
  bikeData['size'] = 'size 2';
  bikeData['type'] = 'type 2';
  String? currentAccessToken = getAccessToken();
  String dataString = jsonEncode(bikeData);
  Map <String,String>headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "Access-Control-Allow-Origin": "*",
      "Authorization": "Bearer $currentAccessToken"};
  //print('createBike() request body: ' + dataString);
  final response = await http.post(
    Uri.parse(globalUrl+ '/bikes'),
    headers: headers,
    body: dataString 
  );
  print("status code: " + response.statusCode.toString());
  if (response.statusCode == 201) {
    print('Success (code 201): bike created');
    final body = jsonDecode(response.body);
    String newAccessToken = body['access_token'];
    print('New Access Token: ' + newAccessToken);
    updateAccessToken(newAccessToken);      
  } 
  else if (response.statusCode == 400) {
    throw Exception('Failure (code 400): Bad request. Failed to add bike.');
  }
  else if (response.statusCode == 401) {
    throw Exception('Failure (code 401): Unauthorized. Invalide access token.');
  }

}


// Taken from documentation before. May not need this. 

// Future<Position> determinePosition() async {
//   bool serviceEnabled;
//   LocationPermission permission;

//   // Test if location services are enabled.
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     // Location services are not enabled don't continue
//     // accessing the position and request users of the 
//     // App to enable the location services.
//     return Future.error('Location services are disabled.');
//   }

//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       // Permissions are denied, next time you could try
//       // requesting permissions again (this is also where
//       // Android's shouldShowRequestPermissionRationale 
//       // returned true. According to Android guidelines
//       // your App should show an explanatory UI now.
//       return Future.error('Location permissions are denied');
//     }
//   }
  
//   if (permission == LocationPermission.deniedForever) {
//     // Permissions are denied forever, handle appropriately. 
//     return Future.error(
//       'Location permissions are permanently denied, we cannot request permissions.');
//   } 

//   // When we reach here, permissions are granted and we can
//   // continue accessing the position of the device.
//   return await Geolocator.getCurrentPosition();
// }