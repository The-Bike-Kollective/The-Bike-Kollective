import mongoose from 'mongoose';
import {IUser} from '../models/user';

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

const User: mongoose.Model<IUser> = mongoose.model('User', UserSchema);

const addUsertoDB = async(newUser:IUser)=>{
  const result = await User.create(newUser);
  console.log('ADED!');
  console.log(result);
  return result;
}

export {connectDB,addUsertoDB , IUser};