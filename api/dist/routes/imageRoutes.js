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
const firebase_1 = require("../services/firebase");
const userHelperFunctions_1 = require("./userHelperFunctions");
const db_1 = require("../db/db");
const router = express_1.default.Router();
// information/instructions: upload recived Base64 encoded image on firestore and returns the download link
// @params: none . (base64 image in JSON body)
// @return: direct download link as string in JSON
// bugs: no known bugs
router.post("/", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    // check if access_token is provided.
    if (!req.headers.authorization) {
        return res.status(403).json({ message: "access token is missing" });
    }
    // verify body
    if (!(yield verifyUploadImagePostBody(req.body))) {
        return res.status(400).send({ message: "invalid body" });
    }
    // splits "Breaer TOKEN" 
    let access_token = req.headers.authorization.split(" ")[1];
    console.log("Access Token from header is:");
    console.log(access_token);
    // retrive user information from DB to find refresh token
    let userFromDb = yield (0, db_1.findUserByAccessToekn)(access_token);
    const verificationResult = yield (0, userHelperFunctions_1.verifyUserIdentity)(userFromDb, access_token);
    if (verificationResult == 404) {
        return res.status(404).json({ message: "User not found. non existing access token", access_token: access_token });
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
        if (!req.body.image) {
            return res.status(400).json({ message: "invalid body" });
        }
        const data = req.body.image;
        console.log("data is: ");
        const buffer = Buffer.from(data, "base64");
        console.log(buffer);
        const downloadURL = yield (0, firebase_1.uploadImage)(buffer);
        res.status(201).send({ url: downloadURL, access_token: access_token });
    }
}));
// information/instructions: verifies body data for image POST
// @params: JSON object form req body
// @return: true if valid, flase if not
// bugs: no known bugs
const verifyUploadImagePostBody = (body) => {
    return new Promise((resolve) => __awaiter(void 0, void 0, void 0, function* () {
        const valid_keys = ["image"];
        const keys_in_body = Object.keys(body);
        if (valid_keys.length != keys_in_body.length) {
            return resolve(false);
        }
        keys_in_body.forEach((key) => {
            if (!valid_keys.includes(key)) {
                return resolve(false);
            }
        });
        return resolve(true);
    }));
};
module.exports = router;
//# sourceMappingURL=imageRoutes.js.map