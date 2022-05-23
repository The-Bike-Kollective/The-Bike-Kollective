import express, { Request, Response } from "express";
import {
  findUserByAccessToekn,
  addBiketoDB,
  getAllBikes,
  findUserByIdentifier,
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
  addBikeToOwnerListDB,
  changeUserSuspensionMoodeDB,
  bikeUpdateAvergaeRatingDB

} from "../db/db";
import { IBike, IRating, INote } from "../models/bike";
import { verifyUserIdentity } from "./userHelperFunctions";
import {
  CheckoutHistory,
  ICheckoutHistory,
  ILocation,
} from "../models/checkoutHistory";

import {createhistoryObjectfromDB} from './checkoutRecordsHelpers';

const router = express.Router();

// information/instructions: for registering a bike by a valid user
// @params: Auth code
// @return: bike data on success , error message on failure
// bugs: no known bugs
router.post("/", async (req: Request, res: Response) => {
  // check if access_token is provided.
  if (!req.headers.authorization) {
    return res.status(403).send({ message: "access token is missing" });
  }

  // splits "Breaer TOKEN"
  let access_token = req.headers.authorization.split(" ")[1];
  console.log("Access Token from header is:");
  console.log(access_token);

  // retrive user information from DB to find refresh token
  // const userFromDb = await findUserByAccessToekn(access_token)
  let userFromDb = await findUserByAccessToekn(access_token);

  const verificationResult = await verifyUserIdentity(userFromDb, access_token);

  if (verificationResult == 404) {
    // because the search was done by access token , then here access token is invlid so 401 should be sent
    return res.status(404).send({ message: "User not found. non existing access token" , access_token: access_token});
  } else if (verificationResult == 500) {
    return res.status(500).send({ message: "Multiple USER ERROR" , access_token: access_token});
  } else if (verificationResult == 401) {
    return res
      .status(401)
      .send({ message: "unauthorized. invalid access_token or identifier" , access_token: access_token});
  } else if (verificationResult == 200) {
    console.log("User is verified. Countiue the process");

    // get bike infro from body

    // verify bike type
    // if (!req.body instanceof Bike);
    if (!(await verifyBikePostBody(req.body))) {
      return res.status(400).send({ message: "invalid body", access_token: access_token });
    }

    const date_added = Date.now();
    const image = req.body.image;
    const active = true;
    const condition = true;
    const owner_id = String(userFromDb[0]["identifier"]);
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
    const check_out_history = new Array<string>();
    const name = req.body.name;
    const type = req.body.type;
    const size = req.body.size;

    const newBike = createBikeObject(
      date_added,
      image,
      active,
      condition,
      owner_id,
      lock_combination,
      notes,
      rating,
      rating_history,
      location_long,
      location_lat,
      check_out_id,
      check_out_time,
      check_out_history,
      name,
      type,
      size
    );

    const bikeFromDB = await addBiketoDB(newBike);

    // get updated user info to return valid access token
    userFromDb = await findUserByIdentifier(userFromDb[0]["identifier"]);

    // add bike to user owned_bike list
    const ownedBikes = userFromDb[0]["owned_bikes"]
    await addBikeToOwnerListDB(String(userFromDb[0]["_id"]),[...ownedBikes,String(bikeFromDB["_id"])]);


    res
      .status(201)
      .send(createBikeResponse(createBikeObjectfromDB(bikeFromDB),userFromDb[0]["access_token"])
      );
  }
});


