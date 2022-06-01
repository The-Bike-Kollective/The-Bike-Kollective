import 'package:flutter/material.dart';

Map tags = {'size': '', 'type': ''};

Map buttonStyle = {
  'textColor': Colors.white,
  'backgroundColor':Colors.blue.shade900,
  'reportBackground': Colors.red,
  'main': OutlinedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                primary: Colors.white
              ),
};

Map dropdownStyle = {
  'textColor': Colors.black,
};

Map bikeListStyle = {
  'textStyle': const TextStyle(fontSize: 32),
};

Map pagesStyle = {
  'defaultText':const TextStyle(fontSize: 18, color: Colors.white),
  'italicSubtitle' :const TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
  'welcomeMessage' :const TextStyle(fontSize: 22, 
        fontStyle: FontStyle.italic,
        color: Colors.white)


};

Map appStyle = {
  'backgroundColor': Colors.green
};