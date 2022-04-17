// using google sample: https://github.com/googleapis/google-api-nodejs-client/blob/main/samples/oauth2.js
const { google } = require("googleapis");

/**
 * Create a new OAuth2 client with the configured keys.
 */
const oauth2Client = new google.auth.OAuth2(
  
);

const auth_url = oauth2Client.generateAuthUrl({
  // 'online' (default) or 'offline' (gets refresh_token)
  access_type: "offline",
  prompt: "consent",
  // If you only need one scope you can pass it as a string
  scope: "https://www.googleapis.com/auth/userinfo.email",
});

const get_tokens = async (code: any) => {
  return await oauth2Client.getToken(code);
};

// to update token
const get_refreshed_token = async (refresh_toekn: any) => {
  oauth2Client.setCredentials({
    refresh_token: refresh_toekn,
  });
  oauth2Client.refreshAccessToken(function (err: any, tokens: any) {
    return {
      access_token: tokens.access_token,
    };
  });
};

export { auth_url, get_tokens };