// information/instructions: returns all bikes in DB
// @params: none
// @return: array of Bike objects
// bugs: no known bugs
// TODO : add pagination
router.get("/", async (req: Request, res: Response) => {
  console.log("in get all bikes. Fetching from DB...");
  // check if access_token is provided.
  if (!req.headers.authorization) {
    return res.status(403).json({ message: "access token is missing" });
  }

  // splits "Breaer TOKEN" 
  let access_token = req.headers.authorization.split(" ")[1];
  console.log("Access Token from header is:");
  console.log(access_token);

  // retrive user information from DB to find refresh token
  let userFromDb = await findUserByAccessToekn(access_token)

  const verificationResult = await verifyUserIdentity(userFromDb,access_token)

  if (verificationResult==404){
    // because the search was done by access token , then here access token is invlid so 401 should be sent
    return res.status(404).send({ message: "User not found. non existing access token" , access_token: access_token});
  }else if (verificationResult==500){
    return res.status(500).json({ message: "Multiple USER ERROR" , access_token: access_token});
  }else if (verificationResult==401){
    return res.status(401).send({ message: "unauthorized. invalid access_token or identifier" , access_token: access_token})
  }else if (verificationResult==200){
    // get updated information from DB before sending to client
    userFromDb = await findUserByIdentifier(userFromDb[0]['identifier'])

  const bikes = await getAllBikes();
  console.log("in get all bikes. Fetched!");
  const bikesToSend: any = [];
  bikes.forEach((bike) => {
    // return only active and not damged bikes which are not checked out
    if(bike.active && bike.condition && bike.check_out_id=="-1"){
      // hide lock_combination 
      bike['lock_combination']=-99
      // hide checkout history
      bike['check_out_history']=[]
      // hide rating history 
      bike['rating_history']=[]

      bike.notes.forEach(note => {
        // hide id is notes
        note.id="hidden"
      })


      bikesToSend.push(createBikeObjectfromDB(bike));
    }
  });

  res.status(200).send({bikes:bikesToSend,access_token:userFromDb[0]['access_token']});}
});

// information/instructions: returns a single bike information.
// @params: none
// @return: array of Bike objects
// bugs: no known bugs
// TODO : add pagination
router.get("/:id", async (req: Request, res: Response) => {
  const bike_id = req.params.id;
  console.log(`bike id is :${bike_id}`);
  // check if access_token is provided.
  if (!req.headers.authorization) {
    return res.status(403).json({ message: "access token is missing" });
  }

  // splits "Breaer TOKEN" 
  let access_token = req.headers.authorization.split(" ")[1];
  console.log("Access Token from header is:");
  console.log(access_token);

  // retrive user information from DB to find refresh token
  let userFromDb = await findUserByAccessToekn(access_token)

  const verificationResult = await verifyUserIdentity(userFromDb,access_token)

  if (verificationResult==404){
    // because the search was done by access token , then here access token is invlid so 401 should be sent
    return res.status(404).send({ message: "User not found. non existing access token" , access_token: access_token});
  }else if (verificationResult==500){
    return res.status(500).json({ message: "Multiple USER ERROR" , access_token: access_token});
  }else if (verificationResult==401){
    return res.status(401).send({ message: "unauthorized. invalid access_token or identifier" , access_token: access_token})
  }else if (verificationResult==200){
    // get updated information from DB before sending to client
    userFromDb = await findUserByIdentifier(userFromDb[0]['identifier'])

  // get bike inforamtion from DB
  const bikeFromDB = await findBikeByID(bike_id);

  // get updated user info to return valid access token
  userFromDb = await findUserByIdentifier(userFromDb[0]["identifier"]);
  access_token = userFromDb[0]["access_token"];

  if (bikeFromDB.length == 0) {
    return res
      .status(404)
      .send({ message: "Bike not found", access_token: access_token });
  } else if (bikeFromDB.length == 0) {
    return res
      .status(500)
      .send({ message: "Multiple BIKE ERROR", access_token: access_token });
  }

  let bikeObject=createBikeObjectfromDB(bikeFromDB[0])

  bikeObject['lock_combination']=-99
  // hide checkout history
  bikeObject['check_out_history']=[]
  // hide rating history 
  bikeObject['rating_history']=[]
  // hiding id in notes
  bikeObject.notes.forEach(note => {
    // hide id is notes
    note.id="hidden"
  })
  // hiding check out id and timestamp
  if (bikeObject['check_out_id']!="-1"){
    bikeObject['check_out_id']="hidden"
    bikeObject['check_out_time']=-99
  }


  // there is 1 bike in returned list
  return res
    .status(200)
    .send(createBikeResponse(bikeObject, access_token));
}
});

