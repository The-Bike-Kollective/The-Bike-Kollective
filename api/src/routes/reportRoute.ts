import express, { Request, Response } from "express";
import {
  findUserByAccessToekn,
  findUserByIdentifier,
  findBikeByID,
  bikeUpdateNotesDB,
  bikeUpdateActivenessDB
} from "../db/db";
import { INote } from "../models/bike";
import { verifyUserIdentity } from "./userHelperFunctions";
import {createhistoryObjectfromDB} from './checkoutRecordsHelpers';
import  {createBikeResponse,
    createBikeObjectfromDB
  } from './bikeHelperfunctions';

const router = express.Router();


// information/instructions: to report missing or stolen bike, makes a bike not available 
// @params: none
// @return: array of Bike objects
// bugs: no known bugs
router.post("/:id", async (req: Request, res: Response) => {
    const bike_id = req.params.id;
    console.log(`reporting a stolen/missing bike`);
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
  
    // add note  
    const newNoteEntry: INote = {
      id: userFromDb[0]['identifier'],
      timestamp: Date.now(),
      note_body: "Missing/Stolen Report. Bike is not at the location.",
    }
    await bikeUpdateNotesDB(bike_id,[...bikeFromDB[0]["notes"],newNoteEntry]) 
  
    // make it inactive
    await bikeUpdateActivenessDB(bike_id,false)
  
    // get bike data after updates
    bikeFromDB = await findBikeByID(bike_id);  
  
    let bikeObject=createBikeObjectfromDB(bikeFromDB[0])
  
    //hide lock combination if requestor has not check out the bike
    if(bikeObject['check_out_id']!=userFromDb[0]['identifier']){
      bikeObject['lock_combination']=-99
    }
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

module.exports = router;

  
  