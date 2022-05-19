import mongoose from "mongoose";
import { IUser } from "../models/user";
import { IBike } from "../models/bike";
import { ICheckoutHistory } from "../models/checkoutHistory";
import { db_url, db_name } from "../index";

let ObjectID = require("mongodb").ObjectID;

const connectDB = async function () {
  console.log(`db_url is : ${db_url}`);
  console.log(`db_name is : ${db_name}`);

  await mongoose.connect(db_url + "/" + db_name, () => {
    console.log("DB is connected!");
  });
};

const UserSchema: mongoose.Schema = new mongoose.Schema({
  family_name: { type: String, required: true },
  given_name: { type: String, required: true },
  email: { type: String, required: true },
  identifier: { type: String, required: true },
  owned_bikes: { type: [String], required: true },
  checked_out_bike: { type: String, required: true },
  checked_out_time: { type: Number, required: true },
  suspended: { type: Boolean, required: true },
  access_token: { type: String, required: true },
  refresh_token: { type: String, required: true },
  signed_waiver: { type: Boolean, required: true },
  state: { type: String, required: true },
  checkout_history: { type: [String], required: true },
  checkout_record_id: { type: String, required: true },
});

const BikeSchema: mongoose.Schema = new mongoose.Schema({
  date_added: { type: Number, required: true },
  image: { type: String, required: true },
  active: { type: Boolean, required: true },
  condition: { type: Boolean, required: true },
  owner_id: { type: String, required: true },
  lock_combination: { type: Number, required: true },
  notes: { type: [Object], required: true },
  rating: { type: Number, required: true },
  rating_history: { type: [Object], required: true },
  location_long: { type: Number, required: true },
  location_lat: { type: Number, required: true },
  check_out_id: { type: String, required: true },
  check_out_time: { type: Number, required: true },
  check_out_history: { type: [Object], required: true },
  name: { type: String, required: true },
  type: { type: String, required: true },
  size: { type: String, required: true },
});

const CheckoutHistorySchema: mongoose.Schema = new mongoose.Schema({
  user_identifier: { type: String, required: true },
  bike_id: { type: String, required: true },
  checkout_timestamp: { type: Number, required: true },
  checkin_timestamp: { type: Number, required: true },
  total_minutes: { type: Number, required: true },
  condition_on_return: { type: String, required: true },
  note: { type: String, required: true },
  rating: { type: Number, required: true },
  checkout_location: { type: [Object], required: true },
  checkin_location: { type: [Object], required: true },
});

const User: mongoose.Model<IUser> = mongoose.model("User", UserSchema);
const Bike: mongoose.Model<IBike> = mongoose.model("Bike", BikeSchema);
const CheckoutHistory: mongoose.Model<ICheckoutHistory> = mongoose.model(
  "CheckoutHistory",
  CheckoutHistorySchema
);

// information/instructions: add a new user to database
// @params: User object
// @return: user object with _id from DB
// bugs: no known bugs
const addUsertoDB = async (newUser: IUser) => {
  console.log(`in addUsertoDB`);
  return new Promise<any>((resolve) => {
    User.create(newUser).then((user) => {
      console.log("ADED!");
      console.log(user);
      resolve(user);
    });
  });
};

// information/instructions: retrive user by identifier
// @params: identifier as string
// @return: array of user object(s) , empty means to user was found
// bugs: no known bugs
const findUserByIdentifier = async (identifier: string) => {
  return new Promise<any>((resolve, reject) => {
    User.find({ identifier: identifier }).then((user) => {
      console.log(user);
      resolve(user);
    });
  });
};

// information/instructions: retrive user by DB Id
// @params: DB id as string
// @return: array of user object(s) , empty means to user was found
// bugs: no known bugs
const findUserByID = async (id: string) => {
  const user = await User.find({ _id: new ObjectID(id) });
  console.log(user);
  return user;
};

// information/instructions: retrive user by accsess token
// @params: accsess token as string
// @return: array of user object(s) , empty means to user was found
// bugs: no known bugs
const findUserByAccessToekn = async (access_toekn: string) => {
  const user = await User.find({ access_token: access_toekn });
  console.log(user);
  return user;
};

// information/instructions: updates users access token on DB
// @params: user DB ID and new access token as string
// @return: true in success and flase in failure
// bugs: no known bugs
const updateAccessTokeninDB = async (id: string, new_access_token: string) => {
  User.updateOne(
    { _id: new ObjectID(id) },
    { access_token: new_access_token },
    function (err: any, docs: any) {
      if (err) {
        console.log(err);
        return false;
      } else {
        console.log("access token is updated on DB");
        return true;
      }
    }
  );
};

