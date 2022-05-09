import express, { Request, Response } from "express";
import { findUserByAccessToekn, addBiketoDB, getAllBikes , findUserByIdentifier } from "../db/db";
import { IBike, IRating, ICheckOut, INote } from "../models/bike";
import { verifyUserIdentity } from "./userHelperFunctions";

const router = express.Router();

// information/instructions: for registering a bike by a valid user
// @params: Auth code
// @return: bike data on success , error message on failure
// bugs: no known bugs
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
  let userFromDb = await findUserByAccessToekn(access_token);

  const verificationResult = await verifyUserIdentity(userFromDb, access_token);

  if (verificationResult == 404) {
    return res.status(404).json({ message: "User not found" });
  } else if (verificationResult == 500) {
    return res.status(500).json({ message: "Multiple USER ERROR" });
  } else if (verificationResult == 401) {
    return res
      .status(401)
      .send({ message: "unauthorized. invalid access_token or identifier" });
  } else if (verificationResult == 200) {
    console.log("User is verified. Countiue the process");

    // get bike infro from body

    // verify bike type
    // if (!req.body instanceof Bike);
    if (!(await verifyBikePostBody(req.body))) {
      return res.status(400).json({ message: "invalid body" });
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
    const check_out_history = new Array<ICheckOut>();
    const name = req.body.name;
    const type = req.body.type;
    const size = req.body.size

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
    res.status(201).send(createBikeResponse(createBikeObjectfromDB(bikeFromDB),userFromDb[0]['access_token']));
  }
});

// information/instructions: returns all bikes in DB
// @params: none
// @return: array of Bike objects
// bugs: no known bugs
// TODO : add pagination
router.get("/", async (req: Request, res: Response) => {
  console.log("in get all bikes. Fetching from DB...")
  const bikes = await getAllBikes();
  console.log("in get all bikes. Fetched!")
  const bikesToSend: any = [];
  bikes.forEach((bike) => {
    bikesToSend.push(createBikeObjectfromDB(bike));
  });

  res.status(200).send(bikesToSend);
});

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
      "type"
    ];
    const keys_in_body = Object.keys(body);

    if (valid_keys.length != keys_in_body.length) {
      resolve(false);
    }

    keys_in_body.forEach((key) => {
      if (!valid_keys.includes(key)) {
        resolve(false);
      }
    });

    resolve(true);
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
  check_out_history: Array<ICheckOut>,
  name : string,
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
    size: bikeFromDB.size
  };

  return bikeObject;
};

const createBikeResponse=(bikeObject:any, access_token:string) => {

  return { bike:bikeObject, access_token: access_token };

}

module.exports = router;
