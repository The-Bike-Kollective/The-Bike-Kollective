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
  bool hasABikeCheckedOut = true;  
}
User testUser = User();