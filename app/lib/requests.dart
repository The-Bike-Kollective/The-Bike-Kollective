import 'package:http/http.dart' as http;
import 'models.dart';
import 'dart:convert';
import 'global_values.dart';
import 'package:flutter/material.dart';
import 'package:the_bike_kollective/global_values.dart';
import 'package:the_bike_kollective/profile_view.dart';
import 'package:the_bike_kollective/Login/post_model.dart';
import 'package:http/http.dart';
import 'package:the_bike_kollective/Login/user_agreement.dart';
import 'package:the_bike_kollective/Login/helperfunctions.dart';
import 'package:the_bike_kollective/login_functions.dart';
import 'Maps/map_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';


// get headers for requests.
Map<String,String> getHeaders() {
  String? currentAccessToken = getAccessToken();
 
  Map <String,String>headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "Access-Control-Allow-Origin": "*",
      "Authorization": "Bearer $currentAccessToken"};
  return headers;
}


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
  print('getBikeList()');
  final response = await http.get(
    Uri.parse(getGlobalUrl()+ '/bikes'),
    headers: getHeaders()
  );
  print('status code' + response.statusCode.toString() );
  if (response.statusCode == 200) {
    print('Success: Bike list received');
    //print('response body' + response.body);
    final responseJson = jsonDecode(response.body);
    //print('response json: ');
    //print(responseJson['bikes'].toString() );    
    BikeListModel currentBikes = BikeListModel();
    Bike newBike;
    var newBikeJson;
    num numBikes = responseJson['bikes'].length;
    for(int i = 0; i < numBikes; i += 1) {
      print('index: $i');
      newBikeJson = responseJson['bikes'][i];
      newBike = Bike.fromBikeList(newBikeJson);
      print('Bike Name: ' + newBike.getName());
      currentBikes.addBike(newBike);
    }
    // update access token
    String newAccessToken = responseJson['access_token'];
    updateAccessToken(newAccessToken);   

    return currentBikes;
  } 

  String message;
  switch(response.statusCode) {
    case 400: {
      message = 'Bad request.';
      break;
    }
    case 401: {
      launchURLInApp(); 
      message = 'Unauthorized. Invalid access token.';
      break;
    }
    case 404: {
      launchURLInApp(); 
      message = 'User not found. Non-existing access token.';
      break;
    }
    default: {
      message = 'Error on login.';
    }
  }
  throw Exception('known error');
 
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
    headers: getHeaders(),
    body: requestBody
  );
  print("After getImageLink() request, response body: ");
  print(response.body);
  if (response.statusCode == 201) {
    print('Success: Image Uploaded');
    var responseJson = jsonDecode(response.body);
    // update access token
    String newAccessToken = responseJson['access_token'];
    updateAccessToken(newAccessToken);   
    // get donwload url
    String downloadLink = responseJson["url"];

    return downloadLink;
  } 

  String message;
  switch(response.statusCode) {
    case 400: { 
      message = 'Bad request.';
      break;
    }
    case 401: {
      launchURLInApp(); 
      message = 'Unauthorized. Invalid access token.';
      break;
    }
    case 404: {
      launchURLInApp(); 
      message = 'User not found. Non-existing access token.';
      break;
    }
    default: {
      message = 'Error getting image link.';
    }
  }
  throw Exception(message);

}


