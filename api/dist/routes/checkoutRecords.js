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
const checkoutRecordsHelpers_1 = require("./checkoutRecordsHelpers");
const router = express_1.default.Router();
// information/instructions: returns checkout record details
// @params: checkout id
// @return: checkout details
// bugs: no known bugs
// TODO : clean console logs
router.get("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const recordID = req.params.id;
    console.log(`recordID is: ${recordID}`);
    // check if access_token is provided.
    if (!req.headers.authorization) {
        return res.status(403).json({ message: "access token is missing" });
    }
    // splits "Breaer TOKEN" 
    let access_token = req.headers.authorization.split(" ")[1];
    console.log("Access Token from header is:");
    console.log(access_token);
    // retrive user information from DB to find refresh token
    let userFromDb = yield (0, db_1.findUserByAccessToekn)(access_token);
    const verificationResult = yield (0, userHelperFunctions_1.verifyUserIdentity)(userFromDb, access_token);
    if (verificationResult == 404) {
        return res.status(404).json({ message: "User not found", access_token: access_token });
    }
    else if (verificationResult == 500) {
        return res.status(500).json({ message: "Multiple USER ERROR", access_token: access_token });
    }
    else if (verificationResult == 401) {
        return res.status(401).send({ message: "unauthorized. invalid access_token or identifier", access_token: access_token });
    }
    else if (verificationResult == 200) {
        // get updated information from DB before sending to client
        userFromDb = yield (0, db_1.findUserByIdentifier)(userFromDb[0]['identifier']);
        const recordFromDB = yield (0, db_1.findCheckoutRecordByID)(recordID);
        // check if only 1 record is found
        if (recordFromDB.length == 0) {
            return res.status(404).json({ message: "no record was found", access_token: access_token });
        }
        else if (recordFromDB.length > 1) {
            return res.status(500).json({ message: "MULTIPLE RECORD ERROR", access_token: access_token });
        }
        // check if user ownes the record
        if (recordFromDB[0]['user_identifier'] != userFromDb[0]['identifier']) {
            return res.status(403).send({ message: "User does not have access to the record", access_token: access_token });
        }
        res.status(200).send({ record: (0, checkoutRecordsHelpers_1.createhistoryObjectfromDB)(recordFromDB[0]), access_token: access_token });
    }
}));
module.exports = router;
//# sourceMappingURL=checkoutRecords.js.map