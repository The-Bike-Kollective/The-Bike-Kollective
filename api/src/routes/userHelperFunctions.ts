import {
  get_tokens,
  getProfileInfo,
  verifyAccessToken,
} from "../services/google_auth";
import {
  findUserByIdentifier,
  updateAccessTokeninDB,
  updateRefreshTokeninDB,
  addUsertoDB,
  updateStateinDB,
} from "../db/db";
import { IUser } from "../models/user";

// information/instructions: verifies a user identity and cross check DB and access token inforamtion.
// This function also renew the access token if expired.
// @params: userObject retrived from DB , accees token from request
// @return: verification codes and messages (200,400,401,500)
// bugs: no known bugs
// TODO: error handling
const verifyUserIdentity = (userFromDb: any, access_token: string) => {
  return new Promise(async (resolve) => {
    if (userFromDb.length == 0) {
      resolve(400);
    } else if (userFromDb.length > 1) {
      resolve(500);
    } else if (userFromDb[0]["access_token"] != access_token) {
      resolve(401);
    }

    const refreshTokenFromDB = userFromDb[0]["refresh_token"];
    console.log("refresh token from DB is:");
    console.log(refreshTokenFromDB);

    const identifierFromDB = userFromDb[0]["identifier"];
    console.log("identifier from DB is:");
    console.log(identifierFromDB);

    const idFromDB = userFromDb[0]["id"];
    console.log("idFromDB is:");
    console.log(idFromDB);

    // check validy of access token, and get a valid one if expired
    access_token = (await verifyAccessToken(
      access_token,
      refreshTokenFromDB
    )) as string;
    //   access_token = await get_renewed_access_token(access_token, refreshTokenFromDB) as string;
    console.log("new Access token is:");
    console.log(access_token);

    // verify user identity by checking identifier
    // TODO: keep or remove?
    const profileData = await getProfileInfo(access_token);

    const identifierFromGoogle =
      profileData["emailAddresses"]["0"]["metadata"]["source"]["id"];

    if (identifierFromGoogle == identifierFromDB) {
      //update accesstoken in DB
      await updateAccessTokeninDB(idFromDB, access_token);
      resolve(200);
    } else {
      resolve(400);
    }
  });
};

const userRegistration = async (code: string, state: string) => {
  return new Promise<number>((resolve, reject) => {
    try {
      get_tokens(code).then((tokens) => {
        console.log(tokens);
        console.log(`after get_token. access token is :${tokens.tokens.access_token}`);
        console.log("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ getting profile info")
        getProfileInfo(tokens.tokens.access_token).then((profileData) => {
        console.log("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ got profile info")
          //if not add a new user
          const profile_firstName = profileData["names"]["0"]["givenName"];
          const profile_lastName = profileData["names"]["0"]["familyName"];
          const profile_identifier =
            profileData["emailAddresses"]["0"]["metadata"]["source"]["id"];
          const profile_email = profileData["emailAddresses"]["0"]["value"];
          const profile_access_token = tokens.tokens["access_token"];
          const profile_refresh_token = tokens.tokens["refresh_token"];

          // TODO: Check DB for existing user
          findUserByIdentifier(profile_identifier).then((userInDB) => {
            if (userInDB.length != 0) {
              // user exists; no sign up only sign in.
              // update access token and refresh token, because they might have been changed by Google Oauth service
              updateRefreshTokeninDB(
                String(userInDB[0]["_id"]),
                profile_refresh_token
              );
              updateAccessTokeninDB(
                String(userInDB[0]["_id"]),
                profile_access_token
              );
              // update state
              updateStateinDB(
                String(userInDB[0]["_id"]),
                state
              );

              resolve(200);
            } else {
              // user does not exist. create a new user
              console.log("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ new user. add to DB")


              addNewUser(
                profile_firstName,
                profile_lastName,
                profile_identifier,
                profile_email,
                profile_access_token,
                profile_refresh_token,
                false,
                state
              ).then((response) => {
                console.log("resolved. send 201")
                resolve(201);
              });
            }
          });
        });
      });
    } catch (err) {
      console.log(err);
      reject(400);
    }
  });
};

// For Debug purposes
// TODO: clean in final release
const addNewUser = async (
  first_name: string,
  family_name: string,
  identifier: string,
  email: string,
  access_token: string,
  refresh_token: string,
  signed_waiver: boolean,
  state: string
) => {
  let data: IUser = {
    family_name: family_name,
    given_name: first_name,
    email: email,
    identifier: identifier,
    owned_biks: [],
    checked_out_bike: "-1",
    checked_out_time: 0,
    suspended: false,
    access_token: access_token,
    refresh_token: refresh_token,
    signed_waiver: signed_waiver,
    state: state,
  };

  console.log('in addNewUser ')

  return addUsertoDB(data)

};

export { verifyUserIdentity, userRegistration};
