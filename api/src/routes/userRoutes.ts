import express, { Request, Response } from "express";
import {
  get_tokens,
  getProfileInfo,
} from "../services/google_auth";
import {
  addUsertoDB,
  findUserByIdentifier,
  updateAccessTokeninDB,
  updateRefreshTokeninDB,findUserByState
} from "../db/db";
import { IUser } from "../models/user";
import {verifyUserIdentity,userRegistration} from './userHelperFunctions'

const router = express.Router();

// information/instructions: for login redirect to google service
// @params: Auth code
// @return: user data or
// bugs: no known bugs
// TODO: decide on state and login design , might be changed based on frond end team design
// TODO : refactor into correct file
router.post("/", async (req: Request, res: Response) => {

    const state =req.body.state
    const code =req.body.auth_code

    console.log(`in POST users: code:${code}\nstate:${state}`)

    userRegistration(code, state)
    .then((response_code)=>{
      findUserByState(state).then((userInDB) => {
        res.status(response_code).send(createUserObject(userInDB[0]));
      })
    })
    .catch(err => {
      res.status(400).send({"message":"something went wrong"});

    })

    
  
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
    owned_biks: user.owned_biks,
    checked_out_bike: user.checked_out_bike,
    checked_out_time: user.checked_out_time,
    suspended: user.suspended,
    access_token: user.access_token,
    refresh_token: "",
    signed_waiver: user.signed_waiver,
    state: "",
    checkout_history: user.checkout_history,
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
  console.log(`id is :${identifier}`);
  
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
    return res.status(404).json({ message: "User not found" });
  }else if (verificationResult==500){
    return res.status(500).json({ message: "Multiple USER ERROR" });
  }else if (verificationResult==401){
    return res.status(401).send({ message: "unauthorized. invalid access_token or identifier" })
  }else if (verificationResult==200){
    // get updated information from DB before sending to client
    userFromDb = await findUserByIdentifier(identifier)
    res.status(200).send(createUserObject(userFromDb[0]));
  }   
 
});


// For Debug purposes
// TODO: clean in final release
router.get("/find", async (req, res) => {
  const identifier = req.body.identifier;

  const result = await findUserByIdentifier(identifier);

  res.send(createUserObject(result[0]));
});

module.exports = router;

