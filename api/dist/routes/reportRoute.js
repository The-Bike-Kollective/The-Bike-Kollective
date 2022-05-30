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
const bikeHelperfunctions_1 = require("./bikeHelperfunctions");
const router = express_1.default.Router();
// information/instructions: to report missing or stolen bike, makes a bike not available 
// @params: none
// @return: array of Bike objects
// bugs: no known bugs
router.post("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const bike_id = req.params.id;
    console.log(`reporting a stolen/missing bike`);
    console.log(`bike id is :${bike_id}`);
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
        // because the search was done by access token , then here access token is invlid so 401 should be sent
        return res.status(404).send({ message: "User not found. non existing access token", access_token: access_token });
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
        // get bike inforamtion from DB
        let bikeFromDB = yield (0, db_1.findBikeByID)(bike_id);
        // get updated user info to return valid access token
        userFromDb = yield (0, db_1.findUserByIdentifier)(userFromDb[0]["identifier"]);
        access_token = userFromDb[0]["access_token"];
        if (bikeFromDB.length == 0) {
            return res
                .status(404)
                .send({ message: "Bike not found", access_token: access_token });
        }
        else if (bikeFromDB.length == 0) {
            return res
                .status(500)
                .send({ message: "Multiple BIKE ERROR", access_token: access_token });
        }
        // add note  
        const newNoteEntry = {
            id: userFromDb[0]['identifier'],
            timestamp: Date.now(),
            note_body: "Missing/Stolen Report. Bike is not at the location.",
        };
        yield (0, db_1.bikeUpdateNotesDB)(bike_id, [...bikeFromDB[0]["notes"], newNoteEntry]);
        // make it inactive
        yield (0, db_1.bikeUpdateActivenessDB)(bike_id, false);
        // get bike data after updates
        bikeFromDB = yield (0, db_1.findBikeByID)(bike_id);
        let bikeObject = (0, bikeHelperfunctions_1.createBikeObjectfromDB)(bikeFromDB[0]);
        //hide lock combination if requestor has not check out the bike
        if (bikeObject['check_out_id'] != userFromDb[0]['identifier']) {
            bikeObject['lock_combination'] = -99;
        }
        // hide checkout history
        bikeObject['check_out_history'] = [];
        // hide rating history 
        bikeObject['rating_history'] = [];
        // hiding id in notes
        bikeObject.notes.forEach(note => {
            // hide id is notes
            note.id = "hidden";
        });
        // hiding check out id and timestamp
        if (bikeObject['check_out_id'] != "-1") {
            bikeObject['check_out_id'] = "hidden";
            bikeObject['check_out_time'] = -99;
        }
        // there is 1 bike in returned list
        return res
            .status(200)
            .send((0, bikeHelperfunctions_1.createBikeResponse)(bikeObject, access_token));
    }
}));
module.exports = router;
//# sourceMappingURL=reportRoute.js.map