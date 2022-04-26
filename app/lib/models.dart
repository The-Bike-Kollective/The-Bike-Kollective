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
  bool isCheckedOut;
  String name;
  double rating;
  String imageUrl;
  List notes;
  Bike({  required this.isCheckedOut, 
          required this.name,
          required this.rating,
          required this.imageUrl,
          required this.notes});

  //getters
  String getName() => name;
  double getRating() => rating;
  String getImageUrl() => imageUrl;
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
                        isCheckedOut: true, 
                        name: 'checkedOut', 
                        rating: 3,
                        imageUrl: 'assets/coolBike.jpeg',
                        notes: []
                      );

Bike notCheckedOutBike = Bike(
                          isCheckedOut: false, 
                          name: 'notCheckedOut', 
                          rating: 3,
                          imageUrl: 'assets/coolBike.jpeg',
                          notes: []);

User testUser = User();
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
                  isCheckedOut: true, 
                  name: 'Big Red', 
                  rating: 3,
                  imageUrl: 'assets/coolBike.jpeg',
                  notes: ['Brakes do not work.',
                          'This bike only makes left turns.',
                          'The front tire is flat.'
                  ]
                );

  Bike ali =  Bike(
                isCheckedOut: true, 
                name: 'Bob', 
                rating: 4,
                imageUrl: 'assets/coolBike.jpeg',
                notes:  [ 'The horn sounds wimpy.',
                          'The bike smells like garbage.',
                          'People laughed at my for riding this bike.'
                ]
              );

  Bike esther = Bike(
                  isCheckedOut: true, 
                  name: 'Thunderbolt', 
                  rating: 5,
                  imageUrl: 'assets/coolBike.jpeg',
                  notes: ['Missing seat.',
                          'Hit by a train, so it does not ride well.',
                          'Lightning tends to strike this bike.'
                  ]
                );

  // add bikes to mockList
  mockList.addBike(david);
  mockList.addBike(ali);
  mockList.addBike(esther);

}
