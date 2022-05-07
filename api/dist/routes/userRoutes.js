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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const google_auth_1 = require("../services/google_auth");
const db_1 = require("../db/db");
const userHelperFunctions_1 = require("./userHelperFunctions");
const router = express_1.default.Router();
// information/instructions: for login redirect to google service
// @params: Auth code
// @return: user data or
// bugs: no known bugs
// TODO: decide on state and login design , might be changed based on frond end team design
// TODO : refactor into correct file
router.post("/", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const code = req.body.auth_code;
        const { tokens } = yield (0, google_auth_1.get_tokens)(code);
        console.log(tokens);
        const profileData = yield (0, google_auth_1.getProfileInfo)(tokens.access_token);
        //if not add a new user
        const profile_firstName = profileData["names"]["0"]["givenName"];
        const profile_lastName = profileData["names"]["0"]["familyName"];
        const profile_identifier = profileData["emailAddresses"]["0"]["metadata"]["source"]["id"];
        const profile_email = profileData["emailAddresses"]["0"]["value"];
        const profile_access_token = tokens["access_token"];
        const profile_refresh_token = tokens["refresh_token"];
        // TODO: Check DB for existing user
        let userInDB = yield (0, db_1.findUserByIdentifier)(profile_identifier);
        if (userInDB.length != 0) {
            // user exists; no sign up only sign in.
            // update access token and refresh token, because they might have been changed by Google Oauth service
            (0, db_1.updateRefreshTokeninDB)(String(userInDB[0]['_id']), profile_refresh_token);
            (0, db_1.updateAccessTokeninDB)(String(userInDB[0]['_id']), profile_access_token);
            // get the updated user and send it to user:
            userInDB = yield (0, db_1.findUserByIdentifier)(profile_identifier);
            res.status(200).send(createUserObject(userInDB[0]));
        }
        else {
            // user does not exist. create a new user
            const newUser = yield addNewUser(profile_firstName, profile_lastName, profile_identifier, profile_email, profile_access_token, profile_refresh_token);
            res.status(201).send(createUserObject(newUser));
        }
    }
    catch (e) {
        console.log(e);
        res.send(e);
    }
}));
// create user object for response. replace refresh token with an empty string for security purposes.
// @params: user data from DB
// @return: user data for HTTP response
// bugs: no known bugs
const createUserObject = (user) => {
    let userObject = {
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
router.get("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
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
    let userFromDb = yield (0, db_1.findUserByIdentifier)(identifier);
    const verificationResult = yield (0, userHelperFunctions_1.verifyUserIdentity)(userFromDb, access_token);
    if (verificationResult == 404) {
        return res.status(404).json({ message: "User not found" });
    }
    else if (verificationResult == 500) {
        return res.status(500).json({ message: "Multiple USER ERROR" });
    }
    else if (verificationResult == 401) {
        return res.status(401).send({ message: "unauthorized. invalid access_token or identifier" });
    }
    else if (verificationResult == 200) {
        // get updated information from DB before sending to client
        userFromDb = yield (0, db_1.findUserByIdentifier)(identifier);
        res.status(200).send(createUserObject(userFromDb[0]));
    }
}));
// For Debug purposes
// TODO: clean in final release
const addNewUser = (first_name, family_name, identifier, email, access_token, refresh_token) => __awaiter(void 0, void 0, void 0, function* () {
    let data = {
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
    const result = yield (0, db_1.addUsertoDB)(data);
    return result;
});
// For Debug purposes
// TODO: clean in final release
router.get("/find", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const identifier = req.body.identifier;
    const result = yield (0, db_1.findUserByIdentifier)(identifier);
    res.send(createUserObject(result[0]));
}));
module.exports = router;
//# sourceMappingURL=userRoutes.js.map