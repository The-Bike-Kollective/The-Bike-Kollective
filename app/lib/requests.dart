import 'package:http/http.dart' as http;
import 'models.dart';
import 'dart:convert';

Future<http.Response> fetchResponse() async {
  String url = 
    'https://sandbox.api.service.nhs.uk/hello-world/hello/world';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(response.body);
    return response;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to get data');
  }
}


Future<Bike> createBike(Bike newBike) async {
  print("createBike()");
  final response = await http.post(
    Uri.parse('http://localhost:5000/bikes'),
    headers: <String, String>{
      //'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer ya29.A0ARrdaM8SE1M_BoQ9KeC6DowJkwYH-4IX-hMA_HiiQu6JHPpPglBjRyXOgtVwZnXD_9aJ-MnO5-cWkFTbwzYmYzUMeU1_XVf4lxV_hUiFLkAnjIoHOmU6_HjhFNDQS_AVG0feUL4q6CYlFnUPdsxEYil0Q1qH"

      //'Authorization': '4/0AX4XfWjjvF3_SlxV1wbnvoTIH80NEKImLzw0LfDMBDdYSx-ra0_ooC_5OQXuv3EGzbK-JA'
    },
    body: newBike.toJson() 
  );

  print(response.statusCode);
  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    print('Success: bike created');
     } 
  else if (response.statusCode == 400) {
    throw Exception('Failure: Bad request. Failed to add bike.');
  }
  else if (response.statusCode == 401) {
    throw Exception('Failure: Unauthorized. Invalide access token.');
  }
  print(response.body);
  return Bike.fromJson(jsonDecode(response.body)); 
  
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