// information/instructions: to update a bike
// @params: none
// @return: array of Bike objects
// bugs: no known bugs
// TODO : add pagination
router.put("/:id", async (req: Request, res: Response) => {
  const bike_id = req.params.id;
  console.log(`bike id is :${bike_id}`);
  // check if access_token is provided.
  if (!req.headers.authorization) {
    return res.status(403).send({ message: "access token is missing" });
  }

  // splits "Breaer TOKEN"
  let access_token = req.headers.authorization.split(" ")[1];
  console.log("Access Token from header is:");
  console.log(access_token);

  // retrive user information from DB to find refresh token
  // const userFromDb = await findUserByAccessToekn(access_token)
  let userFromDb = await findUserByAccessToekn(access_token);

  const verificationResult = await verifyUserIdentity(userFromDb, access_token);

  if (verificationResult == 404) {
    // because the search was done by access token , then here access token is invlid so 401 should be sent
    return res.status(404).send({ message: "User not found. non existing access token" , access_token: access_token});
  } else if (verificationResult == 500) {
    return res.status(500).send({ message: "Multiple USER ERROR" , access_token: access_token});
  } else if (verificationResult == 401) {
    return res
      .status(401)
      .send({ message: "unauthorized. invalid access_token or identifier" , access_token: access_token});
  } else if (verificationResult == 200) {
    console.log("User is verified. Countiue the process");
  }

  // get bike inforamtion from DB
  let bikeFromDB = await findBikeByID(bike_id);

  // get updated user info to return valid access token
  userFromDb = await findUserByIdentifier(userFromDb[0]["identifier"]);
  access_token = userFromDb[0]["access_token"];

  if (bikeFromDB.length == 0) {
    return res
      .status(404)
      .send({ message: "Bike not found", access_token: access_token });
  } else if (bikeFromDB.length == 0) {
    return res
      .status(500)
      .send({ message: "Multiple BIKE ERROR", access_token: access_token });
  }

  // check if the user is the actual bike owner.
  if (bikeFromDB[0]["owner_id"] != userFromDb[0]["identifier"]) {
    return res
      .status(403)
      .send({ message: "User is not the owner", access_token: access_token });
  }

  // check if bike is not check out and available
  if (bikeFromDB[0]["check_out_id"] != "-1") {
    return res
      .status(409)
      .send({
        message: "Bike is currently check out",
        access_token: access_token,
      });
  }

  // user can change the following properties. the other porperties will NOT be chnaged.
  // 1. name
  // 2. image
  // 3. active
  // 4. condition
  // 5. lock_combination
  // 6. notes [only add a new note]  => validate type
  // 7. size
  // 8. type
  // 9. location_long
  // 10. location_lat

  // only items that can cause 400 is notes if provided
  let notes = bikeFromDB[0]["notes"];
  if (req.body.notes) {
    if (
      validateNoteObject(req.body.notes) &&
      req.body.notes.id == userFromDb[0]["identifier"]
    ) {
      notes = [...bikeFromDB[0]["notes"], req.body.notes];
    } else {
      return res
        .status(400)
        .send({ message: "invalid note", access_token: access_token });
    }
  }

  // params that might chnage
  const image = req.body.image || bikeFromDB[0]["image"];
  const active = req.body.active || bikeFromDB[0]["active"];
  const condition = req.body.condition || bikeFromDB[0]["condition"];
  const lock_combination =
    req.body.lock_combination || bikeFromDB[0]["lock_combination"];
  const location_long =
    req.body.location_long || bikeFromDB[0]["location_long"];
  const location_lat = req.body.location_lat || bikeFromDB[0]["location_lat"];
  const name = req.body.name || bikeFromDB[0]["name"];
  const type = req.body.type || bikeFromDB[0]["type"];
  const size = req.body.size || bikeFromDB[0]["size"];

  // params that are not chaning
  const date_added = bikeFromDB[0]["date_added"];
  const owner_id = bikeFromDB[0]["owner_id"];
  const rating = bikeFromDB[0]["rating"];
  const rating_history = bikeFromDB[0]["rating_history"];
  const check_out_id = bikeFromDB[0]["check_out_id"];
  const check_out_time = bikeFromDB[0]["check_out_time"];
  const check_out_history = bikeFromDB[0]["check_out_history"];

  const newBike = createBikeObject(
    date_added,
    image,
    active,
    condition,
    owner_id,
    lock_combination,
    notes,
    rating,
    rating_history,
    location_long,
    location_lat,
    check_out_id,
    check_out_time,
    check_out_history,
    name,
    type,
    size
  );

  // update bike on DB
  updateAnExisitngBike(bikeFromDB[0]["id"], newBike);

  //get updated bike from DB
  bikeFromDB = await findBikeByID(bike_id);

  // return updated result
  return res
    .status(200)
    .send(
      createBikeResponse(createBikeObjectfromDB(bikeFromDB[0]), access_token)
    );
});

