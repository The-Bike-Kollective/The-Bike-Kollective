import mongoose from 'mongoose';
import {IUser} from '../models/user';
import {IBike} from '../models/bike';

let ObjectID = require('mongodb').ObjectID;

const connectDB = async function () {
  await mongoose.connect(
    "mongodb://localhost:27017/test",
    () => {
      console.log("DB is connected!");
    }
  );
};


const UserSchema: mongoose.Schema = new mongoose.Schema({
  family_name: { type: String, required: true },
  given_name: { type: String, required: true },
  email: { type: String, required: true },
  identifier: { type: String, required: true },
  owned_biks: { type: [Number], required: true },
  check_out_bike: { type: Number, required: true },
  checked_out_time: { type: Number, required: true },
  suspended: { type: Boolean, required: true },
  access_token: { type: String, required: true },
  refresh_token: { type: String, required: true }

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
  check_out_history: { type: [Object], required: true }
});

const User: mongoose.Model<IUser> = mongoose.model('User', UserSchema);
const Bike: mongoose.Model<IBike> = mongoose.model('Bike', BikeSchema);


const addUsertoDB = async(newUser:IUser)=>{
  const result = await User.create(newUser);
  console.log('ADED!');
  console.log(result);
  return result;
}

const findUserByIdentifier = async(identifier:string)=>{
  const user = await User.find({'identifier':identifier})
  console.log(user);
  return user
}

const findUserByID = async(id:string)=>{
  const user = await User.find({_id: new ObjectID(id)})
  console.log(user);
  return user
}

const findUserByAccessToekn = async(access_toekn:string)=>{
  const user = await User.find({'access_token':access_toekn})
  console.log(user);
  return user
}


const updateAccessTokeninDB = async ( id:string , new_access_token:string )=>{
  User.updateOne({_id: new ObjectID(id)}, 
    {access_token:new_access_token}, function (err:any, docs:any) {
    if (err){
        console.log(err)
        return false
    }
    else{
        console.log("access token is updated on DB");
        return true
    }
});
}


const addBiketoDB = async(newBike:IBike)=>{
  const result = await Bike.create(newBike);
  console.log('ADED!');
  console.log(result);
  return result;
}



export {connectDB,addUsertoDB, findUserByIdentifier, findUserByID ,findUserByAccessToekn,updateAccessTokeninDB};