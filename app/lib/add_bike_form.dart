import 'package:flutter/material.dart';
import 'models.dart';
import 'MenuDrawer.dart';
import 'requests.dart';



// information/instructions: 
// @params: 
// @return: 
// bugs: no known bugs



// information/instructions: This page view has a form that users
// fill out with bike data. When they submit it, a new bike is
// added to the database.
// @params: User
// @return: Page with form.
// bugs: no known bugs
class AddBikePage extends StatelessWidget {
  const AddBikePage({ Key? key, 
                      required this.user }) :
                        super(key: key);
  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
        appBar: AppBar(
          title: const Text('The Bike Kollective'),
          leading: (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null,
        ),
        endDrawer: const MenuDrawer(),
        body: AddBikeForm(user: user)
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
                      required this.user }) :
                        super(key: key);
  final User user;
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
              print("set name to bike");
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
              bikeData["notes"] = [value];
             
            },
          ),


          ElevatedButton(
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();
                sendBikeData(bikeData);
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


// information/instructions: This function is called when user submits
// data to the form. The function converts the data to JSON and updates
// the database.
// @params: bikeData(), data from the user is not needed, because bike
// is updated with necessary user data inside the form widget.
// @return: no return value. Just updates the database. 
// bugs: no known bugs
void sendBikeData(var bikeData) {
  print("sendBikeData()");
  print(bikeData);
  // The following values are currently hardcoded, but should
  // be from the user when they upload a photo, their location, 
  // etc.
  bikeData["image"] = "default_image_string";
  bikeData['location_long'] = 25;
  bikeData['location_lat'] = -25;
  
  print('test');
  createBike(bikeData);
  //test();
  
}


