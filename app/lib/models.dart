import 'dart:convert';

// information/instructions: This is a model of the user object on
// on the database.  
// @params: no params
// @return: nothing returned
// bugs: no known bugs
// TODO: 
// 1. complete the model, making sure that it matches the back end, 
// with all the same properties and datatypes.
// 2. 
class User {
  String id;
  String familyName;
  String givenName;
  String email;
  String identifier;
  List<String> ownedBikes = [];
  String checkedOutBike;
  int checkedOutTime;
  bool suspended;
  String accessToken;
  String refreshToken;
  bool signedWaiver;
  String state;
  List<String> checkoutHistory = [];
  String checkoutRecordId;

  User({this.id = '-1', 
        this.familyName = '-1',
        this.givenName = '-1',
        this.email = '-1',
        this.identifier = '-1',
        this.checkedOutBike = '-1',
        this.checkedOutTime = -1,
        this.suspended = false,
        this.accessToken = '-1',
        this.refreshToken = '-1',
        this.signedWaiver = false,
        this.state = '-1',
        this.checkoutRecordId = '-1'
  }); 
  
  //setters
  void setAccessToken(newToken) {accessToken = newToken;}

  //getters
  String getId() => id;
  String getFamilyName() {return familyName;}
  String getGivenName() {return givenName;}
  String getEmail() {return email;}
  String getIdentifier() => identifier;
  List<String> getOwnedBikes() {return ownedBikes;}
  String getCheckedOutBike() {return checkedOutBike;}
  int getCheckedOutTime() {return checkedOutTime;}
  bool getSuspended() {return suspended;}
  String getAccessToken() { return accessToken;}
  String getRefreshToken() {return refreshToken;}
  bool getSignedWaiver() {return signedWaiver;}
  List<String> getCheckedOutString() {return checkoutHistory;}
  String getCheckedOutRecordId() {return checkoutRecordId;}
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
  num locationLat;
  num locationLong;
  int lockCombination;
  String name;
  List notes = [];
  late String ownerId;
  late num rating;
  List ratingHistory = [];
  List checkoutHistory = [];
  Bike({ this.name = "unnamed",
        this.imageUrl = "no_image",
        this.locationLat = -1.0,
        this.locationLong = -1.0,
        this.lockCombination = -1,
        this.rating = -1, 
        this.dateAdded = -1, 
        this.active = true, 
        this.condition = true, 
        this.ownerId = "-1", 
        //this.notes = L, 
        //this.ratingHistory, 
        this.checkOutTime = 1, 
        //this.checkOutHistory, 
        this.id = "-1",


  });
  
  //setters
  setOwnderId(String newId) { ownerId = newId;}
  setLockCombination(int newCombo) { lockCombination = newCombo;}
  addNote(String note) { notes.add(note); }
  setIsCheckedId(int id) { checkOutId = -1; }
  setName(String newName) { name = newName;}
  setRating(num rating) {rating = rating;}
  setImageUrl(String url) {imageUrl = imageUrl;}
  setId(String newId) {id = newId;}

  //getters
  String getName() => name;
  num getRating() => rating;
  String getImageUrl() => imageUrl;
  String getId() => id;

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
  // example of response from request post /bikes
//   {date_added: 1652064108174, 
//    image: default_image_string, 
//    active: true, 
//    condition: true, 
//    owner_id: 6276bb56da39b8d8d54b7477, 
//    lock_combination: 223344, 
//    notes: [], 
//    rating: 0, 
//    rating_history: [], 
//    location_long: 25,
//    location_lat: -25, 
//    check_out_id: -1, 
//    check_out_history: [], 
//    id: 62787f6cfdbef47fca400805}


  factory Bike.fromJson(Map<String, dynamic> json) {
    return Bike(      
      name: json['name'] as String,
      id: json['id'] as String,
      //dateAdded: json['date_added'] as int,
      imageUrl: json['image'] as String, 
      active: json['active'] as bool,
      condition: json['condition'] as bool,
      ownerId: json['owner_id'] as String,
      //lockCombination: json['lock_combination'] as int,
      //notes: json['notes'] as List<dynamic>,
      rating: json['rating'] as num,
      //ratingHistory: json['rating_history'] as List<dynamic>,
      locationLong: json['location_long'] as num,
      locationLat: json['location_lat'] as num,
      //checkOutTime: json['check_out_time'] as int,
      //checkOutHistory: json['check_out_history'] as List<dynamic>
    );
  }
    
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


  BikeListModel.fromDataString(String dataString){
  //dataString.then((asString){
    print(dataString);
    final asList = dataString.split("},");    /// split string into a list 
    int listLength = asList.length;
    asList[0] = asList[0].substring(1);     // remove opening bracket '[' from first item  
    int lastItemLength = asList[listLength-1].length;
    // remove closing bracked ']' from last item
    asList[listLength-1] = asList[listLength-1].substring(0,lastItemLength-1);  
    // add each item from the list to bikes as a bike object
    for(int i = 0; i< listLength; i+= 1) {
      if(i != listLength-1) {
        asList[i] = asList[i] + '}';
      }
      
      var itemAsJson = jsonDecode(asList[i]);
      // convert string to bike object
      Bike newBike = Bike.fromJson(itemAsJson);
      addBike(newBike);
      print(asList[i]);
    }
  }
}  


