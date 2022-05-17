import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';



Future<String> getImageFromGalleryAsBase64() async {
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    String imagePath = image!.path;
    final bytes = File(imagePath).readAsBytesSync();
    String img64 = base64Encode(bytes);
    print('abbreviated base64: ' + img64.substring(0, 100));  
    return img64;
  }
  catch(e) {
    print(e);
    return "";
  }

}