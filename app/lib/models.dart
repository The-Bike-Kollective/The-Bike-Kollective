// information/instructions:This is just a stub for the model. There is only one property
// so that the profile page can be rendered conditionally, depending
// on whether or not the user has a bike checked out. Change the 
// hasABikeCheckedOut property to see a different profile view. 
// @params: no params
// @return: nothing returned
// bugs: no known bugs
// TODO: 
// 1. complete the model, making sure that it matches the back end, 
// with all the same properties and datatypes.
import 'package:the_bike_kollective/profile_view.dart';

class User {
  int userId;
  String userName;
  User({this.userId = -1, this.userName = 'no name'});
  // change to integer data type (0 is false, 1 is true) 
  
  bool hasABikeCheckedOut = false; 

  final String authorization = "ya29.A0ARrdaM-uhrlMa0YBPWe6RstI68OYRZE9tDpSFLDAW1j8dZ0mLW38qgARLkvWVK6u0iqGStSaMHF18dvek_Gw_vwSpawSvxGm68VEEP27m3VpPgVLVkQz4FDr5FNQwT-JPiDybIDavW7Fn3MUyO89JU5m0SGq";

  //getters
  String getAuthorization() { return authorization;}

}


// information/instructions:This is just a stub for the model. It is here
// so the bike views can be rendered conditionally, depending
// whether the property checkOut is true or false.  
// @params: no params
// @return: nothing returned
// bugs: no known bugs
// TODO: 
// 1. complete the model, making sure that it matches the back end, 
// with all the same properties and datatypes.
// 2. number 1 is mostly complete, but need to check on some of the 
// attributes, like arrays and dateTime, to make sure they will correspond.


class Bike {
  late bool active;
  List checkOutHistory = [];
  late int checkOutId;
  late int checkOutTime;
  late bool condition;
  late int dateAdded;
  late String id;
  String imageUrl;
  double locationLat;
  double locationLong;
  int lockCombination;
  String name;
  List notes = [];
  late String ownerId;
  late double rating;
  List ratingHistory = [];
  Bike({ this.name = "unnamed",
        this.imageUrl = "no_image",
        this.locationLat = -1.0,
        this.locationLong = -1.0,
        this.lockCombination = -1,
        this.rating = -1
  });
  
  //setters
  setOwnderId(String newId) { ownerId = newId;}
  setLockCombination(int newCombo) { lockCombination = newCombo;}
  addNote(String note) { notes.add(note); }
  setIsCheckedId(int id) { checkOutId = -1; }
  setName(String newName) { name = newName;}
  setRating(double rating) {rating = rating;}
  setImageUrl(String url) {imageUrl = imageUrl;}
  setId(String newId) {id = newId;}

  //getters
  String getName() => name;
  double getRating() => rating;
  String getImageUrl() => imageUrl;

  //methods
  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'dateAdded': dateAdded,
        'image': imageUrl, 
        'active': active,
        'condition': condition,
        'owner_id': ownerId,
        'lock_combination': lockCombination,
        'notes': notes,
        'rating': rating,
        'rating_history': ratingHistory,
        'location_long': locationLong,
        'location_lat' : locationLat,
        'check_out_time': checkOutTime,
        'check_out_history': checkOutHistory,
  };    
  Bike.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        dateAdded = json['dateAdded'],
        imageUrl = json['imageUrl'], 
        active = json['active'],
        condition = json['condition'],
        ownerId = json['owner_id'],
        lockCombination = json['lock_combination'],
        notes = json['notes'],
        rating = json['rating'],
        ratingHistory = json['rating_history'],
        locationLong = json['location_long'],
        locationLat = json['location_lat'],
        checkOutTime = json['check_out_time'],
        checkOutHistory = json['check_out_history'];
    
}

// information/instructions: The BikeListView() widget takes 
// a BikeListModel as a parameter and uses the data to render 
// the bike list.
// @params: none
// @return: none
// bugs: no known bugs
// TODO: 
// 1. Expand as needed to contain a more complete model of the 
// data. Right now it just contains what is needed to render
// what is currently being rendered.
// 2. 
// 3. 
class BikeListModel {
  BikeListModel();
  List<Bike> bikes = [];
   
  addBike(Bike newBike) {
    bikes.add(newBike);
  }
  //getters
  int getLength() => bikes.length;
}


// bikes for mock data
Bike checkedOutBike = Bike(
                        name: 'checkedOut', 
                        imageUrl: 'assets/coolBike.jpeg'
                      );

//checkedOutBike

Bike notCheckedOutBike = Bike(
                          //checkOutId: -1, 
                          name: 'notCheckedOut', 
                          imageUrl: 'assets/coolBike.jpeg',
                        );

User testUser = User(userId: 99);
BikeListModel mockList = BikeListModel();


// information/instructions: This function fulls the mockList with
// fake data. 
// @params: none
// @return: none
// bugs: no known bugs
// TODO: 
// 1. Add more bikes for testing, as needed. 
// 2. 
// 3. 
void fillMockList() {
  //Instantiate Bikes for mocklist
  Bike david =  Bike(
                  //checkOutId: 2, 
                  name: 'Big Red', 
                  imageUrl: 'assets/coolBike.jpeg', 
                );

  david.setRating(5);

  david.addNote('Brakes do not work.');
  david.addNote('This bike only makes left turns.');
  david.addNote('The front tire is flat.');


  Bike ali =  Bike(
                //checkOutId: 3, 
                name: 'Bob', 
                imageUrl: 'assets/coolBike.jpeg',
              );
  ali.setRating(4);

  ali.addNote( 'The horn sounds wimpy.');
  ali.addNote( 'The bike smells like garbage.');
  ali.addNote( 'People laughed at my for riding this bike.');


  Bike esther = Bike(
                  //checkOutId: 4, 
                  name: 'Thunderbolt', 
                  imageUrl: 'assets/coolBike.jpeg',
                
                );

  esther.setRating(5);

  esther.addNote( 'Missing seat.' );
  esther.addNote(  'Hit by a train, so it does not ride well.');
  esther.addNote( 'Lightning tends to strike this bike.' );


  // add bikes to mockList
  mockList.addBike(david);
  mockList.addBike(ali);
  mockList.addBike(esther);
}

