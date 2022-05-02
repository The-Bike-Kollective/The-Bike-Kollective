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
class User {
  int userId;
  User({this.userId = -1});
  // change to integer data type (0 is false, 1 is true) 
  
  bool hasABikeCheckedOut = false; 

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
class Bike {
  int id;
  //DateTime? dataAdded;
  String imageUrl;
  String? name;
  bool active;
  bool condition;
  int ownerId;
  int lockCombination;
  List? notes;
  double rating;
  List? ratingHistory;
  double locationLong;
  double locationLat;
  int checkOutId;
  int checkOutTime;
  List? checkOutHistory;

  Bike({  
    this.name = "unnamed", // TODO: add 'name' to the backend
    // model
    this.id = -1,
    //this.dataAdded = DateTime.now();
     this.imageUrl = 'no image',
     this.active = true,
     this.condition = true, // change to rideable?
    this.ownerId = -1,
    this.lockCombination = -1,
    this.rating = -1,
    this.locationLong = -1,
    this.locationLat = -1,
    this.checkOutId = -1,
    this.checkOutTime = -1,
          
         
          });


  //setters
  setOwnderId(int newId) { ownerId = newId;}
  setLockCombination(int newCombo) { lockCombination = newCombo;}
  addNote(String note) { notes?.add(note); }
  setIsCheckedId(int id) { checkOutId = -1; }
  setName(String? newName) { name = newName;}
  setRating(double rating) {rating = rating;}
  setImageUrl(String url) {imageUrl = imageUrl;}
  setId(int newId) {id = newId;}

  //getters
  String? getName() => name;
  double getRating() => rating;
  String getImageUrl() => imageUrl;

        
  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        //'dataAddeded':
        'image': imageUrl, 
        'active': active,
        'condition': true,
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
                        checkOutId: 1, 
                        name: 'checkedOut', 
                        rating: 3,
                        imageUrl: 'assets/coolBike.jpeg'
                      );

Bike notCheckedOutBike = Bike(
                          checkOutId: -1, 
                          name: 'notCheckedOut', 
                          rating: 3,
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
                  checkOutId: 2, 
                  name: 'Big Red', 
                  rating: 3,
                  imageUrl: 'assets/coolBike.jpeg', 
                );

  david.addNote('Brakes do not work.');
  david.addNote('This bike only makes left turns.');
  david.addNote('The front tire is flat.');


  Bike ali =  Bike(
                checkOutId: 3, 
                name: 'Bob', 
                rating: 4,
                imageUrl: 'assets/coolBike.jpeg',
              );

  ali.addNote( 'The horn sounds wimpy.');
  ali.addNote( 'The bike smells like garbage.');
  ali.addNote( 'People laughed at my for riding this bike.');


  Bike esther = Bike(
                  checkOutId: 4, 
                  name: 'Thunderbolt', 
                  rating: 5,
                  imageUrl: 'assets/coolBike.jpeg',
                
                );

  esther.addNote( 'Missing seat.' );
  esther.addNote(  'Hit by a train, so it does not ride well.');
  esther.addNote( 'Lightning tends to strike this bike.' );


  // add bikes to mockList
  mockList.addBike(david);
  mockList.addBike(ali);
  mockList.addBike(esther);

}
