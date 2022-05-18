import 'package:flutter/material.dart';
import 'package:the_bike_kollective/global_values.dart';
import 'package:the_bike_kollective/profile_view.dart';
import 'models.dart';
import 'MenuDrawer.dart';
import 'requests.dart';
import 'photos.dart';
import 'mock_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


// information/instructions: 
// @params: 
// @return: 
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
    print(args.imageStringBase64);
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
// TODO: need to make it update the database.
// Update: it does update the database, but not completely. The backend
// does not yet accept any more than the required four attributes to create
// a bike. 

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
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
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
            onSaved: (String? value) {
              //print("set name to bike");
              // TODO: add "name" to back end bike model
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

          // Notes:
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.lock),
              hintText: '[Notes about the bike]',
              labelText: 'Notes',
            ),
            
            onSaved: (String? value) {
              //bikeData["notes"] = [value];
             
            },
          ),


          ElevatedButton(
            onPressed: () {
              print('onPressed() called');
              print("widget.img64: " + widget.imageStringBase64);
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
              
                _formKey.currentState?.save();
                //String testLink = 'testLink';
                Future imageLink = getImageDownloadLink(widget.imageStringBase64);
                imageLink.then((value) {
                  bikeData['image'] = value;
                  print('imageLink received (image uploaded)');
                  
                  createBike(bikeData);
                  //print("sendBikeData() and createBike() completed");
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



Future<Bike> createBike(bikeData) async {
  print('createBike() called');
  bikeData['location_long'] = 25;
  bikeData['location_lat'] = -25;
  bikeData['size'] = 'size 2';
  bikeData['type'] = 'type 2';
  // temporary fix unit backend can accept the rest of the data
  // var truncatedData = {};
  // truncatedData['image'] = bikeData['image'];
  // //truncatedData['image'] = "fake_string";
  // truncatedData['lock_combination'] =bikeData['lock_combination'];
  // truncatedData['location_long'] = bikeData['location_long'];
  // truncatedData['location_lat'] = bikeData['location_lat'];
  // after the backend can accept the rest of the bikeData,
  // we can assign jsonEncode(BikeData) to datastring:

  ////POSSIBLY THE PROBLEM IS HERE
  String dataString = jsonEncode(bikeData);

  //String dataString = jsonEncode(bikeData);
  print('/bikes request body: ');
  print(dataString);
  print('/create bike request is made here.');
  final response = await http.post(
    Uri.parse(globalUrl+ '/bikes'),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Access-Control-Allow-Origin": "*",
      "Authorization": "Bearer "+ authCode
    },
    body: dataString 
  );
  
  int statusCode = response.statusCode;
  print("/bikes response completed with status code: $statusCode");
  print("response.body" + response.body);
  if (response.statusCode == 201) {
    print('Success: bike created');
    } 
  else if (response.statusCode == 400) {
    throw Exception('Failure: Bad request. Failed to add bike.');
  }
  else if (response.statusCode == 401) {
    throw Exception('Failure: Unauthorized. Invalide access token.');
  }

  //var json = jsonDecode(response.body); 
  // print('json:');
  // print(json);
  //return Bike.fromJson(json); 
  return Bike();
}