// information/instructions: updates users state on DB
// @params: user DB ID and new state as string
// @return: true in success and flase in failure
// bugs: no known bugs
const updateStateinDB = async (id: string, new_state: string) => {
  User.updateOne(
    { _id: new ObjectID(id) },
    { state: new_state },
    function (err: any, docs: any) {
      if (err) {
        console.log(err);
        return false;
      } else {
        console.log("state is updated on DB");
        return true;
      }
    }
  );
};


// information/instructions: updates users state on DB
// @params: user DB ID and new state as string
// @return: true in success and flase in failure
// bugs: no known bugs
const addBikeToOwnerListDB = async (id: string, updated_bike_list: Array<string>) => {
  User.updateOne(
    { _id: new ObjectID(id) },
    { owned_bikes: updated_bike_list },
    function (err: any, docs: any) {
      if (err) {
        console.log(err);
        return false;
      } else {
        console.log("Bike added to the owner list list");
        return true;
      }
    }
  );
};

// information/instructions: retrive user by state 
// @params: state as string
// @return: array of user object(s) , empty means to user was found
// bugs: no known bugs
const findUserByState = async (state: string) => {
  const user = await User.find({ state: state });
  console.log(user);
  return user;
};


const userSignedWaiverDB =async (id: string) => {
  const result = await User.updateOne(
    { _id: new ObjectID(id) },
    {$set:{ signed_waiver: true}}
  );
  console.log(`userSignedWaiverDB`);
  console.log(result)
  return true;
};


const changeUserSuspensionMoodeDB =async (id: string, suspension:boolean) => {
  const result = await User.updateOne(
    { _id: new ObjectID(id) },
    {$set:{ suspended: suspension}}
  );
  console.log(`changeUserSuspensionMoodeDB is changed to :${suspension}`);
  console.log(result)
  return true;
};

// information/instructions: updates users refresh token on DB
// @params: user DB ID and new refresh token as string
// @return: true in success and flase in failure
// bugs: no known bugs
const updateRefreshTokeninDB = async (
  id: string,
  new_refresh_token: string
) => {
  User.updateOne(
    { _id: new ObjectID(id) },
    { refresh_token: new_refresh_token },
    function (err: any, docs: any) {
      if (err) {
        console.log(err);
        return false;
      } else {
        console.log("access token is updated on DB");
        return true;
      }
    }
  );
};

// information/instructions: add a bike to db
// @params: bike object
// @return: bike object with _id
// bugs: no known bugs
const addBiketoDB = async (newBike: IBike) => {
  const result = await Bike.create(newBike);
  console.log("ADED!");
  console.log(result);
  return result;
};

// information/instructions: get all bikes in DB
// @params: none
// @return: array of bikes
// bugs: no known bugs
const getAllBikes = async () => {
  const result = await Bike.find();
  console.log("All Bikes");
  console.log(result);
  return result;
};

// information/instructions: retrive bike by DB Id
// @params: DB id as string
// @return: array of user object(s) , empty means to user was found
// bugs: no known bugs
const findBikeByID = async (id: string) => {
  const bike = await Bike.find({ _id: new ObjectID(id) });
  console.log(bike);
  return bike;
};

// information/instructions: custom update function. update value of a key in DB for bike
// @params: bike id, key and new value
// @return: noen
// bugs: no known bugs
const bikeUpdateLocationDB = async (bike_id: string,new_location_long:number,new_location_lat:number) => {
  const result = await Bike.updateOne(
    { _id: new ObjectID(bike_id) },
    {$set:{ location_long: new_location_long,
            location_lat: new_location_lat}}
  );
  console.log(`bikeUpdateLocationDB updated`);
  console.log(result)
  return true;
};


const bikeUpdateRatingHistoryDB = async (bike_id: string,new_value:any) => {
  const result = await Bike.updateOne(
    { _id: new ObjectID(bike_id) },
    {$set:{ rating_history: new_value}}
  );
  console.log(`bikeUpdateRatingHistoryDB updated`);
  console.log(result)
  return true;
};

const bikeUpdateConditionDB = async (bike_id: string,new_value:boolean) => {
  const result = await Bike.updateOne(
    { _id: new ObjectID(bike_id) },
    {$set:{ condition: new_value}}
  );
  console.log(`bikeUpdateConditionDB updated`);
  console.log(result)
  return true;
};

const bikeUpdateNotesDB = async (bike_id: string,new_value:any) => {
  const result = await Bike.updateOne(
    { _id: new ObjectID(bike_id) },
    {$set:{ notes: new_value}}
  );
  console.log(`bikeUpdateNotesDB updated`);
  console.log(result)
  return true;
};


