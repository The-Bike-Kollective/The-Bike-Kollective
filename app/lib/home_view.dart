import 'package:flutter/material.dart';


// information/instructions: Flutter Widget; This is the home view, when the
      //user first opesn the app and is not signed in.
// @params: no params
// @return: nothing returned
// bugs: no known bugs
// TODO: Figure out the cross-origin problem for images. 
// 
class HomeView extends StatelessWidget {
  const HomeView({ Key? key }) : super(key: key);
  final String aboutUs = "We help communities share bikes.";
  @override
  Widget build(BuildContext context) {
    return Column(
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
        );
  }
}


// information/instructions: Stateless Flutter Widget, to be rendered by 
  // the HomeView widget. Contains the three buttons on the 
  //main homescreen.
// @params: no params
// @return: nothing returned
// bugs: no known bugs
// TODO: I think we want to center the buttons eventually. 
// TODO: navigate to a form to create new account.
class HomeButtonGroup extends StatelessWidget {
  const HomeButtonGroup({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
           
            debugPrint('Create Account Clicked');
          },
          child: const Text('Create Account'),
        ),
        OutlinedButton(
          onPressed: () {
            // TODO: navigate to a form to exit application.
            debugPrint('Quit Clicked');
          },
          child: const Text('Quit'),
        ),
      ],
    );
  }
}
