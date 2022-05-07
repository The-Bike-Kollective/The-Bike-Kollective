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
exports.verifyUserIdentity = void 0;
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
            resolve(400);
        }
        else if (userFromDb.length > 1) {
            resolve(500);
        }
        else if (userFromDb[0]["access_token"] != access_token) {
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
            resolve(200);
        }
        else {
            resolve(400);
        }
    }));
};
exports.verifyUserIdentity = verifyUserIdentity;
//# sourceMappingURL=userHelperFunctions.js.map