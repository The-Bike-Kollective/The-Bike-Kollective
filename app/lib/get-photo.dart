import 'package:flutter/material.dart';
import 'package:the_bike_kollective/add-bike-page.dart';
import 'add-bike-page.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// information/instructions: In order to add a bike, user is directed
// to this page first and asked to select an image from the Gallery. 
// @params: none
// @return: none
// bugs: none that are known
//no known bugs, but need to do some more testing
class GetPhoto extends StatelessWidget {
  const GetPhoto({ Key? key }) : super(key: key);
  static const routeName = '/get-photo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Bike Collective')
      ),
      body: Row(
        children: [
          //upload photo
          OutlinedButton(
            onPressed: () async {
              debugPrint('Upload a Picture button clicked');
              String imagePath;
              final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedImage != null) {
                imagePath = pickedImage.path;
                final bytes = File(imagePath).readAsBytesSync();
                var img64 = base64Encode(bytes);
                //print(img64);
                Navigator.pushNamed(
                  context,
                  AddBikePage.routeName,
                  arguments: BikeFormArgument(img64)
                );
              } 
            },
            child: const Text('Upload a Picture'),
          ),
          //take a new photo
          OutlinedButton(
            onPressed: () {
              debugPrint('Upload a Picture button clicked');
            },
            child: const Text('Take a Picture'),
          ),

        ],
      )
    );
  }
}