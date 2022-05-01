const fs = require("fs");
const path = require("path");
const { google } = require("googleapis");
const axios = require("axios");

// secrets.json path and loading
const keyPath = path.join(__dirname, "../../secrets.json");
let keys = JSON.parse(fs.readFileSync(keyPath, "utf8"));

// OAuth object using secrets
const oauth2Client = new google.auth.OAuth2(
  keys.client_id,
  keys.client_secret,
  keys.redirect_uris[0]
);

// @Debug
// TODO: clean in final release
const printKeys = () => {
  console.log("***********");
  console.log(keyPath);
  console.log(keys["redirect_uris"]);
  console.log("***********");
};

// information/instructions: genrates Auth url
// @params: NONE
// @return: auth_url [string]
// bugs: no known bugs
// TODO: error handler
const getAuthURL = () => {
  const auth_url = oauth2Client.generateAuthUrl({
    // 'online' (default) or 'offline' (gets refresh_token)
    access_type: "offline",
    prompt: "consent",
    // If you only need one scope you can pass it as a string
    scope: "https://www.googleapis.com/auth/userinfo.email",
    include_granted_scopes: true,
  });
  return auth_url;
};

// information/instructions: get tokes from google API
// @params: Auth code
// @return: JSON tokens
// bugs: no known bugs
// TODO: error handler
const get_tokens = async (code: any) => {
  return await oauth2Client.getToken(code);
};

// NOT COMPLETE
// information/instructions: updates token using refresh token
// @params: refresh_token
// @return: JSON ????
// bugs: no known bugs
// TODO: COMPLETE Function
const get_renewed_access_token = async (access_token: string, refresh_token: string) => {
  return new Promise((resolve) => {
    const oauth2Client = new google.auth.OAuth2(
      keys.client_id,
      keys.client_secret
    );
    oauth2Client.setCredentials({
      access_token: access_token,
      refresh_token: refresh_token,
    });

    oauth2Client.refreshAccessToken(function (err: any, tokens: any) {
      console.log("in Refresh token function. token is: ");
      console.log(tokens);
      console.log("in Refresh token function. err is");
      console.log(err);
      resolve(tokens["access_token"]);
    });
  });
};

// information/instructions: get user profile information set in personFields. the Scope should match
// @params: [Maybe] access_token
// @return: JSON data from google API
// bugs: no known bugs
// TODO: error handler
const getProfileInfo = async (access_token: any) => {
  // create a new Oauth object and set credential
  const oauth2Client = new google.auth.OAuth2();
  oauth2Client.setCredentials({ access_token: access_token });
  google.options({ auth: oauth2Client });
  const people = google.people("v1");

  const res = await people.people.get({
    resourceName: "people/me",
    personFields: "names,emailAddresses",
  });

  console.log(res.data);
  return res.data;
};

// https://www.googleapis.com/oauth2/v3/userinfo?access_token
// information/instructions: verifies validity of a token, if expired, gets a new token from OAuth service
// @params:current access token, refresh token
// @return: valid access token
// bugs: no known bugs
// TODO: error handler
const verifyAccessToken = async (accessToken: string,refresh_token: string) => {
  console.log(`in verifyAccessToken. received access token is: ${accessToken}`);

  return new Promise(async (resolve) => {
  try {
    const res = await axios.get(
      "https://www.googleapis.com/oauth2/v3/userinfo",
      { params: { access_token: accessToken } }
    );

    console.log("AXIOS response is: ");
    console.log(res);
    // no error if gets response, so the curretn access token is valid and can be returned. 
    resolve(accessToken);
  } catch (err: any) {
    console.log("AXIOS got an ERROR ");
    if(err.response.status==401){
      // if 401 => token is expired and should be renewed
    console.log("ERROR 401 => refreshing token...");
    get_renewed_access_token(accessToken, refresh_token).then(
      (renwed_token) => {
        console.log('reurning renwed token...');
        resolve(renwed_token);
      }
    );
    }
    // console.log(err);
    // return err
  }})
};

export {
  getAuthURL,
  get_tokens,
  getProfileInfo,
  printKeys,
  verifyAccessToken,
  get_renewed_access_token,
};
