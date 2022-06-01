import 'package:flutter/material.dart';
import 'package:the_bike_kollective/global_values.dart';
import 'package:the_bike_kollective/profile_view.dart';
import 'MenuDrawer.dart';
import 'requests.dart';
import 'models.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


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
class ReturnBikeForm extends StatelessWidget {
  const ReturnBikeForm({ Key? key }) : super(key: key);
  static const routeName = '/return-bike';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Bike Kollective'),
      ),
      endDrawer: const MenuDrawer(),
      body: const ReturnBikeFormBody(),
    );
  }
}

// information/instructions: This is the form inside the page, to keep things 
//a little neater. 
// @params: 
// @return: 
// bugs: no known bugs
class ReturnBikeFormBody extends StatefulWidget {
  const ReturnBikeFormBody({ Key? key }) : super(key: key);

  @override
  State<ReturnBikeFormBody> createState() => _ReturnBikeFormBodyState();
}

class _ReturnBikeFormBodyState extends State<ReturnBikeFormBody> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  var bikeData = {'rating': -1, 'note': ''};
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Rate the bike.
          const Text('Rate this Bike:'),
          RatingBar.builder(
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              bikeData['rating'] = rating;
            },
          ),
          // Add notes
          TextFormField(
            // The validator receives the text that the user has entered.
            decoration: const InputDecoration(
              icon: Icon(Icons.star),
              hintText: '[add notes (optional)]',
              labelText: 'Notes',
            ),
            
            onSaved: (value) {//save value of 'notes' field.
              if (value != null) {
                bikeData["note"] = value;
              } else {
                print('no notes added');
              }
               
            },
          ),  
          
          ElevatedButton(
            onPressed: () async {
              // Validate returns true if the form is valid, or false otherwise.
              User currentUser = await getUser(getCurrentUserIdentifier());
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();
                await returnBike(
                  currentUser.getCheckedOutBike(),
                  //getCheckedOutBike()!, 
                  bikeData['note'] as String,
                  bikeData['rating'] as num
                );
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Returning bike.')),
                );
                Navigator.pushNamed(context, ProfileView.routeName,);
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );



  }
}
