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
// information/instructions: for registering a bike by a valid user
// @params: Auth code
// @return: bike data on success , error message on failure
// bugs: no known bugs
// TODO : refactor into correct file
router.post("/", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
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
    let userFromDb = yield (0, db_1.findUserByAccessToekn)(access_token);
    const verificationResult = yield (0, userHelperFunctions_1.verifyUserIdentity)(userFromDb, access_token);
    if (verificationResult == 404) {
        return res.status(404).json({ message: "User not found" });
    }
    else if (verificationResult == 500) {
        return res.status(500).json({ message: "Multiple USER ERROR" });
    }
    else if (verificationResult == 401) {
        return res
            .status(401)
            .send({ message: "unauthorized. invalid access_token or identifier" });
    }
    else if (verificationResult == 200) {
        console.log("User is verified. Countiue the process");
        // get bike infro from body
        // verify bike type
        // if (!req.body instanceof Bike);
        if (!(yield verifyBikePostBody(req.body))) {
            return res.status(400).json({ message: "invalid body" });
        }
        const date_added = Date.now();
        const image = req.body.image;
        const active = true;
        const condition = true;
        const owner_id = String(userFromDb[0]["identifier"]);
        const lock_combination = req.body.lock_combination;
        // add a function to set notes with user id as an object
        const notes = new Array();
        // add tags
        const rating = 0;
        const rating_history = new Array();
        const location_long = req.body.location_long;
        const location_lat = req.body.location_lat;
        const check_out_id = "-1";
        const check_out_time = -1;
        const check_out_history = new Array();
        const name = req.body.name;
        const type = req.body.type;
        const size = req.body.size;
        const newBike = createBikeObject(date_added, image, active, condition, owner_id, lock_combination, notes, rating, rating_history, location_long, location_lat, check_out_id, check_out_time, check_out_history, name, type, size);
        const bikeFromDB = yield (0, db_1.addBiketoDB)(newBike);
        // get updated user info to return valid access token
        userFromDb = yield (0, db_1.findUserByIdentifier)(userFromDb[0]["identifier"]);
        res.status(201).send(createBikeResponse(createBikeObjectfromDB(bikeFromDB), userFromDb[0]['access_token']));
    }
}));
// information/instructions: returns all bikes in DB
// @params: none
// @return: array of Bike objects
// bugs: no known bugs
// TODO : add pagination
router.get("/", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    console.log("in get all bikes. Fetching from DB...");
    const bikes = yield (0, db_1.getAllBikes)();
    console.log("in get all bikes. Fetched!");
    const bikesToSend = [];
    bikes.forEach((bike) => {
        bikesToSend.push(createBikeObjectfromDB(bike));
    });
    res.status(200).send(bikesToSend);
}));
// information/instructions: returns a single bike information. 
// @params: none
// @return: array of Bike objects
// bugs: no known bugs
// TODO : add pagination
router.get("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const bike_id = req.params.id;
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
    // const userFromDb = await findUserByAccessToekn(access_token)
    let userFromDb = yield (0, db_1.findUserByAccessToekn)(access_token);
    const verificationResult = yield (0, userHelperFunctions_1.verifyUserIdentity)(userFromDb, access_token);
    if (verificationResult == 404) {
        return res.status(404).json({ message: "User not found" });
    }
    else if (verificationResult == 500) {
        return res.status(500).json({ message: "Multiple USER ERROR" });
    }
    else if (verificationResult == 401) {
        return res
            .status(401)
            .send({ message: "unauthorized. invalid access_token or identifier" });
    }
    else if (verificationResult == 200) {
        console.log("User is verified. Countiue the process");
    }
    // get bike inforamtion from DB
    const bikeFromDB = yield (0, db_1.findBikeByID)(bike_id);
    // get updated user info to return valid access token
    userFromDb = yield (0, db_1.findUserByIdentifier)(userFromDb[0]["identifier"]);
    access_token = userFromDb[0]['access_token'];
    if (bikeFromDB.length == 0) {
        return res.status(404).json({ message: "Bike not found", access_token: access_token });
    }
    else if (bikeFromDB.length == 0) {
        return res.status(500).json({ message: "Multiple BIKE ERROR", access_token: access_token });
    }
    // there is 1 bike in returned list
    return res.status(200).send(createBikeResponse(createBikeObjectfromDB(bikeFromDB[0]), access_token));
}));
// information/instructions: to update a bike 
// @params: none
// @return: array of Bike objects
// bugs: no known bugs
// TODO : add pagination
router.put("/:id", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const bike_id = req.params.id;
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
    // const userFromDb = await findUserByAccessToekn(access_token)
    let userFromDb = yield (0, db_1.findUserByAccessToekn)(access_token);
    const verificationResult = yield (0, userHelperFunctions_1.verifyUserIdentity)(userFromDb, access_token);
    if (verificationResult == 404) {
        return res.status(404).json({ message: "User not found" });
    }
    else if (verificationResult == 500) {
        return res.status(500).json({ message: "Multiple USER ERROR" });
    }
    else if (verificationResult == 401) {
        return res
            .status(401)
            .send({ message: "unauthorized. invalid access_token or identifier" });
    }
    else if (verificationResult == 200) {
        console.log("User is verified. Countiue the process");
    }
    // get bike inforamtion from DB
    let bikeFromDB = yield (0, db_1.findBikeByID)(bike_id);
    // get updated user info to return valid access token
    userFromDb = yield (0, db_1.findUserByIdentifier)(userFromDb[0]["identifier"]);
    access_token = userFromDb[0]['access_token'];
    if (bikeFromDB.length == 0) {
        return res.status(404).json({ message: "Bike not found", access_token: access_token });
    }
    else if (bikeFromDB.length == 0) {
        return res.status(500).json({ message: "Multiple BIKE ERROR", access_token: access_token });
    }
    // check if the user is the actual bike owner.
    if (bikeFromDB[0]['owner_id'] != userFromDb[0]['identifier']) {
        return res.status(403).json({ message: "User is not the owner", access_token: access_token });
    }
    // check if bike is not check out and available 
    if (bikeFromDB[0]['check_out_id'] != "-1") {
        return res.status(409).json({ message: "Bike is currently check out", access_token: access_token });
    }
    // user can change the following properties. the other porperties will be chnaged. 
    // 1. name 
    // 2. image 
    // 3. active 
    // 4. condition
    // 5. lock_combination
    // 6. notes [only add a new note]  => validate type
    // 7. size 
    // 8. type
    // 9. location_long
    // 10. location_lat
    // only items that can cause 400 is notes if provided
    let notes = bikeFromDB[0]['notes'];
    if (req.body.notes) {
        if (validateNoteObject(req.body.notes) && req.body.notes.id == userFromDb[0]['identifier']) {
            notes = [...bikeFromDB[0]['notes'], req.body.notes];
        }
        else {
            return res.status(400).json({ message: "invalid note", access_token: access_token });
        }
    }
    // params that might chnage
    const image = req.body.image || bikeFromDB[0]['image'];
    const active = req.body.active || bikeFromDB[0]['active'];
    const condition = req.body.condition || bikeFromDB[0]['condition'];
    const lock_combination = req.body.lock_combination || bikeFromDB[0]['lock_combination'];
    const location_long = req.body.location_long || bikeFromDB[0]['location_long'];
    const location_lat = req.body.location_lat || bikeFromDB[0]['location_lat'];
    const name = req.body.name || bikeFromDB[0]['name'];
    const type = req.body.type || bikeFromDB[0]['type'];
    const size = req.body.size || bikeFromDB[0]['size'];
    // params that are not chaning
    const date_added = bikeFromDB[0]['date_added'];
    const owner_id = bikeFromDB[0]['owner_id'];
    const rating = bikeFromDB[0]['rating'];
    const rating_history = bikeFromDB[0]['rating_history'];
    const check_out_id = bikeFromDB[0]['check_out_id'];
    const check_out_time = bikeFromDB[0]['check_out_time'];
    const check_out_history = bikeFromDB[0]['check_out_history'];
    const newBike = createBikeObject(date_added, image, active, condition, owner_id, lock_combination, notes, rating, rating_history, location_long, location_lat, check_out_id, check_out_time, check_out_history, name, type, size);
    // update bike on DB
    (0, db_1.updateAnExisitngBike)(bikeFromDB[0]['id'], newBike);
    //get updated bike from DB
    bikeFromDB = yield (0, db_1.findBikeByID)(bike_id);
    // return updated result
    return res.status(200).send(createBikeResponse(createBikeObjectfromDB(bikeFromDB[0]), access_token));
}));
// information/instructions: verifies body data for Bike object
// @params: JSON object form req body
// @return: true if valid, flase if not
// bugs: no known bugs
const verifyBikePostBody = (body) => {
    return new Promise((resolve) => __awaiter(void 0, void 0, void 0, function* () {
        const valid_keys = [
            "image",
            "lock_combination",
            "location_long",
            "location_lat",
            "name",
            "size",
            "type"
        ];
        const keys_in_body = Object.keys(body);
        if (valid_keys.length != keys_in_body.length) {
            resolve(false);
        }
        keys_in_body.forEach((key) => {
            if (!valid_keys.includes(key)) {
                resolve(false);
            }
        });
        resolve(true);
    }));
};
// create bike object for DB processing
// @params: bike data from req
// @return: bike data for DB processes
// bugs: no known bugs
const createBikeObject = (date_added, image, active, condition, owner_id, lock_combination, notes, rating, rating_history, location_long, location_lat, check_out_id, check_out_time, check_out_history, name, type, size) => {
    let bikeObject = {
        date_added: date_added,
        image: image,
        active: active,
        condition: condition,
        owner_id: owner_id,
        lock_combination: lock_combination,
        notes: notes,
        rating: rating,
        rating_history: rating_history,
        location_long: location_long,
        location_lat: location_lat,
        check_out_id: check_out_id,
        check_out_time: check_out_time,
        check_out_history: check_out_history,
        name: name,
        type: type,
        size: size,
    };
    ;
    return bikeObject;
    // return Object.fromEntries(Object.entries(bikeObject).sort())
};
// create bike object for response. 
// @params: Bike data from DB
// @return: Bike data for HTTP response
// bugs: no known bugs
const createBikeObjectfromDB = (bikeFromDB) => {
    let bikeObject = {
        date_added: bikeFromDB.date_added,
        image: bikeFromDB.image,
        active: bikeFromDB.active,
        condition: bikeFromDB.condition,
        owner_id: bikeFromDB.owner_id,
        lock_combination: bikeFromDB.lock_combination,
        notes: bikeFromDB.notes,
        rating: bikeFromDB.rating,
        rating_history: bikeFromDB.rating_history,
        location_long: bikeFromDB.location_long,
        location_lat: bikeFromDB.location_lat,
        check_out_id: bikeFromDB.check_out_id,
        check_out_time: bikeFromDB.check_out_time,
        check_out_history: bikeFromDB.check_out_history,
        id: bikeFromDB._id,
        name: bikeFromDB.name,
        type: bikeFromDB.type,
        size: bikeFromDB.size
    };
    return bikeObject;
};
// create HTTP response body
// @params: bike data and access token
// @return: formatted body for HTTP response.
// bugs: no known bugs
const createBikeResponse = (bikeObject, access_token) => {
    return { bike: bikeObject, access_token: access_token };
};
function validateNoteObject(note) {
    return note.id !== undefined;
}
module.exports = router;
//# sourceMappingURL=bikeRoutes.js.map