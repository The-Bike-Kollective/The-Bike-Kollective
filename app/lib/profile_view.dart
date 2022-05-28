import 'package:flutter/material.dart';
//import 'package:the_bike_kollective/access_token.dart';
import 'package:the_bike_kollective/bike_list_view.dart';
import 'package:the_bike_kollective/get-photo.dart';
import 'package:the_bike_kollective/global_values.dart';
import 'mock_data.dart';
import 'models.dart';
import 'requests.dart';
import 'global_values.dart';
import 'package:the_bike_kollective/login_functions.dart';

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
  const ProfileView({ Key? key/*, required this.user*/ }) 
      : super(key: key);

  static const routeName = '/profile-view';
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

// This is the state class that is used by ProfileViewState.
class _ProfileViewState extends State<ProfileView> {
  Future<User> user = 
    getUser(getCurrentUserIdentifier() );
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Bike Collective')
        ),
      body: FutureBuilder<User>(
        future: user,
        builder: (context, AsyncSnapshot<User> snapshot) {
          if(snapshot.hasData) {
            User userData = snapshot.data!;
            String checkedOutBike = userData.getCheckedOutBike();
            return (checkedOutBike == "-1") ? 
              ProfileViewB(user: userData) : 
              ProfileViewA(
                bikeId: userData.getCheckedOutBike(),
                userGivenName: userData.getGivenName()
              );
          } else {
            return const CircularProgressIndicator();
          }
        }
      )
      );
  }
}


// information/instructions: Both ProfileViewA and B are rendered by 
// ProfileView, depending on whether the user has a bike checked out.
// ProfileViewA is shown if the user DOES have a bike checked out.
// @params: required User object with a property HasABikeCheckedOut.
// @return: nothing returned
// bugs: no known bugs
// TODO: 
// 1. style these ugly pages
// 2. Preload the image
// 3. Make the buttons functional
class ProfileViewA extends StatelessWidget {
  final String bikeId;
  final String userGivenName;
  const ProfileViewA({ Key? key, 
    required this.bikeId,
    required this.userGivenName })
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final Future<Bike> bikeData = getBike(bikeId);
    
    return FutureBuilder<Bike>(
      future: bikeData,
      builder: (context, AsyncSnapshot<Bike> snapshot) {
        if (snapshot.hasData) {
            Bike checkedOutBike = snapshot.data!;
            String bikeName = checkedOutBike.getName();
            String bikeId = checkedOutBike.getId();
            int lockCombination = checkedOutBike.getLockCombination();
            print('lock combo: $lockCombination');
             print('bikeName: $bikeName');
            return Column(
              children:  [
                Text('Welcome, $userGivenName!'),
                const Text('You currently have a bike checked out.'),
                const Text('Bike Info:'),
                Text('Bike Name: $bikeName'),
                Text('Bike ID: $bikeId'),
                Text('Lock Combination: $lockCombination'),
                CheckedOutBikeRow(checkedOutBike: checkedOutBike),
                OutlinedButton(
                  onPressed: () {
                    checkInBike(bikeId);
                    Navigator.pushNamed(context, ProfileView.routeName,);
                    debugPrint('Return Bike button clicked');
                  },
                  child: const Text('Return Bike'),
                ),
              ],
            );   
          } else {
            return const CircularProgressIndicator();
          }
      }
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
  final User user;
  const ProfileViewB({ Key? key, required this.user }) 
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String currentUserGivenName = user.getGivenName();
    return Column(children: [
        Text('Welcome, $currentUserGivenName!'),
        OutlinedButton(
          onPressed: () {
            debugPrint('Find a Bike button clicked');
            Navigator.pushNamed(
              context, BikeListView.routeName,
            );    
            
          },
          child: const Text('Find a Bike'),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.pushNamed(
              context, GetPhoto.routeName,
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
// 
class CheckedOutBikeRow extends StatelessWidget {
  final Bike checkedOutBike;
  const CheckedOutBikeRow({ Key? key,
     required this.checkedOutBike}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = checkedOutBike.getImageUrl();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.network(imageUrl,
          width: 200,
          fit:BoxFit.cover  
        ),
        // TODO: calculate how much time is left.
        const Text('Due Back in 22 Minutes')
      ],      
    );
  }
}
