import 'package:flutter/material.dart';
import 'package:the_bike_kollective/Login/user_agreement.dart';


// information/instructions: The drawer pulls out when the user
// clicks on the menu icon found in the appBar. This Widget is 
// rendered in the appBar under the "endDrawer" attribute. 
// @params: no params
// @return: nothing returned
// [bugs]:

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text('Menu'),
          ),
          //temporary measure to display profile view without back-end implementation
          ListTile(
            title: const Text("User Profile"),
            onTap: (){
              Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AgreementPage()),
              );
            },
          )
        ]
      )
    ); 
  }
}