// information/instructions: This function is called when
// the checkout button on the bike detail view is called.
// The check in doesn't work yet.
// @params: none
// @return: none
// bugs:
// TODO: 
// 1. Get lock combination and save it. (Using shared prefences, 
// but have not been able to get it to work.)
Future checkOutBike(bikeId) async {
  //Build request url
  String requestUrl = getGlobalUrl();
  requestUrl += '/bikes';
  requestUrl += '/$bikeId/';
  requestUrl += getCurrentUserIdentifier()!;

  //Build request body
  List coordinates = generateCoordinates();
  String locationLong = coordinates[0].toString();
  String locationLat = coordinates[1].toString();
  String requestBody;
  requestBody = '{"location_long":$locationLong,';
  requestBody += '"location_lat":$locationLat}';
  // print(requestUrl);
  print(requestBody);
  final response = await http.post(
    Uri.parse(requestUrl),
    headers: getHeaders(),
    body: requestBody
  );
  print(response.statusCode);
  print('checkOUtBike() response body: ' + response.body);
  var responseJson = jsonDecode(response.body);
  
  if (response.statusCode == 200) {
    print("checkOutBike() success: ");
    print(responseJson['message']);
    // update access token
    String newAccessToken = responseJson['access_token'];
    updateAccessToken(newAccessToken); 
    int newCombo = responseJson['lock_combination'];
    print('new combo: $newCombo');
    
    // save combination using global:
    //setCheckedOutBikeCombo(newCombo);

    // save combination using sharedPreferences:
    // obtain shared preferences
    print('checkoutBike test1');
    final prefs = await SharedPreferences.getInstance();

    // set value
    await prefs.setInt('combination', newCombo);  
    print('checkoutBike test2');
    return;
  } 

  String message;
  switch(response.statusCode) {
    case 400: { 
      message = 'Bad request.';
      break;
    }
    case 401: {
      launchURLInApp(); 
      message = 'Unauthorized. Invalid access token.';
      break;
    }
    case 404: {
      launchURLInApp(); 
      message = 'User not found. Non-existing access token.';
      break;
    }
    default: {
      message = 'Error with bike checkout.';
    }
  }
  throw Exception(message);

}


// information/instructions: getUser is called when the profileView
// is rendered.
// @params: none
// @return: none
// bugs: No known bugs
// TODO: 
Future<User> getUser(userId) async {
  print("getUser()");
  String requestUrl = getGlobalUrl();
  String? currentUserIdentifier =  getCurrentUserIdentifier();
  requestUrl += '/users/$currentUserIdentifier';
  print('getUser() requestUrl: ' + requestUrl);

  final response = await http.get(
    Uri.parse(requestUrl),
    headers: getHeaders()
  );
  print('getUser() response.statusCode: ' + response.statusCode.toString());
  print('getUser() reponse.body: ' + response.body);
  if (response.statusCode == 200) {
    print('Success with code 200: user info received');
    String responseBody = response.body;
    var responseJson = jsonDecode(responseBody);
    User userData = User.fromJson(responseJson);    
    // update access token
    updateAccessToken(userData.getAccessToken());
    return userData;
    
  } 

  String message;
  switch(response.statusCode) {
    case 400: { 
      message = 'Bad request.';
      break;
    }
    case 401: {
      launchURLInApp(); 
      message = 'Unauthorized. Invalid access token.';
      break;
    }
    case 403: {
      message = 'The client does not have access rights to the content.';
      break;
    }
    
    case 404: {
      launchURLInApp(); 
      message = 'User not found. Non-existing access token.';
      break;
    }

    case 500: {
      message = 'Multiple USER ERROR.';
      break;
    }

    default: {
      message = 'Error getting user.';
    }
  }
  throw Exception(message);

}


// information/instructions: gets a singble bike object from the db.
// is rendered.
// @params: bike ID string
// @return: a Future, so to actually get the data, you have to call
// then on the return value. Since this took me a while to figure out,
// here is an example for future (pun was unintentional) reference:
// 
//  Future<Bike> bikeFromDatabase = getBike(someBikeId);
//  bikeFromDatabase.then( (receivedBikeObject) {
//    //Do something with the data you received here.
//  });