const bikeUpdateAvergaeRatingDB = async (bike_id: string) => {

  // get bike information
  const bike = await Bike.find({ _id: new ObjectID(bike_id) });
  let totalRating=0
  const ratings = bike[0].rating_history
  ratings.forEach((rating)=>{
    totalRating+=rating.rating_value
  })

  const averageRating= totalRating/ratings.length

  const result = await Bike.updateOne(
    { _id: new ObjectID(bike_id) },
    {$set:{ rating: averageRating.toFixed(1)}}
  );
  console.log(`bikeUpdateAvergaeRatingDB updated. new rating is: ${averageRating.toFixed(1)}`);
  console.log(result)
  return true;
};







// information/instructions: updates and exisitng bike with a new bike object.
// @params: bike object
// @return: none
// bugs: no known bugs
const updateAnExisitngBike = async (id: string, newBike: IBike) => {
  const result = await Bike.replaceOne({ _id: new ObjectID(id) }, newBike);
  console.log("updated!");
};

// information/instructions: check out a bike for a user and update models
// @params: user id, bike id and timestamp
// @return: none
// bugs: no known bugs
const userCheckoutABikeDB = async (
  user_id: string,
  bike_id: string,
  user_identifier: string,
  timestamp: number,
  checkoutRecordId: string
) => {
  await User.updateOne(
    { _id: new ObjectID(user_id) },
    {
      $set: {
        checked_out_bike: bike_id,
        checked_out_time: timestamp,
        checkout_record_id: checkoutRecordId,
      },
    }
  );
  await Bike.updateOne(
    { _id: new ObjectID(bike_id) },
    { $set: { check_out_id: user_identifier, check_out_time: timestamp } }
  );
  console.log("Bike checked out in DB!");
  return true;
};


// information/instructions: check in a bike for a user and update models
// @params: user id, bike id and timestamp
// @return: none
// bugs: no known bugs
const userCheckInABikeDB = async (
  user_id: string,
  bike_id: string,
  bike_check_out_history:Array<string>,
  user_checkout_history:Array<string>,
) => {
  await User.updateOne(
    { _id: new ObjectID(user_id) },
    {
      $set: {
        checked_out_bike: "-1",
        checked_out_time: -1,
        checkout_record_id: "-1",
        checkout_history:user_checkout_history
      },
    }
  );
  await Bike.updateOne(
    { _id: new ObjectID(bike_id) },
    { $set: { check_out_id: "-1", check_out_time: -1, check_out_history:bike_check_out_history } }
  );
  console.log("Bike checked in back in DB!");
  return true;
};

// information/instructions: add a a checkoutRecord to DB
// @params: checkout object
// @return: checkout object with _id
// bugs: no known bugs
const addCheckoutRecordToDB = async (newCheckoutRecord: ICheckoutHistory) => {
  const result = await CheckoutHistory.create(newCheckoutRecord);
  console.log(`Check out record ADED to DB. _id=${result._id}`);
  console.log(result);
  return result;
};


// information/instructions: retrive check out record by DB Id
// @params: DB id as string
// @return: array of checkout record object(s) , empty means no record with that id was found
// bugs: no known bugs
const findCheckoutRecordByID = async (id: string) => {
  const record = await CheckoutHistory.find({ _id: new ObjectID(id) });
  console.log(record);
  return record;
};


// information/instructions: updates an exisitng checkout History with a new checkout object.
// @params: checkout object
// @return: none
// bugs: no known bugs
const updateAnExisitngCheckoutHistory = async (newCheckoutObject: ICheckoutHistory) => {
  const result = await CheckoutHistory.replaceOne({ _id: new ObjectID(newCheckoutObject.id) }, newCheckoutObject);
  console.log(`cehckoutHistory with id =${newCheckoutObject.id} updated!`);
};


export {
  connectDB,
  addUsertoDB,
  findUserByIdentifier,
  findUserByID,
  findUserByAccessToekn,
  updateAccessTokeninDB,
  updateRefreshTokeninDB,
  findUserByState,
  updateStateinDB,
  addBiketoDB,
  getAllBikes,
  findBikeByID,
  updateAnExisitngBike,
  userCheckoutABikeDB,
  addCheckoutRecordToDB,
  findCheckoutRecordByID,
  updateAnExisitngCheckoutHistory,
  userCheckInABikeDB,
  bikeUpdateLocationDB,
  bikeUpdateRatingHistoryDB,
  bikeUpdateConditionDB,
  bikeUpdateNotesDB,
  userSignedWaiverDB,
  addBikeToOwnerListDB,
  changeUserSuspensionMoodeDB,
  bikeUpdateAvergaeRatingDB
};
