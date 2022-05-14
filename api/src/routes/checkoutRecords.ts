import express, { Request, Response } from "express";
import {
    findUserByAccessToekn,
    findUserByIdentifier,
  findCheckoutRecordByID
} from "../db/db";
import {verifyUserIdentity} from './userHelperFunctions'
import {createhistoryObjectfromDB} from './checkoutRecordsHelpers';


const router = express.Router();

// information/instructions: returns checkout record details
// @params: checkout id
// @return: checkout details
// bugs: no known bugs
// TODO : clean console logs
router.get("/:id", async (req, res) => {
  const recordID = req.params.id;
  console.log(`recordID is: ${recordID}`);
  
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
    return res.status(404).json({ message: "User not found" , access_token: access_token});
  }else if (verificationResult==500){
    return res.status(500).json({ message: "Multiple USER ERROR" , access_token: access_token});
  }else if (verificationResult==401){
    return res.status(401).send({ message: "unauthorized. invalid access_token or identifier" , access_token: access_token})
  }else if (verificationResult==200){
    // get updated information from DB before sending to client
    userFromDb = await findUserByIdentifier(userFromDb[0]['identifier'])
    const recordFromDB = await findCheckoutRecordByID(recordID)

    // check if only 1 record is found
    if (recordFromDB.length==0){
        return res.status(404).json({ message: "no record was found" , access_token: access_token});
    }else if (recordFromDB.length>1){
        return res.status(500).json({ message: "MULTIPLE RECORD ERROR" , access_token: access_token});
    }
    
    // check if user ownes the record
    if (recordFromDB[0]['user_identifier']!=userFromDb[0]['identifier']){
        return res.status(403).send({ message: "User does not have access to the record" , access_token: access_token})
      }



    res.status(200).send({record:createhistoryObjectfromDB(recordFromDB[0]),access_token:access_token});
  }   
 
});

module.exports = router;

