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
    const state = req.body.state;
    const code = req.body.auth_code;
    console.log(`in POST users: code:${code}\nstate:${state}`);
    (0, userHelperFunctions_1.userRegistration)(code, state)
        .then((response_code) => {
        (0, db_1.findUserByState)(state).then((userInDB) => {
            res.status(response_code).send(createUserObject(userInDB[0]));
        });
    })
        .catch(err => {
        res.status(400).send({ "message": "something went wrong" });
    });
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
        checked_out_bike: user.checked_out_bike,
        checked_out_time: user.checked_out_time,
        suspended: user.suspended,
        access_token: user.access_token,
        refresh_token: "",
        signed_waiver: user.signed_waiver,
        state: "",
        checkout_history: user.checkout_history,
        checkout_record_id: user.checkout_record_id
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
router.get("/find", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const identifier = req.body.identifier;
    const result = yield (0, db_1.findUserByIdentifier)(identifier);
    res.send(createUserObject(result[0]));
}));
module.exports = router;
//# sourceMappingURL=userRoutes.js.map