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
  updateRefreshTokeninDB
} from "../db/db";
import { IUser } from "../models/user";
import {verifyUserIdentity} from './userHelperFunctions'

const router = express.Router();

// information/instructions: for login redirect to google service
// @params: Auth code
// @return: user data or
// bugs: no known bugs
// TODO: decide on state and login design , might be changed based on frond end team design
// TODO : refactor into correct file
router.post("/", async (req: Request, res: Response) => {
  try {
    const code = req.body.auth_code;
    const { tokens } = await get_tokens(code);
    console.log(tokens);
    const profileData = await getProfileInfo(tokens.access_token);

    //if not add a new user
    const profile_firstName = profileData["names"]["0"]["givenName"];
    const profile_lastName = profileData["names"]["0"]["familyName"];
    const profile_identifier =
      profileData["emailAddresses"]["0"]["metadata"]["source"]["id"];
    const profile_email = profileData["emailAddresses"]["0"]["value"];
    const profile_access_token = tokens["access_token"];
    const profile_refresh_token = tokens["refresh_token"];

    // TODO: Check DB for existing user
    let userInDB = await findUserByIdentifier(profile_identifier);
    if (userInDB.length != 0) {
      // user exists; no sign up only sign in.
      // update access token and refresh token, because they might have been changed by Google Oauth service
      updateRefreshTokeninDB(String(userInDB[0]['_id']),profile_refresh_token)
      updateAccessTokeninDB(String(userInDB[0]['_id']),profile_access_token)

      // get the updated user and send it to user:
      userInDB = await findUserByIdentifier(profile_identifier)
      res.status(200).send(createUserObject(userInDB[0]));
    } else {
      // user does not exist. create a new user
      const newUser = await addNewUser(
        profile_firstName,
        profile_lastName,
        profile_identifier,
        profile_email,
        profile_access_token,
        profile_refresh_token
      );

      res.status(201).send(createUserObject(newUser));
    }
  } catch (e) {
    console.log(e);
    res.send(e);
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
    owned_biks: user.owned_biks,
    check_out_bike: user.check_out_bike,
    checked_out_time: user.checked_out_time,
    suspended: user.suspended,
    access_token: user.access_token,
    refresh_token: "",
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
const addNewUser = async (
  first_name: string,
  family_name: string,
  identifier: string,
  email: string,
  access_token: string,
  refresh_token: string
) => {
  let data: IUser = {
    family_name: family_name,
    given_name: first_name,
    email: email,
    identifier: identifier,
    owned_biks: [],
    check_out_bike: -1,
    checked_out_time: 0,
    suspended: false,
    access_token: access_token,
    refresh_token: refresh_token,
  };

  const result = await addUsertoDB(data);

  return result;
};

// For Debug purposes
// TODO: clean in final release
router.get("/find", async (req, res) => {
  const identifier = req.body.identifier;

  const result = await findUserByIdentifier(identifier);

  res.send(createUserObject(result[0]));
});

module.exports = router;

