import 'package:flutter/material.dart';
import 'package:the_bike_kollective/home_view.dart';


// information/instructions: Flutter Widget, rendered by App 
// widget. This widget renders the HomeView widget under its
// "home" attribute. This widget also contains the appBar, which
//  goes at the top of the page, and contains the MenuDrawer().
// @params: no params
// @return: nothing returned
// bugs: The structure may need to be modified slightly for 
// navigation. HomeView might have to become it's own Scaffold
// Widget. I'm not sure about that yet. 
// TODO: Investigate that potential bug listed above.

class MainScreen extends StatelessWidget {
  const MainScreen({ Key? key }) : super(key: key);
  final String title = "The Bike Kollective";
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      endDrawer: const MenuDrawer(),
      body: const HomeView()
      
    );
  }
}


// information/instructions: The drawer pulls out when the user
// clicks on the menu icon found in the appBar. This Widget is 
// rendered in the appBar under the "endDrawer" attribute. 
// @params: no params
// @return: nothing returned
// [bugs]:
// TODOs:decide which items should be in the menu.
// TODO: The items listed in the drawer will be changed to links.
// Suggestions: exit app, sign out, edit profile, 
// settings (if we have any). 

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          DrawerHeader(
            child: Text('Menu'),
          ),
          // TODO: The items below will be changed to links
          // that navigate to whevever we want them to.
          Text('Item 1'),
          Text('Item 2'),
        ]
      )
    ); 
  }
}

