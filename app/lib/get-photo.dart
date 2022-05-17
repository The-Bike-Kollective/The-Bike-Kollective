import 'package:flutter/material.dart';
import 'package:the_bike_kollective/add-bike-page.dart';
import 'photos.dart';
import 'add-bike-page.dart';
import 'dart:convert';
import 'dart:io';
import 'add-bike-page.dart';
import 'package:image_picker/image_picker.dart';


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
              //Future<String> fileBase64 = getImageFromGalleryAsBase64();
              
              //Future<String> pickImage() async {
                String imagePath,img64;
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
              
            
              

              


              ////////////////////
              /// // Implementing the image picker
  // Future<void> _openImagePicker() async {
  //   final XFile? pickedImage =
  //       await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedImage != null) {
  //     setState(() {
  //       _image = File(pickedImage.path);
  //     });
  //   }
  // }

  ///






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