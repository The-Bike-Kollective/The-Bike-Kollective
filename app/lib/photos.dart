import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';


// information/instructions: This function uses Image picker to have
// the user choose an image from the gallery, and returns the image
// encoded as a  string, base64. 
// @params: none
// @return: none
// bugs: 
// 1.This happened once and the app closed, but I haven't found the cause:
// E/DisplayEventDispatcher( 4761): Display event receiver pipe was closed or an error occurred.  events=0x9
// E/OpenGLRenderer( 4761): Display event receiver pipe was closed or an error occurred.  events=0x9        
// W/SurfaceComposerClient( 4761): ComposerService remote (surfaceflinger) died [0xe9b11d70]
// Lost connection to device.
// 2. Occationally I get an error "Connection reset by peer." I haven't found the 
// cause, and so for the only fix seems to be to restart the emulator. 
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