//// bugs: No known bugs
//
// TODO: 
// 1. remove print statements (keeping there there for now beacause 
// // they help with debugging)
Future<Bike> getBike(String bikeId) async {
  String requestUrl = getGlobalUrl();
  requestUrl += '/bikes/$bikeId';
  print('getBike() requestUrl: $requestUrl');
  final response = await http.get(
    Uri.parse(requestUrl),
    headers: getHeaders()
  );
  String responseBody = response.body;
  
  print('getBike() response body: $responseBody');
  var json = jsonDecode(responseBody);
  if (response.statusCode == 200) {
    print('Success: bike received');
    Bike bikeData = Bike.fromJson(json);

    //update access token   
    updateAccessToken(bikeData.getAccessToken());
    
    return bikeData;
    
  } 
  else if (response.statusCode == 404) {
    throw Exception('Failure: ' + json['message']);
  }
  else if (response.statusCode == 403) {
    throw Exception('Failure: ' + json['message']);
  }
  else if (response.statusCode == 500) {
    throw Exception('Failure: ' + json['message']);
  }
  else if (response.statusCode == 401) {
    launchURLInApp();
    throw Exception('Failure: ' + json['message']);
  }
  else {
    throw Exception('Failure: ' + json['message']);
  } 

}


// information/instructions: Returns the bike, updating the bike and the user on
// the database. This function is called after the user submits the returnBike
// form, using data captured by that form to return the bike.
// @params: bikeId, note, rating.
// @return: nothing returned
// bugs: no known bugs
// TODO: 
// 1. remove print statements (keeping there there for now beacause 
// // they help with debugging)
Future returnBike(String bikeId, String? note, num rating) async {
  print('returnBike()');
  String starRating = rating.toString();
  String? requestUrl = getGlobalUrl();
  List coordinates = generateCoordinates();
  String locationLong = coordinates[0].toString();
  String locationLat = coordinates[1].toString();
  requestUrl += '/bikes/$bikeId/';
  requestUrl += getCurrentUserIdentifier().toString();
  
  
  String requestBody = '{"location_long":$locationLong,';
  requestBody += '"location_lat":$locationLat,';
  requestBody += '"note": "$note",';
  requestBody += '"rating":$starRating,';   
  requestBody += '"condition": true}';

  print('checkIn() requestUrl: ');
  print(requestUrl);
  print('checkIn() requestBody:');
  print(requestBody);

  final response = await http.delete(
    Uri.parse(requestUrl),
    headers: getHeaders(),
    body: requestBody
  );
  print('check in status code: ' + response.statusCode.toString());
  print(response.body);
  if (response.statusCode == 200) {
    print('Success: checkIn successful');
     
    //update access token 
    final responseJson = jsonDecode(response.body);
    String newAccessToken = responseJson['access_token'];
    updateAccessToken(newAccessToken);
  } 
  String message;
  switch(response.statusCode) {
    case 400: { 
      message = 'Bad request.';
      break;
    }
    case 401: {
      launchURLInApp(); 
      message = 'Unauthorized. Invalid access token.';
      break;
    }

    case 409: { 
      message = 'Checkout failed.';
      break;
    }
    case 403: {
      message = 'The client does not have access rights to the content.';
      break;
    }
    

    case 500: {
      message = 'Multiple USER ERROR.';
      break;
    }

    default: {
      message = 'Error getting user.';
    }
  }
  throw Exception(message);
}

// information/instructions: Creates a bike on the data base. Use 
// must select a photo from the gallery.
// @params: none
// @return: 
// bugs: no known bugs
// TODO:
  //get permission from user to access location
  // get users location to be saved as bike's current location.
  // add spinning wheel for pictures not yet loaded
  // return to login if token is wrong