// information/instructions: for checking out a bike
// @params: Auth code, bike_id , user_identifier
// @return: check out success and time stamp if success , error message on failure
// bugs: no known bugs
// TODO : refactor into functions
router.post(
  "/:bike_id/:user_identifier",
  async (req: Request, res: Response) => {
    // steps to check out a bike:
    // 1. verify authorization header exists
    // 2. verify body
    // 3. find user using access token
    // 4. verify user and update token
    // 5. get updated user infroamtion after verification
    // 6. verify provided user identifier belongs to the same user
    // 7. get bike info from DB
    // 9. check if user is suspended
    // 9. check if bike is active or damaged
    // 10. check if user has not checked out another bike
    // 11. check if bike is not checked out by another user
    // 12. create a new checkout record and add inforamation
    // 13. check out the bike and add user identifier , time stamp and bike id to DB documents.
    // 14. return sucess and data

    const bike_id = req.params.bike_id;
    const user_identifier = req.params.user_identifier;
    const checkoutTimestamp = Date.now();

    console.log(
      `in Bike Checkout.Bike id is :${bike_id}\nuser identifier is: ${user_identifier}`
    );
    // 1. verify authorization header exists
    if (!req.headers.authorization) {
      return res.status(403).send({ message: "access token is missing" });
    }

    // splits "Breaer TOKEN"
    let access_token = req.headers.authorization.split(" ")[1];
    console.log("Access Token from header is:");
    console.log(access_token);

    // 2. verify body
    if (!(await verifyBikeCheckOutBody(req.body))) {
      return res
        .status(400)
        .send({ message: "invalid body", access_token: access_token });
    }

    // 3. find user using access token
    let userFromDb = await findUserByAccessToekn(access_token);

    // 4. verify user and update token
    const verificationResult = await verifyUserIdentity(
      userFromDb,
      access_token
    );
    if (verificationResult == 404) {
      // because the search was done by access token , then here access token is invlid so 401 should be sent
    return res.status(404).send({ message: "User not found. non existing access token" , access_token: access_token});
    } else if (verificationResult == 500) {
      return res
        .status(500)
        .send({ message: "Multiple USER ERROR", access_token: access_token });
    } else if (verificationResult == 401) {
      return res
        .status(401)
        .send({
          message: "unauthorized. invalid access_token or identifier",
          access_token: access_token,
        });
    }

    // if none of the avoe it means it was success with 200

    // 5. get updated user infroamtion after verification to be sent to the user
    userFromDb = await findUserByIdentifier(user_identifier);
    access_token = userFromDb[0]["access_token"];

    // 6. verify provided user identifier belongs to the same user
    if (userFromDb[0]["identifier"] != user_identifier) {
      return res
        .status(403)
        .send({ message: "unauthorized user", access_token: access_token });
    }

    // 7. get bike info from DB
    let bikeFromDb = await findBikeByID(bike_id);
    if (bikeFromDb.length == 0) {
      return res
        .status(404)
        .send({ message: "Bike not found", access_token: access_token });
    } else if (bikeFromDb.length > 1) {
      return res
        .status(500)
        .send({ message: "Multiple BIKE ERROR", access_token: access_token });
    }

    // 8. check if user is suspended
    if (userFromDb[0]["suspended"]) {
      return res
        .status(409)
        .send({ message: "user is suspended", access_token: access_token });
    }

    // 9. check if bike is active or damaged
    if (!bikeFromDb[0]["active"]) {
      return res
        .status(409)
        .send({ message: "Bike is not sharable", access_token: access_token });
    }
    if (!bikeFromDb[0]["condition"]) {
      return res
        .status(409)
        .send({ message: "Bike is damaged", access_token: access_token });
    }

    // 10. check if user has not checked out another bike
    if (userFromDb[0]["checked_out_bike"] != "-1") {
      return res
        .status(409)
        .send({
          message: "user has a checked out bike",
          access_token: access_token,
        });
    }

    // 11. check if bike is not checked out by another user
    if (bikeFromDb[0]["check_out_id"] != "-1") {
      return res
        .status(409)
        .send({
          message: "Bike is checked out by another user",
          access_token: access_token,
        });
    }

    // 12. create a new checkout record using infroamtion and add it to the DB
    const checkoutLocation = createNewLocation(
      req.body.location_long,
      req.body.location_lat
    );
    const checkinLocation = createNewLocation(NaN,NaN);  // dummy location
    const checkoutRecord = createNewCheckout(
      user_identifier,
      bike_id,
      checkoutLocation,
      checkoutTimestamp,
      checkinLocation
    );
    const checkoutRecordfromDB:ICheckoutHistory = await addCheckoutRecordToDB(checkoutRecord);
    console.log("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
    console.log(checkoutRecordfromDB)


    let checkoutObject= createhistoryObjectfromDB(checkoutRecordfromDB)
    // TODO: add error if empty

    // 13. check out the bike and add user identifier , time stamp and bike id to DB documents.
    userCheckoutABikeDB(
      userFromDb[0]["id"],
      bike_id,
      user_identifier,
      checkoutTimestamp,
      checkoutObject.id as string
    );

    // 14. return success
    return res
      .status(200)
      .send({
        message: "Check out complete",
        checkout_timestamp: checkoutTimestamp,
        lock_combination:bikeFromDb[0]["lock_combination"],
        checkout_details: checkoutObject,
        access_token: access_token,
      });
  }
);

// information/instructions: for checking in a bike
// @params: Auth code, bike_id , user_identifier
// @return: check out success and time stamp if success , error message on failure
// bugs: no known bugs
// TODO : refactor into functions
router.delete(
  "/:bike_id/:user_identifier",
  async (req: Request, res: Response) => {
    // steps to check_in a bike:
    // 1. verify authorization header exists
    // 2. verify body
    // 3. find user using access token
    // 4. verify user and update token
    // 4. get updated user infroamtion after verification
    // 5. verify provided user identifier belongs to the same user
    // 6. get bike info from DB
    // 7. verify if user is check out the bike
    // 8. add a new record  to note history
    // 9. add a new record  to rating history andcalculate new average
    // 10. update location
    // 11. update condition
    // 12. calculate total check out time using stored timestamp
    // 13. suspend user if passed limit
    // 14. add a new record  to check out history
    // 15. update bike and user DB with -1
    // 16. send result and include message, total_time, user_suspended, access_token

    const bike_id = req.params.bike_id;
    const user_identifier = req.params.user_identifier;
    const checkInTimestamp = Date.now();

    console.log(
      `in Bike Checkin.Bike id is :${bike_id}\nuser identifier is: ${user_identifier}`
    );
    // check if access_token is provided.
    if (!req.headers.authorization) {
      return res.status(403).send({ message: "access token is missing" });
    }

    // splits "Breaer TOKEN"
    let access_token = req.headers.authorization.split(" ")[1];
    console.log("Access Token from header is:");
    console.log(access_token);

    // 2. verify body
    if (!(await verifyBikeCheckInBody(req.body))) {
      return res
        .status(400)
        .send({ message: "invalid body", access_token: access_token });
    } else if (!req.body.condition && req.body.note.length == 0) {
      // if damaged, note should not be empty
      return res
        .status(400)
        .send({
          message: "damaged bike must have a note",
          access_token: access_token,
        });
    }

    // check access token and update it
    // retrive user information from DB to find refresh token
    let userFromDb = await findUserByAccessToekn(access_token);

    const verificationResult = await verifyUserIdentity(
      userFromDb,
      access_token
    );

    if (verificationResult == 404) {
      // because the search was done by access token , then here access token is invlid so 401 should be sent
    return res.status(404).send({ message: "User not found. non existing access token" , access_token: access_token});
    } else if (verificationResult == 500) {
      return res
        .status(500)
        .send({ message: "Multiple USER ERROR", access_token: access_token });
    } else if (verificationResult == 401) {
      return res
        .status(401)
        .send({
          message: "unauthorized. invalid access_token or identifier",
          access_token: access_token,
        });
    }

    // if none of the avoe it means it was success with 200

    // get updated information from and retrive access token to be sent to the user
    userFromDb = await findUserByIdentifier(user_identifier);
    access_token = userFromDb[0]["access_token"];

    // verify if provided id belongs to this user
    if (userFromDb[0]["identifier"] != user_identifier) {
      return res
        .status(403)
        .send({ message: "unauthorozrd user", access_token: access_token });
    }

    // get bike inforamtion from DB
    let bikeFromDb = await findBikeByID(bike_id);

    if (bikeFromDb.length == 0) {
      return res
        .status(404)
        .send({ message: "Bike not found", access_token: access_token });
    } else if (bikeFromDb.length > 1) {
      return res
        .status(500)
        .send({ message: "Multiple BIKE ERROR", access_token: access_token });
    }

    // 7. verify if user is check out the bike
    if (userFromDb[0]["checked_out_bike"] != bike_id) {
      return res
        .status(409)
        .send({
          message: "User did not check out the bike.",
          access_token: access_token,
        });
    }

    // 8. update note history
    if (req.body.note.length > 0) {
      const newNoteEntry: INote = {
        id: user_identifier,
        timestamp: checkInTimestamp,
        note_body: req.body.note,
      };
      await bikeUpdateNotesDB(bike_id,[...bikeFromDb[0]["notes"],newNoteEntry])
    }

    // 9. update rating history andcalculate new average
    const newRatingEntry: IRating = {
      id: user_identifier,
      timestamp: checkInTimestamp,
      rating_value: req.body.rating,
    };
    await bikeUpdateRatingHistoryDB(bike_id,[...bikeFromDb[0]["rating_history"],newRatingEntry])
    await bikeUpdateAvergaeRatingDB(bike_id);

    // 10. update location
    await bikeUpdateLocationDB(bike_id,req.body.location_long,req.body.location_lat)
   
    // 11. update condition
    await bikeUpdateConditionDB(bike_id,req.body.condition)

    // 12. create return location, retrive checkoutRating and updateit, calculate total time
    const checkinLocation = createNewLocation(req.body.location_long,req.body.location_lat)
    const checkoutRecord = await findCheckoutRecordByID(userFromDb[0]['checkout_record_id']) 
    console.log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ restored checkout record")
    console.log(checkoutRecord)
    let checkoutObject= createhistoryObjectfromDB(checkoutRecord[0])
    // TODO: add error if empty

    checkoutObject.checkInUpdate(checkInTimestamp,checkinLocation,req.body.note,req.body.rating,req.body.condition_on_return)
    checkoutObject.calculateMinutes()   

    // 13. suspend user if passed limit
    let userSuspended = false;
    if(checkoutObject.total_minutes>8*60){
      await changeUserSuspensionMoodeDB(userFromDb[0]['id'],true);
      userSuspended = true
    }

    // 14. add to check out history
    await updateAnExisitngCheckoutHistory(checkoutObject)


    // 15. update bike and user DB with -1
    // userCheckInABikeDB(userFromDb[0]['id'],bike_id,user_identifier)
    await userCheckInABikeDB(
      userFromDb[0]['id'],
      bike_id,
      [...bikeFromDb[0]['check_out_history'],checkoutObject.id as string],
      [...userFromDb[0]['checkout_history'],checkoutObject.id as string]
      )

    // 16. send result and include message, total_time, user_suspended, access_token
    return res
      .status(200)
      .send({
        message: "Check in complete",
        checkout_timestamp: checkInTimestamp,
        checkout_details: checkoutObject,
        user_suspended:userSuspended,
        access_token: access_token,
      });
  }
);

// information/instructions: verifies body data for Bike check in
// @params: JSON object form req body
// @return: true if valid, flase if not
// bugs: no known bugs
const verifyBikeCheckInBody = (body: object) => {
  return new Promise(async (resolve) => {
    const valid_keys = [
      "note",
      "rating",
      "location_long",
      "location_lat",
      "condition",
    ];
    const keys_in_body = Object.keys(body);

    if (valid_keys.length != keys_in_body.length) {
      return resolve(false);
    }

    keys_in_body.forEach((key) => {
      if (!valid_keys.includes(key)) {
        return resolve(false);
      }
    });

    return resolve(true);
  });
};

// information/instructions: verifies body data for Bike check out
// @params: JSON object form req body
// @return: true if valid, flase if not
// bugs: no known bugs
const verifyBikeCheckOutBody = (body: object) => {
  return new Promise(async (resolve) => {
    const valid_keys = ["location_long", "location_lat"];
    const keys_in_body = Object.keys(body);

    if (valid_keys.length != keys_in_body.length) {
      return resolve(false);
    }

    keys_in_body.forEach((key) => {
      if (!valid_keys.includes(key)) {
        return resolve(false);
      }
    });

    return resolve(true);
  });
};

// information/instructions: verifies body data for Bike object
// @params: JSON object form req body
// @return: true if valid, flase if not
// bugs: no known bugs
const verifyBikePostBody = (body: object) => {
  return new Promise(async (resolve) => {
    const valid_keys = [
      "image",
      "lock_combination",
      "location_long",
      "location_lat",
      "name",
      "size",
      "type",
    ];
    const keys_in_body = Object.keys(body);

    if (valid_keys.length != keys_in_body.length) {
      return resolve(false);
    }

    keys_in_body.forEach((key) => {
      if (!valid_keys.includes(key)) {
        return resolve(false);
      }
    });

    return resolve(true);
  });
};

// create bike object for DB processing
// @params: bike data from req
// @return: bike data for DB processes
// bugs: no known bugs
const createBikeObject = (
  date_added: number,
  image: string,
  active: boolean,
  condition: boolean,
  owner_id: string,
  lock_combination: number,
  notes: Array<INote>,
  rating: number,
  rating_history: Array<IRating>,
  location_long: number,
  location_lat: number,
  check_out_id: string,
  check_out_time: number,
  check_out_history: Array<string>,
  name: string,
  type: string,
  size: string
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
    location_lat: location_lat,
    check_out_id: check_out_id,
    check_out_time: check_out_time,
    check_out_history: check_out_history,
    name: name,
    type: type,
    size: size,
  };
  return bikeObject;
  // return Object.fromEntries(Object.entries(bikeObject).sort())
};

