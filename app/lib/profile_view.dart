import 'package:flutter/material.dart';
import 'models.dart';
import 'mock_data.dart';

// information/instructions: ProfileView is a template that will
// conditionally render profileViewA or ProfileViewB. If property 
// hasABikeCheckedOut is true, ProfileViewA is rendered, otherwise
// ProfileViewB is rendered.
// @params: required User object with a property HasABikeCheckedOut.
// @return: nothing returned
// bugs: no known bugs
// TODO: 
// 1. style these ugly pages
class ProfileView extends StatefulWidget {
  //final User user;
  const ProfileView({ Key? key/*, required this.user*/ }) 
      : super(key: key);

  static const routeName = '/profile-view';
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

// This is the state class that is used by ProfileViewState.
class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Bike Collective')
        ),
      body: currentUser.hasABikeCheckedOut ? 
          ProfileViewA(): 
          ProfileViewB()
      );
  }
}


// information/instructions: Both ProfileViewA and B are rendered by 
// ProfileView, depending on whether the user has a bike checked out.
// @params: required User object with a property HasABikeCheckedOut.
// @return: nothing returned
// bugs: no known bugs
// TODO: 
// 1. style these ugly pages
// 2. Preload the image
// 3. Make the buttons functional
class ProfileViewA extends StatelessWidget {
  //final User user;
  const ProfileViewA({ Key? key/*, required this.user*/ })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(children:  [
      const Text('Welcome, [username]!'),
      const Text('You currently have a bike checked out.'),
      const Text('Bike Info:'),
      const Text('Bike Name: [bikeName'),
      const Text('Bike ID: [bikeId'),
      const CheckedOutBikeRow(),
      OutlinedButton(
        onPressed: () {
          debugPrint('Return Bike button clicked');
        },
        child: const Text('Return Bike'),
      ),
    ],
  );   
  }
}

// information/instructions: Both ProfileViewA and B are rendered by 
// ProfileView, depending on whether the user has a bike checked out.
// @params: required User object with a property HasABikeCheckedOut.
// @return: nothing returned
// bugs: no known bugs
// TODO: 
// 1. style these ugly pages
// 2. Preload the image
// 3. Make the buttons functional
class ProfileViewB extends StatelessWidget {
  //final User user;
  const ProfileViewB({ Key? key/*, required this.user*/ }) 
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
        const Text('Welcome, [username]!'),
        OutlinedButton(
          onPressed: () {
            debugPrint('Find a Bike button clicked');
            Navigator.pushNamed(
              context, '/bike-list'
            );
          },
          child: const Text('Find a Bike'),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.pushNamed(
              context, '/add-bike',
            );       
            debugPrint('add bike clicked');   
          },
          child: const Text('Add a Bike'),
        ),
      ],
    );  
  }
}


// information/instructions: Rendered by profileViewA, when the 
// user has a bike that is checked out. 
// @params: Bike
// @return: Renders row with info about the bike that is
// checked out
// bugs: no known bugs
// TODO: 
// 1. Stub at this point. 
// 2. Needs to be set up to take Bike(), and render using
//    the data from the Bike.

class CheckedOutBikeRow extends StatelessWidget {
  const CheckedOutBikeRow({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       
        Image.asset('assets/coolBike.jpeg',
          width: 200,
          fit:BoxFit.cover  
        ),
        const Text('Due Back in 22 Minutes')

      ],
      
    );
  }
}
