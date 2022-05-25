import express, { Request, Response } from "express";
import {
  findUserByIdentifier,
  updateStateinDB,
  findUserByState,
  userSignedWaiverDB
} from "../db/db";
import { IUser } from "../models/user";
import {verifyUserIdentity,userRegistration} from './userHelperFunctions'

const router = express.Router();

// information/instructions: for login redirect to google service
// @params: Auth code
// @return: user data or
// bugs: no known bugs
router.post("/", async (req: Request, res: Response) => {

    // verify body
    if (!(await verifyUserPostBody(req.body))) {
      return res.status(400).send({ message: "invalid body"});
    }

    const state =req.body.state
    const code =req.body.auth_code

    console.log(`in POST users: code:${code}\nstate:${state}`)

    userRegistration(code, state)
    .then((response_code)=>{
      findUserByState(state).then((userInDB) => {
        res.status(response_code).send({user:createUserObject(userInDB[0]),accessToken:userInDB[0]['access_token']});
      })
    })
    .catch(err => {
      res.status(400).send({"message":"Invalid Auth code"});

    })

    
  
});


// information/instructions: used for front app as final sign in process. it returns the user data assocoated with the 
// state and set state to empty string
// @params: Auth code
// @return: user data+ access token or error message
// bugs: no known bugs
router.post("/signin", async (req: Request, res: Response) => {

  const state =req.body.state

  if(!state || state==""){
    res.status(400).send({"message":"state is missing"});
  }

  console.log(`in POST /signin: state:${state}`)

  findUserByState(state)
  .then((user)=>{
    if(user.length==0){
      res.status(404).send({"message":"User not found. verify state"});
    }else if(user.length>1){
      res.status(500).send({"message":"MULTIPLE USER ERROR!"});
    }else if(user.length==1){
      // clear state for privacy and seecurity reasons
      updateStateinDB(String(user[0]['_id']),"")
      res.status(200).send({user:createUserObject(user[0]),accessToken:user[0]['access_token']});
    }else{
      res.status(400).send({"message":"something went wrong with DB"});
    }
  })
  .catch(err => {
    res.status(400).send({"message":"something went wrong with an ERROR"});

  }) 

});


// information/instructions: sign waiver for a user
// @params: Auth code
// @return: success or error message with access token
// bugs: no known bugs
router.post("/waiver/:id", async (req: Request, res: Response) => {

  const identifier = req.params.id;
  console.log(`identifier is :${identifier}`);
  
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
  let userFromDb = await findUserByIdentifier(identifier)

  const verificationResult = await verifyUserIdentity(userFromDb,access_token)

  if (verificationResult==404){
    return res.status(404).json({ message: "User not found. verify identifier", access_token: access_token});
  }else if (verificationResult==500){
    return res.status(500).json({ message: "Multiple USER ERROR" , access_token: access_token});
  }else if (verificationResult==401){
    return res.status(401).send({ message: "unauthorized. invalid access_token or identifier" , access_token: access_token})
  }else if (verificationResult==200){
    // get updated information from DB before sending to client
    userFromDb = await findUserByIdentifier(identifier)
    userSignedWaiverDB(String(userFromDb[0]['_id']))
    res.status(200).send({message:"waiver is signed", access_token:userFromDb[0]['access_token']});
  } 

});

// create user object for response. replace refresh token with an empty string for security purposes.
// @params: user data from DB
// @return: user data for HTTP response
// bugs: no known bugs
const createUserObject = (user: any) => {
  let userObject: IUser = {
    id: user._id,
    family_name: user.family_name,
    given_name: user.given_name,
    email: user.email,
    identifier: user.identifier,
    owned_bikes: user.owned_bikes,
    checked_out_bike: user.checked_out_bike,
    checked_out_time: user.checked_out_time,
    suspended: user.suspended,
    access_token: user.access_token,
    refresh_token: "",
    signed_waiver: user.signed_waiver,
    state: "",
    checkout_history: user.checkout_history,
    checkout_record_id:user.checkout_record_id
  };

  return userObject;
};

// information/instructions: for login redirect to google service
// @params: Auth code
// @return: user data or
// bugs: no known bugs
// TODO: decide on state and login design , might be changed based on frond end team design
// TODO : clean console logs
router.get("/:id", async (req, res) => {
  const identifier = req.params.id;
  console.log(`identifier is :${identifier}`);
  
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
  let userFromDb = await findUserByIdentifier(identifier)

  const verificationResult = await verifyUserIdentity(userFromDb,access_token)

  if (verificationResult==404){
    return res.status(404).json({ message: "User not found. verify identifier" , access_token: access_token});
  }else if (verificationResult==500){
    return res.status(500).json({ message: "Multiple USER ERROR" , access_token: access_token});
  }else if (verificationResult==401){
    return res.status(401).send({ message: "unauthorized. invalid access_token or identifier" , access_token: access_token})
  }else if (verificationResult==200){
    // get updated information from DB before sending to client
    userFromDb = await findUserByIdentifier(identifier)
    res.status(200).send({user:createUserObject(userFromDb[0]), access_token: access_token});
  }   
 
});


// information/instructions: verifies body data for user POST
// @params: JSON object form req body
// @return: true if valid, flase if not
// bugs: no known bugs
const verifyUserPostBody = (body: object) => {
  return new Promise(async (resolve) => {
    const valid_keys = ["auth_code", "state"];
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

module.exports = router;