// create bike object for response.
// @params: Bike data from DB
// @return: Bike data for HTTP response
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
    location_lat: bikeFromDB.location_lat,
    check_out_id: bikeFromDB.check_out_id,
    check_out_time: bikeFromDB.check_out_time,
    check_out_history: bikeFromDB.check_out_history,
    id: bikeFromDB._id,
    name: bikeFromDB.name,
    type: bikeFromDB.type,
    size: bikeFromDB.size,
  };

  return bikeObject;
};

// create HTTP response body
// @params: bike data and access token
// @return: formatted body for HTTP response.
// bugs: no known bugs
const createBikeResponse = (bikeObject: any, access_token: string) => {
  return { bike: bikeObject, access_token: access_token };
};

function validateNoteObject(note: any): note is INote {
  return note.id !== undefined;
}

const createNewCheckout = (
  user_identifier: string,
  bike_id: string,
  checkout_location: ILocation,
  checkout_timestamp: number,
  checkin_location: ILocation
) => {
  let newCheckout: ICheckoutHistory = {
    user_identifier: user_identifier,
    bike_id: bike_id,
    checkout_timestamp: checkout_timestamp,
    checkin_timestamp: -1,
    total_minutes: -1,
    condition_on_return: true,
    note: " ",
    rating: -1,
    checkout_location: checkout_location,
    checkin_location: checkin_location,
  };

  console.log(`newCheckout Record created:`);
  console.log(newCheckout);

  return newCheckout;
};

const createNewLocation = (long: number, lat: number) => {
  let newLocation: ILocation = {
    lat: lat,
    long: long,
  };

  console.log(`newLocation created:`);
  console.log(newLocation);

  return newLocation;
};



module.exports = router;
