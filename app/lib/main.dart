import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

// This is adapted from the starter Flutter app, just
// to get us going. Some of the comments are from that
// original starter counter app.
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Bike Kollective',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: const HomeView(),
    );
  }
}

// I made this as a stateless Widget, thinking that this screen should
// only show if the user is not logged in, so there will not be a need to 
// access the state, since the screen will always look the same.
class HomeView extends StatelessWidget {
  const HomeView({ Key? key }) : super(key: key);
  
  final String title = "The Bike Kollective";
  final String aboutUs = "We help communities share bikes.";  
  // I tried using network Image at first, but ran into some trouble
  // with cross-origin requests, and I couldn't remember how to fix it.
  // This was the url for a placeholder image, which is currently not
  // being used.
  //final String bannerImageUrl = "https://via.placeholder.com/468x60";
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      endDrawer: const MenuDrawer(),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //This is just a placeholder image for now. We can change 
            // if we want to. We can use network images from a URL, but 
            // there is a step to allow cross-origin requests, and 
            // I can't remember what I did before, so for now I am using
            // an asset image.
            Image.asset('assets/bikes.png'),
            Text(aboutUs),
            const HomeButtonGroup()
          ],
        ),
      
    );
  }
}


// This widget is the three buttons on the home page. I 
// think we want to center them eventually.
class HomeButtonGroup extends StatelessWidget {
  const HomeButtonGroup({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // to do: Figure out how to center these buttons. 
      children: [  
        OutlinedButton(
          onPressed: () {
            // This was copied in pasted from the docs. Debug print
            // prints the message to the console. All the buttons work
            // so we know this is where we put the code to do whatever
            // we want this button to do.
            debugPrint('sign in clicked');
          },
          child: const Text('Sign In'),
        ),
        OutlinedButton(
          onPressed: () {
            //to do: navigate to a form to create new account.
            debugPrint('Create Account Clicked');
          },
          child: const Text('Create Account'),
        ),
        OutlinedButton(
          onPressed: () {
            // to do: navigate to a form to exit application.
            debugPrint('Quit Clicked');
          },
          child: const Text('Quit'),
        ),
      ],
    );
  }
}

// The menu drawer comes out when you click on the icon. 
// To do: decide which items should be in the menu. 
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
          // To do: The items below will be changed to links
          // that navigate to whevever we want them to.
          Text('Item 1'),
          Text('Item 2'),
        ]
      )
    ); 
  }
}

