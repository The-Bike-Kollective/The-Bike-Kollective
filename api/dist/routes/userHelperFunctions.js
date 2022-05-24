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
exports.userRegistration = exports.verifyUserIdentity = void 0;
const google_auth_1 = require("../services/google_auth");
const db_1 = require("../db/db");
// information/instructions: verifies a user identity and cross check DB and access token inforamtion.
// This function also renew the access token if expired.
// @params: userObject retrived from DB , accees token from request
// @return: verification codes and messages (200,400,401,500)
// bugs: no known bugs
// TODO: error handling
const verifyUserIdentity = (userFromDb, access_token) => {
    return new Promise((resolve) => __awaiter(void 0, void 0, void 0, function* () {
        if (userFromDb.length == 0) {
            return resolve(404);
        }
        else if (userFromDb.length > 1) {
            return resolve(500);
        }
        else if (userFromDb[0]["access_token"] != access_token) {
            return resolve(401);
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
        access_token = (yield (0, google_auth_1.verifyAccessToken)(access_token, refreshTokenFromDB));
        //   access_token = await get_renewed_access_token(access_token, refreshTokenFromDB) as string;
        console.log("new Access token is:");
        console.log(access_token);
        // verify user identity by checking identifier
        // TODO: keep or remove?
        const profileData = yield (0, google_auth_1.getProfileInfo)(access_token);
        const identifierFromGoogle = profileData["emailAddresses"]["0"]["metadata"]["source"]["id"];
        if (identifierFromGoogle == identifierFromDB) {
            //update accesstoken in DB
            yield (0, db_1.updateAccessTokeninDB)(idFromDB, access_token);
            return resolve(200);
        }
        else {
            return resolve(400);
        }
    }));
};
exports.verifyUserIdentity = verifyUserIdentity;
const userRegistration = (code, state) => __awaiter(void 0, void 0, void 0, function* () {
    return new Promise((resolve, reject) => {
        (0, google_auth_1.get_tokens)(code)
            .then((tokens) => {
            console.log(tokens);
            console.log(`after get_token. access token is :${tokens.tokens.access_token}`);
            console.log("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ getting profile info");
            (0, google_auth_1.getProfileInfo)(tokens.tokens.access_token).then((profileData) => {
                console.log("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ got profile info");
                //if not, add a new user
                const profile_firstName = profileData["names"]["0"]["givenName"];
                const profile_lastName = profileData["names"]["0"]["familyName"];
                const profile_identifier = profileData["emailAddresses"]["0"]["metadata"]["source"]["id"];
                const profile_email = profileData["emailAddresses"]["0"]["value"];
                const profile_access_token = tokens.tokens["access_token"];
                const profile_refresh_token = tokens.tokens["refresh_token"];
                const checkout_history = new Array();
                // TODO: Check DB for existing user
                (0, db_1.findUserByIdentifier)(profile_identifier).then((userInDB) => {
                    if (userInDB.length != 0) {
                        // user exists; no sign up only sign in.
                        // update access token and refresh token, because they might have been changed by Google Oauth service
                        (0, db_1.updateRefreshTokeninDB)(String(userInDB[0]["_id"]), profile_refresh_token);
                        (0, db_1.updateAccessTokeninDB)(String(userInDB[0]["_id"]), profile_access_token);
                        // update state
                        (0, db_1.updateStateinDB)(String(userInDB[0]["_id"]), state);
                        return resolve(200);
                    }
                    else {
                        // user does not exist. create a new user
                        console.log("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ new user. add to DB");
                        addNewUser(profile_firstName, profile_lastName, profile_identifier, profile_email, profile_access_token, profile_refresh_token, false, state, checkout_history).then((response) => {
                            console.log("resolved. send 201");
                            return resolve(201);
                        });
                    }
                });
            });
        })
            .catch((err) => {
            console.log(`################### ERRORRRRRR!!!!!!!`);
            console.log(err);
            reject(400);
        });
    });
});
exports.userRegistration = userRegistration;
// For Debug purposes
// TODO: clean in final release
const addNewUser = (first_name, family_name, identifier, email, access_token, refresh_token, signed_waiver, state, checkout_history) => __awaiter(void 0, void 0, void 0, function* () {
    let data = {
        family_name: family_name,
        given_name: first_name,
        email: email,
        identifier: identifier,
        owned_bikes: [],
        checked_out_bike: "-1",
        checked_out_time: 0,
        suspended: false,
        access_token: access_token,
        refresh_token: refresh_token,
        signed_waiver: signed_waiver,
        state: state,
        checkout_history: checkout_history,
        checkout_record_id: "-1"
    };
    console.log('in addNewUser ');
    return (0, db_1.addUsertoDB)(data);
});
//# sourceMappingURL=userHelperFunctions.js.map