import 'package:flutter/material.dart';
import 'models.dart';


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
  final User user;
  const ProfileView({ Key? key, required this.user }) 
      : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Bike Collective')
        ),
      body: widget.user.hasABikeCheckedOut ? 
          ProfileViewA(user: widget.user): 
          ProfileViewB(user: widget.user)
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
  final User user;
  const ProfileViewA({ Key? key, required this.user }) 
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

    ],);
      
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
  final User user;
  const ProfileViewB({ Key? key, required this.user }) 
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
        const Text('Welcome, [username]!'),
        OutlinedButton(
          onPressed: () {
            debugPrint('Find a Bike button clicked');
          },
          child: const Text('Find a Bike'),
        ),
        OutlinedButton(
          onPressed: () {
            debugPrint('Add a Bike button clicked');
          },
          child: const Text('Add a Bike'),
        ),
      ],
    );
      
  }
}

class CheckedOutBikeRow extends StatelessWidget {
  const CheckedOutBikeRow({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       
        Image.asset('assets/coolBike.jpeg',
          width: 200,
          fit:BoxFit.cover  ),
        const Text('Due Back in 22 Minutes')

      ],
      
    );
  }
}
