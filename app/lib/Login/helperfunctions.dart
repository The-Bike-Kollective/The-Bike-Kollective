import 'dart:math';
import 'package:flutter/material.dart';

//define global variables here
String randomizedString = 'notnull';

// information/instructions: this function is called by
// the _launchURLInApp function to generate the last
// parameter of randomized characters
// @params: none
// @return: return randomized string
// bugs: none
// TODO: none
String generateRandomString(int len) {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

void getRandomizedString() {
  randomizedString = generateRandomString(10);
  debugPrint(randomizedString);
}

String getState() {
  final state = randomizedString;
  debugPrint(state);
  return state;
}
