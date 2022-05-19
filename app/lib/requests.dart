import 'package:http/http.dart' as http;
import 'models.dart';
import 'mock_data.dart';
import 'dart:convert';
import 'global_values.dart';

Map <String,String>headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "Access-Control-Allow-Origin": "*",
      "Authorization": "Bearer "+ currentUser.getAccessToken()};


void test() async {
  print('running test');
  final response = await http.get(
    Uri.parse(globalUrl),
  );
  print('Response body: ${response.body}');
  
}

// information/instructions: Function creates a bike on the database, using
// data from the new bike form. 
// @params: bikeData, which will be a json object that will form the 
// body of the request.
// @return: returns a Bike object for front end use, that will be a copy
// of the bike written to the database.
// bugs: Right now the returned bike will be slightly different from the 
// bike on the database because we can currently only add the required four 
// attributes to the databse.
// TODO: 
// add functionality to upload photo
// get user location to add those coordinates to the bike object.



Future<BikeListModel> getBikeList() async {
  final response = await http.get(
    Uri.parse(globalUrl+ '/bikes'),
    headers: headers
  );
  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    print('Success with code 200: bike list received');
    // print(response.body);
    BikeListModel currentBikes = BikeListModel.fromDataString(response.body);
    return currentBikes;
    
  } 
  else if (response.statusCode == 400) {
    throw Exception('Failure with code 400: Bad request.');
  }
  else if (response.statusCode == 401) {
    throw Exception('Failure with code 401: Unauthorized. Invalide access token.');
  }
  else {
    throw Exception('Something got messed up in getBikeList()');
  } 
  
}


// BikeListModel currentBikes = BikeListModel.fromDataString(response.body)
// bikeList.then((bikeListAsString){
      //   // split string into a list 
      //   final bikeListAsList 
      //     = bikeListAsString.split("},");
      //   int listLength = bikeListAsList.length;
      //   // remove opening bracket '[' from first item  
      //   bikeListAsList[0] = bikeListAsList[0].substring(1);
      //   int lastItemLength = bikeListAsList[listLength-1].length;
      //   // remove closing bracked ']' from last item
      //   bikeListAsList[listLength-1] 
      //     = bikeListAsList[listLength-1].substring(0,lastItemLength-1);  

      //   // print(bikeListAsList[0]);
      //   // print(bikeListAsList[6]);
      //   for(int i = 0; i< listLength; i+= 1) {
      //     print(bikeListAsList[i]);
      //   }

      //});






Future<String> getImageDownloadLink(fileStringBase64) async {
  String requestBody = '{"image": "' + fileStringBase64 +'"}';
  
  final response = await http.post(
      //Uri.parse("http://10.0.2.2:5000/bikes"), // use when not using emulator
    Uri.parse(globalUrl + '/images'),// use whn using emulator
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Access-Control-Allow-Origin": "*",
      "Authorization": "Bearer "+ currentUser.getAccessToken()
    },
    body: requestBody
  );
  if (response.statusCode == 200) {
    print('Success:');
    var json = jsonDecode(response.body);
    //TODO: Update access token.
    String downloadLink = json["url"];
    return downloadLink;
  } 
  else if (response.statusCode == 400) {
  
    throw Exception('Failure: Bad request.');
  }
  else if (response.statusCode == 401) {
    throw Exception('Failure: Unauthorized.');
  } 
  return "something is messed up";
  //throw Exception('Failure: unknown error');
 
}
