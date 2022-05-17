import 'package:http/http.dart' as http;
import 'models.dart';
import 'dart:convert';
import 'global_values.dart';


void test1() async {
  print('running test');
  final response = await http.get(
    Uri.parse(globalUrl),
  );
  print('Response body: ${response.body}');
  
}

void createBikeTest() async {
  print('running create Bike test');
  final headers = <String, String>{
    "Content-Type": "application/json; charset=UTF-8",
    "Access-Control-Allow-Origin": "*",
    "Authorization": "Bearer " + authCode
  };
  String dataString =  '{"image":"testLink",'; 
  dataString += '"lock_combination":321,';
  dataString += '"location_long":25,';
  dataString += '"location_lat":-25}';
  print(dataString);
  final response = await http.post(
    Uri.parse(globalUrl+ '/bikes'),
    headers: headers, 
    body: dataString 
  );
  print(response.statusCode.toString());
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



// Future<String> getBikeList() async {
//   final response = await http.post(
//     Uri.parse('http://localhost:5000/bikes'),
//     headers: <String, String>{
//       //'Content-Type': 'application/json; charset=UTF-8',
//       //'Bearer-Token': 'wtf-is-this-again-and-where-do-I-get-it?'
//     },
//     body: newBike.toJson() 
//   );

//   if (response.statusCode == 201) {
//     // If the server did return a 201 CREATED response,
//     // then parse the JSON.
//     print('Success: bike created');
//      } 
//   else if (response.statusCode == 400) {
//     throw Exception('Failure: Bad request. Failed to add bike.');
//   }
//   else if (response.statusCode == 401) {
//     throw Exception('Failure: Unauthorized. Invalide access token.');
//   }
//   return Bike.fromJson(jsonDecode(response.body)); 
  
// }




Future<String> getImageDownloadLink(fileStringBase64) async {
  String requestBody = '{"image": "' + fileStringBase64 +'"}';
  
  final response = await http.post(
      //Uri.parse("http://10.0.2.2:5000/bikes"), // use when not using emulator
    Uri.parse(globalUrl + '/images'),// use whn using emulator
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Access-Control-Allow-Origin": "*",
      "Authorization": "Bearer "+ authCode
    },
    body: requestBody
  );
  print('/images request body: ' + requestBody);
  int statusCode = response.statusCode;
  print('/images status code: $statusCode');
  if (response.statusCode == 200) {
    print('Success:');
    print('/images response: ' + response.body);
    var json = jsonDecode(response.body);
    
    //print(json["url"]);
    String downloadLink = json["url"];
    //print(downloadLink);
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
