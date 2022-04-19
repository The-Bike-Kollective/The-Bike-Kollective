const fs = require("fs");
const path = require("path");
const { google } = require("googleapis");

// secrets.json path and loading
const keyPath = path.join(__dirname, "../../secrets.json");
let keys = JSON.parse(fs.readFileSync(keyPath, "utf8"));


// OAuth object using secrets
const oauth2Client = new google.auth.OAuth2(
  keys.client_id,
  keys.client_secret,
  keys.redirect_uris[0]
);


// For Debug purposes
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
const get_refreshed_token = async (refresh_token: any) => {
  const oauth2Client = new google.auth.OAuth2();
  oauth2Client.setCredentials({ refresh_token: refresh_token });
  oauth2Client.refreshAccessToken(function (err: any, tokens: any) {
    return {
      access_token: tokens.access_token,
    };
  });
};


// information/instructions: get user profile information set in personFields. the Scope should match
// @params: [Maybe] tokens
// @return: JSON data from google API 
// bugs: no known bugs
// TODO: error handler
const getProfileInfo = async (tokens: any) => {
  // create a new Oauth object and set credential
  const oauth2Client = new google.auth.OAuth2();
  oauth2Client.setCredentials({ access_token: tokens.access_token });
  google.options({ auth: oauth2Client });
  const people = google.people("v1");

  const res = await people.people.get({
    resourceName: "people/me",
    personFields: "names,emailAddresses",
  });

  console.log(res.data);
  return res.data;
};

export { getAuthURL, get_tokens, getProfileInfo, printKeys };
