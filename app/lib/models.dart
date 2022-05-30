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
  String getFamilyName() => familyName;
  String getGivenName() => givenName;
  String getEmail() => email;
  String getIdentifier() => identifier;
  List<String> getOwnedBikes() => ownedBikes;
  String getCheckedOutBike() => checkedOutBike;
  int getCheckedOutTime() => checkedOutTime;
  bool getSuspended() => suspended;
  String getAccessToken() => accessToken;
  String getRefreshToken() => refreshToken;
  bool getSignedWaiver() => signedWaiver;
  List<String> getCheckedOutString() => checkoutHistory;
  String getCheckedOutRecordId() => checkoutRecordId;


  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      id: parsedJson['user']['id'],
      familyName: parsedJson['user']["family_name"],
      givenName: parsedJson['user']["given_name"],
      email: parsedJson['user']["email"],
      identifier: parsedJson['user']["identifier"],
      //ownedBikes: List<dynamic>.from(parsedJson["owned_bikes"].map((x) => x)),
      checkedOutBike: parsedJson['user']["checked_out_bike"],
      checkedOutTime: parsedJson['user']["checked_out_time"],
      suspended: parsedJson['user']["suspended"],
      accessToken: parsedJson['user']["access_token"],
      refreshToken: parsedJson['user']["refresh_token"],
      signedWaiver: parsedJson['user']["signed_waiver"],
      state: parsedJson['user']["state"],
      //checkoutHistory:
      //    List<dynamic>.from(parsedJson["checkout_history"].map((x) => x)),
      checkoutRecordId: parsedJson['user']["checkout_record_id"],
    );
  }

}


// information/instructions: Bike model 
// @params: no params
// @return: nothing returned
// bugs: no known bugs
// TODO: 
// 1. Figure out what to do with date/time.
class Bike {
  late bool active;
  List checkOutHistory = [];
  String checkOutId;
  late int checkOutTime;
  late bool condition;
  late int dateAdded;
  late String id;
  String imageUrl;
  num locationLat;
  num locationLong;
  int lockCombination;
  String name;
  List<dynamic> notes = [];
  late String ownerId;
  num rating;
  List ratingHistory = [];
  List checkoutHistory = [];
  String accessToken;
  Bike({ this.name = "unnamed",
        this.imageUrl = "no_image",
        this.locationLat = -1.0,
        this.locationLong = -1.0,
        this.lockCombination = -1,
        this.rating = -1.0, 
        this.dateAdded = -1, 
        this.active = true, 
        this.condition = true, 
        this.ownerId = "-1", 
        required this.notes , 
        //this.ratingHistory, 
        this.checkOutTime = 1, 
        //this.checkOutHistory,
        this.checkOutId = '-1', 
        this.id = "-1",
        this.accessToken = "-1", 


  });
  
  //setters
  setOwnderId(String newId) { ownerId = newId;}
  setLockCombination(int newCombo) { lockCombination = newCombo;}
  addNote(String note) { notes.add(note); }
  setCheckOutId(String id) { checkOutId = '-1'; }
  setName(String newName) { name = newName;}
  setRating(double rating) {rating = rating;}
  setImageUrl(String url) {imageUrl = imageUrl;}
  setId(String newId) {id = newId;}

  //getters
  String getName() => name;
  String getImageUrl() => imageUrl;
  String getId() => id;
  String getCheckOutId() => checkOutId;
  String getAccessToken() => accessToken;
  int getLockCombination() => lockCombination;
  num getAverageRating() => rating;
  List getNotes() => notes;
  

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
    'check_out_id' : checkOutId
  };

  factory Bike.fromBikeList(Map<String, dynamic> json) {
    return Bike(      
      name: json['name'] as String,
      id: json['id'] as String,
      dateAdded: json['date_added'] as int,
      imageUrl: json['image'] as String, 
      active: json['active'] as bool,
      condition: json['condition'] as bool,
      ownerId: json['owner_id'] as String,
      lockCombination: json['lock_combination'] as int,
      notes: (json['notes'] != null) ? json['notes'] : [],
      rating: double.parse(json['rating'].toString()),// as double,
      //ratingHistory: json['rating_history'] as List<dynamic>,
      locationLong: json['location_long'] as num,
      locationLat: json['location_lat'] as num,
      checkOutId: json['check_out_id'] as String,
      checkOutTime: json['check_out_time'] as int,
      //accessToken: json['access_token'] as String
      //checkOutHistory: json['check_out_history'] as List<dynamic>
    );

  }

  factory Bike.fromJson(Map<String, dynamic> json) {
    return Bike(      
      name: json['bike']['name'] as String,
      id: json['bike']['id'] as String,
      dateAdded: json['bike']['date_added'] as int,
      imageUrl: json['bike']['image'] as String, 
      active: json['bike']['active'] as bool,
      condition: json['bike']['condition'] as bool,
      ownerId: json['bike']['owner_id'] as String,
      lockCombination: json['bike']['lock_combination'] as int,
      // problem with next line
      notes: (json['notes'] != null) ? json['notes'] : [],
      rating: json['bike']['rating'],// as double,
      //ratingHistory: json['rating_history'] as List<dynamic>,
      locationLong: json['bike']['location_long'] as num,
      locationLat: json['bike']['location_lat'] as num,
      checkOutId: json['bike']['check_out_id'] as String,
      checkOutTime: json['bike']['check_out_time'] as int,
      accessToken: json['access_token'] as String
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
  BikeListModel({bikes}); 
  List<Bike> bikes = [];
  
  // methods
  void addBike(Bike newBike) {
    bikes.add(newBike);
  }
  //getters
  int getLength() => bikes.length;
  List<Bike> getBikes() => bikes;

  factory BikeListModel.fromJson(Map<String, dynamic> json){
    return BikeListModel(
      bikes: json['bikes'] as List,
    );
  } 
}