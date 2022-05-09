import 'package:http/http.dart' as http;
import 'models.dart';
import 'dart:convert';

//this will hold the url to the cloud db. 
const String globalUrl = "http://ec2-35-164-203-209.us-west-2.compute.amazonaws.com:5000";


//This is an auth code that works at the time I am writing this. 
// It will likely not work in the future. To get a new authorization,
// go to /login, copy the code and post to /user with that code to get a 
// new user object with a new authcode.  
String authCode = "ya29.A0ARrdaM84x1ek_XNbAVvwH6mVAi9Q2tAtAnQ6P--hcPY9ZVVPOFD7sEf_NcoNacnR01ylboWOqCwyRC7J67FVtq9pZ8PpVyLdEtfplke4eM0bJxQkyxHMxzNVqj8qfv0XHX1lhfrFPuxpO3wLssyF98OWuIuu";



void test() async {
  
  final response = await http.get(
    Uri.parse('http://localhost:5000/'),
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
Future<Bike> createBike(bikeData) async {
  
  // temporary fix unit backend can accept the rest of the data
  var truncatedData = {};
  truncatedData['image'] = bikeData['image'];
  truncatedData['lock_combination'] =bikeData['lock_combination'];
  truncatedData['location_long'] = bikeData['location_long'];
  truncatedData['location_lat'] = bikeData['location_lat'];
  
  
  // after the backend can accept the rest of the bikeData,
  // we can assign jsonEncode(BikeData) to datastring:
  String dataString = jsonEncode(truncatedData);
  //String dataString = jsonEncode(bikeData);
  print(dataString);
  print('test1');
  final response = await http.post(
    Uri.parse("http://localhost:5000/bikes"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8",
      "Access-Control-Allow-Origin": "*",
      "Authorization": "Bearer "+ authCode
    },
    body: dataString 
  );
  if (response.statusCode == 201) {
    print('Success: bike created');
    } 
  else if (response.statusCode == 400) {
    throw Exception('Failure: Bad request. Failed to add bike.');
  }
  else if (response.statusCode == 401) {
    throw Exception('Failure: Unauthorized. Invalide access token.');
  } 

  print('response.body:');
  print(response.body);
  var json = jsonDecode(response.body); 
  print('json:');
  print(json);
  return Bike.fromJson(json); 
  //return Bike();
}

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





