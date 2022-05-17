"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.get_renewed_access_token = exports.verifyAccessToken = exports.printKeys = exports.getProfileInfo = exports.get_tokens = exports.getAuthURL = void 0;
const fs = require("fs");
const path = require("path");
const { google } = require("googleapis");
const axios = require("axios");
// secrets.json path and loading
const keyPath = path.join(__dirname, "../../secrets.json");
let keys = JSON.parse(fs.readFileSync(keyPath, "utf8"));
// OAuth object using secrets
const oauth2Client = new google.auth.OAuth2(keys.client_id, keys.client_secret, keys.redirect_uris[0]);
// @Debug
// TODO: clean in final release
const printKeys = () => {
    console.log("***********");
    console.log(keyPath);
    console.log(keys["redirect_uris"]);
    console.log("***********");
};
exports.printKeys = printKeys;
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
        state: "test_state",
    });
    console.log(`auth_url :${auth_url}`);
    return auth_url;
};
exports.getAuthURL = getAuthURL;
// information/instructions: get tokes from google API
// @params: Auth code
// @return: JSON tokens
// bugs: no known bugs
// TODO: error handler
const get_tokens = (code) => __awaiter(void 0, void 0, void 0, function* () {
    return new Promise((resolve, reject) => {
        oauth2Client.getToken(code).then((response) => {
            resolve(response);
        });
    });
});
exports.get_tokens = get_tokens;
// NOT COMPLETE
// information/instructions: updates token using refresh token
// @params: refresh_token
// @return: JSON ????
// bugs: no known bugs
// TODO: COMPLETE Function
const get_renewed_access_token = (access_token, refresh_token) => __awaiter(void 0, void 0, void 0, function* () {
    return new Promise((resolve) => {
        const oauth2Client = new google.auth.OAuth2(keys.client_id, keys.client_secret);
        oauth2Client.setCredentials({
            access_token: access_token,
            refresh_token: refresh_token,
        });
        oauth2Client.refreshAccessToken(function (err, tokens) {
            console.log("in Refresh token function. token is: ");
            console.log(tokens);
            console.log("in Refresh token function. err is");
            console.log(err);
            resolve(tokens["access_token"]);
        });
    });
});
exports.get_renewed_access_token = get_renewed_access_token;
// information/instructions: get user profile information set in personFields. the Scope should match
// @params: [Maybe] access_token
// @return: JSON data from google API
// bugs: no known bugs
// TODO: error handler
const getProfileInfo = (access_token) => __awaiter(void 0, void 0, void 0, function* () {
    // create a new Oauth object and set credential
    return new Promise((resolve, reject) => {
        const oauth2Client = new google.auth.OAuth2();
        console.log(`in getProfileInfo: access token is :${access_token}`);
        oauth2Client.setCredentials({ access_token: access_token });
        google.options({ auth: oauth2Client });
        const people = google.people("v1");
        people.people
            .get({
            resourceName: "people/me",
            personFields: "names,emailAddresses",
        })
            .then((response) => {
            console.log(`@@@@@@@@@@@@@@@@@@@@@@@@@@@@got response from People API`);
            console.log(response.data);
            resolve(response.data);
        });
    });
});
exports.getProfileInfo = getProfileInfo;
// https://www.googleapis.com/oauth2/v3/userinfo?access_token
// information/instructions: verifies validity of a token, if expired, gets a new token from OAuth service
// @params:current access token, refresh token
// @return: valid access token
// bugs: no known bugs
// TODO: error handler
const verifyAccessToken = (accessToken, refresh_token) => __awaiter(void 0, void 0, void 0, function* () {
    console.log(`in verifyAccessToken. received access token is: ${accessToken}`);
    return new Promise((resolve) => __awaiter(void 0, void 0, void 0, function* () {
        try {
            const res = yield axios.get("https://www.googleapis.com/oauth2/v3/userinfo", { params: { access_token: accessToken } });
            console.log("AXIOS response is: ");
            console.log(res);
            // no error if gets response, so the curretn access token is valid and can be returned.
            resolve(accessToken);
        }
        catch (err) {
            console.log("AXIOS got an ERROR ");
            if (err.response.status == 401) {
                // if 401 => token is expired and should be renewed
                console.log("ERROR 401 => refreshing token...");
                get_renewed_access_token(accessToken, refresh_token).then((renwed_token) => {
                    console.log("reurning renwed token...");
                    resolve(renwed_token);
                });
            }
            // console.log(err);
            // return err
        }
    }));
});
exports.verifyAccessToken = verifyAccessToken;
//# sourceMappingURL=google_auth.js.map