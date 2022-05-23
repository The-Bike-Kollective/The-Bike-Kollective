import 'package:http/http.dart' as http;
//import 'package:the_bike_kollective/access_token.dart';
import 'models.dart';
//import 'mock_data.dart';
import 'dart:convert';
import 'global_values.dart';

String? currentAccessToken = getAccessToken();

Map <String,String>headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "Access-Control-Allow-Origin": "*",
      "Authorization": "Bearer $currentAccessToken"};


// A test to make sure the api is running. 
void test() async {
  print('running test');
  final response = await http.get(
    Uri.parse(getGlobalUrl()),
  );
  print('Response body: ${response.body}'); 
}

// information/instructions: Get bike list from database first as
// a string, then parse to Json, then convert to BikeListModel
// @params: none
// @return: none
// bugs: no known bugs, but need to do some more testing
Future<BikeListModel> getBikeList() async {
  print(getAccessToken()); 
  print('getBikeList()');
  final response = await http.get(
    Uri.parse(getGlobalUrl()+ '/bikes'),
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


// information/instructions: Given a string in base64 which is the
// image to download, the image will be uploaded to the firebase store,
// and the link to access the image will be returned. 
// @params: String in base64 of the image to upload
// @return: Link to be used later to access the image.
// bugs: no known bugs, but need to do some more testing
Future<String> getImageDownloadLink(fileStringBase64) async {
  String requestBody = '{"image": "' + fileStringBase64 +'"}';
  
  final response = await http.post(
      //Uri.parse("http://10.0.2.2:5000/bikes"), // use when not using emulator
    Uri.parse(getGlobalUrl() + '/images'),// use whn using emulator
    headers: headers,
    body: requestBody
  );
  print("After getImageLink() request, response body: ");
  print(response.body);
  if (response.statusCode == 200) {
    print('Success: Image Uploaded');
    var json = jsonDecode(response.body);
    String downloadLink = json["url"];
    return downloadLink;
  } 
  else if (response.statusCode == 400) {
  
    throw Exception('Failure: Bad request.');
  }
  else if (response.statusCode == 401) {
    throw Exception('Failure: Unauthorized.');
  } 
  return "something is messed up in getImageDownloadLink().";
 
}


Future checkOutBike(bikeId, userId) async {
  print('bikeId: $bikeId');
  print('userId: $userId');
  //Build request url
  String requestUrl = getGlobalUrl();
  requestUrl += '/bikes';
  requestUrl += '/$bikeId';
  requestUrl += '/$userId';

  print(requestUrl);
  //Build request body
  //TODO: get user location
  String locationLong = '25';
  String locationLat = '-25';
  String requestBody;
  requestBody = '{"location_long":$locationLong,';
  requestBody += '"location_lat":$locationLat}';
  print('check out bike request body:' + requestBody);
  final response = await http.post(
    Uri.parse(requestUrl),
    headers: headers,
    body: requestBody
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


Future<User> getUser(userId) async {
  print('getUser()');
  print(userId);
  User userObject;
  String requestUrl = getGlobalUrl();
  requestUrl += '/users/6289cdeb048f418048b5f7ab';
  final response = await http.get(
    Uri.parse(requestUrl),
    headers: headers
  );

  print(response.statusCode);
  if (response.statusCode == 200) {
    print('Success with code 200: bike list received');
    String responseBody = response.body;
    var json = jsonDecode(response.body);
    User userData = User.fromJson(json);    
    updateAccessToken(userData.getAccessToken());
    return userData;
    
  } 
  else if (response.statusCode == 404) {
    throw Exception('Failure: User not found');
  }
  else if (response.statusCode == 403) {
    throw Exception('Failure: "The client does not have access rights to the content"');
  }
  else if (response.statusCode == 500) {
    throw Exception('Failure: "Multiple USER ERROR"');
  }
  else if (response.statusCode == 401) {
    throw Exception('Faulure: "unauthorized. invalid access_token or identifier"');
  }
  else {
    throw Exception('Something got messed up in getBikeList()');
  } 

}