Future createBike(bikeData) async {

  print('createBike()');
  //TODO: create function to generate random location near OSU.
  List coordinates = generateCoordinates();
  String locationLong = coordinates[0].toString();
  String locationLat = coordinates[1].toString();
  
  bikeData['location_long'] = locationLong;
  bikeData['location_lat'] = locationLat;
  //TODO: Users choose size and type.
  bikeData['size'] = 'size 2';
  bikeData['type'] = 'type 2';
  String requestBody = jsonEncode(bikeData);
  String requestUrl = getGlobalUrl();
  String? accessToken = getAccessToken();
  requestUrl += '/bikes';
  Map <String,String>headers = {
      "Content-Type": "application/json; charset=UTF-8",
      "Access-Control-Allow-Origin": "*",
      "Authorization": "Bearer $accessToken"};
  // for debugging (delete later)
  print('request url' + requestUrl);
  print('request body:' + requestBody);
  final response = await http.post(
    Uri.parse(requestUrl),
    headers: headers,
    body: requestBody 
  );
  print("status code: " + response.statusCode.toString());
  if (response.statusCode == 201) {
    print('Success: bike created');
    //update access token
    final body = jsonDecode(response.body);
    String newAccessToken = body['access_token'];
    updateAccessToken(newAccessToken);   
              
  } 
  else if (response.statusCode == 400) {
    throw Exception('Failure (code 400): Bad request. Failed to add bike.');
  }
  else if (response.statusCode == 401) {
    launchURLInApp();
    throw Exception('Failure (code 401): Unauthorized. Invalid access token.');
  }

}


// information/instructions: I didn't write this function, but I noticed it
// doesn't have a header. I think it basically logs the user in and then 
// navigates to the agreements page.
// @params: none
// @return: 
// bugs: no known bugs
// TODO:
// 1. perhaps update the header if there is time
void postState(context) async {
  Customer user;
  final String state = getState();

  String requestUrl = getGlobalUrl();
  requestUrl += '/users/signin';

  //post request with state
  var response = await post(
      Uri.parse(requestUrl),
      body: {"state": state});

  //response from back-end with user data
  debugPrint('Response body: ${response.body}');

  //if response succesful
  if (response.statusCode == 200) {
    final res = json.decode(response.body);
    user = Customer.fromJson(res["user"]);
    print('token: ' + user.accessToken.toString());
    updateAccessToken(user.accessToken);
    updateCurrentUserIdentifier(user.identifier);
    //if user is a new user, then direct to agreement page
    if (user.signedWaiver == false) {
      //assign access token to global variable for front-end use  
      //push user to agreement page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => AgreementPage())
        )
      );
      //need to pass through user information to end up at profile page
      //access_token: user.accessToken, test: 'Teddy bear'))));
      //if an existing user
    } else if (user.signedWaiver == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => const ProfileView())
        )
      );
    }
  } else {
    // show error
    print("Try Again");
  }
}

// information/instructions: Changes the user info on the database to 
// reflect that the waiver has been signed. 
// @params: none
// @return: 
// bugs: no known bugs
// TODO: 
// 1. remove print statements (keeping there there for now beacause 
// // they help with debugging)
Future signWaiver() async {
  print("signWaiver()");
  String requestUrl = getGlobalUrl();
  String? currentUserIdentifier =  getCurrentUserIdentifier();
  requestUrl += '/users/waiver/$currentUserIdentifier';
  print('signWaiver() requestUrl: ' + requestUrl);

  final response = await http.post(
    Uri.parse(requestUrl),
    headers: getHeaders()
  );
  var responseJson = jsonDecode(response.body);
  print('signWaiver() response.statusCode: ' + response.statusCode.toString());
  print('signWaiver() reponse.body: ' + response.body);
  if (response.statusCode == 200) {
    print(responseJson['message']);  
    updateAccessToken(responseJson['access_token']); // update access token
    return;
  } 

  String message = "Error while signing waiver.";
  switch(response.statusCode) {
    case 404: { 
      launchURLInApp();
      message = responseJson['message'];
      break;
    }
    case 401: {
      launchURLInApp();
      message = responseJson['message'];
      break;
    }
    case 403: {
      launchURLInApp();
      message = responseJson['message'];
      break;
    }
    
    case 500: {
       message = responseJson['message'];
      break;
    }

    default: {
      throw Exception(message);
    }

  }
 

}
