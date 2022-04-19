import express, { Express, Request, Response } from "express";
import dotenv from "dotenv";
import {
  getAuthURL,
  get_tokens,
  getProfileInfo,
  printKeys,
} from "./services/google_auth";
import { connectDB, addUsertoDB } from "./db/db";
import { IUser } from "./models/user";

dotenv.config({ path: ".env" });

const app: Express = express();
const port = process.env.PORT;

// For Debug purposes
// TODO: clean in final release
connectDB();
printKeys();

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
  

};

// For Debug purposes
// TODO: clean in final release
app.get("/", (req: Request, res: Response) => {
  res.send("Express + TypeScript Server running! :)");
});

// information/instructions: for login redirect to google service
// @params: [Maybe] state
// @return: redirect url
// bugs: no known bugs
// TODO: decide on state and login design , might be changed based on frond end team design
// TODO : refactor into correct file
app.get("/login", (req: Request, res: Response) => {
  // TODO: implement state and DB tasks
  res.redirect(getAuthURL());
});

// information/instructions: call back url for google Oauth2 service. it provides Auth code for JWT inquiry
// @params: [Maybe] state
// @return: redirect url
// bugs: no known bugs
// TODO: decide on state and login design , might be changed based on frond end team design
// TODO : refactor into correct file
// TODO : Add DB calls
app.get("/profile", async (req: Request, res: Response) => {
  try {
    const code = req.query.code;
    const { tokens } = await get_tokens(code);
    console.log(tokens);
    const profileData = await getProfileInfo(tokens);
    // TODO: Check DB for existing user

    //if not add a new user
    const profile_firstName = profileData["names"]["0"]["givenName"];
    const profile_lastName = profileData["names"]["0"]["familyName"];
    const profile_identifier =
      profileData["emailAddresses"]["0"]["metadata"]["source"]["id"];
    const profile_email = profileData["emailAddresses"]["0"]["value"];
    const profile_access_token = tokens["access_token"];
    const profile_refresh_token = tokens["refresh_token"];

    // for debug
    // TODO: Clean
    // console.log("%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    // console.log(profile_firstName);
    // console.log(profile_lastName);
    // console.log(profile_identifier);
    // console.log(profile_email);
    // console.log(profile_access_token);
    // console.log(profile_refresh_token);
    // console.log("%%%%%%%%%%%%%%%%%%%%%%%%%%%%");

    await addNewUser(
      profile_firstName,
      profile_lastName,
      profile_identifier,
      profile_email,
      profile_access_token,
      profile_refresh_token
    );

    res.send(profileData);
  } catch (e) {
    console.log(e);
    res.send(e);
  }
});

app.listen(port, () => {
  console.log(`⚡️[server]: Server is running at https://localhost:${port}`);
});
