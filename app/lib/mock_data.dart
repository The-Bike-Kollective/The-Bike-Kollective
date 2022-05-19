import 'package:the_bike_kollective/global_values.dart';

import 'models.dart';




//User testUser = User(userId: 99);


User currentUser = User(
  givenName: 'CurrentUser',
  accessToken: authCode,
  
);

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

