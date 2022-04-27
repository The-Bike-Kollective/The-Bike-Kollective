import express, { Request, Response } from "express";
import {
  getAuthURL,
  get_tokens,
  getProfileInfo,
  printKeys,
  verifyAccessToken,
  get_renewed_access_token,
} from "../services/google_auth";
import {
  connectDB,
  addUsertoDB,
  findUserByIdentifier,
  findUserByID,
  findUserByAccessToekn,
  updateAccessTokeninDB,
  updateRefreshTokeninDB,
  addBiketoDB,
  getAllBikes
} from "../db/db";
import { Bike, IBike, IRating, ICheckOut,INote } from "../models/bike";
import {verifyUserIdentity} from './userHelperFunctions';

const router = express.Router();


// information/instructions: for registering a bike by a valid user
// @params: Auth code
// @return: user data or
// bugs: no known bugs
// TODO: decide on state and login design , might be changed based on frond end team design
// TODO : refactor into correct file
router.post("/", async (req: Request, res: Response) => {

  
  // check if access_token is provided.
  if (!req.headers.authorization) {
    return res.status(403).json({ message: "access token is missing" });
  }

  // splits "Breaer TOKEN" 
  let access_token = req.headers.authorization.split(" ")[1];
  console.log("Access Token from header is:");
  console.log(access_token);

  // retrive user information from DB to find refresh token
  // const userFromDb = await findUserByAccessToekn(access_token)
  let userFromDb = await findUserByAccessToekn(access_token)

  const verificationResult = await verifyUserIdentity(userFromDb,access_token)

  if (verificationResult==404){
    return res.status(404).json({ message: "User not found" });
  }else if (verificationResult==500){
    return res.status(500).json({ message: "Multiple USER ERROR" });
  }else if (verificationResult==401){
    return res.status(401).send({ message: "unauthorized. invalid access_token or identifier" })
  }else if (verificationResult==200){

    console.log("User is verified. Countiue the process");

    
    
    
    
    // get bike infro from body

    // verify bike type
    // if (!req.body instanceof Bike);
    if(!await verifyBikePostBody(req.body)){
        return res.status(400).json({ message: "invalid body" });
    }

    const date_added = Date.now();
    const image = req.body.image;
    const active = true;
    const condition = true;
    const owner_id = String(userFromDb[0]['_id']);
    const lock_combination = req.body.lock_combination;
    // add a function to set notes with user id as an object
    const notes = new Array<INote>();
    // add tags
    const rating = 0;
    const rating_history = new Array<IRating>();
    const location_long = req.body.location_long;
    const location_lat = req.body.location_lat;
    const check_out_id = "-1";
    const check_out_time = -1;
    const check_out_history = new Array<ICheckOut>();

    const newBike = createBikeObject(date_added,image,active,condition,owner_id,lock_combination,notes,
        rating,rating_history,location_long,location_lat,check_out_id,check_out_time,check_out_history)

    const bikeFromDB=await addBiketoDB(newBike)

    res.status(200).send(createBikeObjectfromDB(bikeFromDB));
  }   
});



// information/instructions: for registering a bike by a valid user
// @params: Auth code
// @return: user data or
// bugs: no known bugs
// TODO: decide on state and login design , might be changed based on frond end team design
// TODO : refactor into correct file
router.get("/", async (req: Request, res: Response) => {
    const bikes= await getAllBikes();
    const bikesToSend:any=[];
    bikes.forEach(bike=>{
        bikesToSend.push(createBikeObjectfromDB(bike))
    })
    
    res.status(200).send(bikesToSend)
}
)


const verifyBikePostBody = (body:object)=>{

    return new Promise(async (resolve) => {
        const valid_keys=["image","lock_combination","location_long","location_lat"]
    const keys_in_body= Object.keys(body)

    if (valid_keys.length!=keys_in_body.length){
        resolve(false)
    }

    keys_in_body.forEach(key=>{
        if(! valid_keys.includes(key)){
            resolve(false)
        }
    })

    resolve(true)

    })

    


}


// create user object for response. replace refresh token with an empty string for security purposes.
// @params: user data from DB
// @return: user data for HTTP response
// bugs: no known bugs
const createBikeObject = (
    date_added : number,
    image : string,
    active : boolean,
    condition : boolean,
    owner_id : string,
    lock_combination : number,
    notes : Array<INote>,
    rating : number,
    rating_history : Array<IRating>,
    location_long : number,
    location_lat : number,
    check_out_id : string,
    check_out_time : number,
    check_out_history : Array<ICheckOut>

) => {
    let bikeObject: IBike = {
        date_added: date_added,
        image: image,
        active: active,
        condition: condition,
        owner_id: owner_id,
        lock_combination: lock_combination,
        notes: notes,
        rating: rating,
        rating_history: rating_history,
        location_long: location_long,
        location_lat:location_lat,
        check_out_id:check_out_id,
        check_out_time:check_out_time,
        check_out_history:check_out_history,
    };
  
    return bikeObject;
};


// create user object for response. replace refresh token with an empty string for security purposes.
// @params: user data from DB
// @return: user data for HTTP response
// bugs: no known bugs
const createBikeObjectfromDB = (bikeFromDB: any) => {
    let bikeObject: IBike = {
        date_added: bikeFromDB.date_added,
        image: bikeFromDB.image,
        active: bikeFromDB.active,
        condition: bikeFromDB.condition,
        owner_id: bikeFromDB.owner_id,
        lock_combination: bikeFromDB.lock_combination,
        notes: bikeFromDB.notes,
        rating: bikeFromDB.rating,
        rating_history: bikeFromDB.rating_history,
        location_long: bikeFromDB.location_long,
        location_lat:bikeFromDB.location_lat,
        check_out_id:bikeFromDB.check_out_id,
        check_out_time:bikeFromDB.check_out_time,
        check_out_history:bikeFromDB.check_out_history,
        id: bikeFromDB._id,
    };
  
    return bikeObject;
};




module.exports = router;