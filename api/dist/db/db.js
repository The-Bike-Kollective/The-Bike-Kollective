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
exports.updateAnExisitngBike = exports.findBikeByID = exports.getAllBikes = exports.addBiketoDB = exports.updateStateinDB = exports.findUserByState = exports.updateRefreshTokeninDB = exports.updateAccessTokeninDB = exports.findUserByAccessToekn = exports.findUserByID = exports.findUserByIdentifier = exports.addUsertoDB = exports.connectDB = void 0;
const mongoose_1 = __importDefault(require("mongoose"));
const index_1 = require("../index");
let ObjectID = require("mongodb").ObjectID;
const connectDB = function () {
    return __awaiter(this, void 0, void 0, function* () {
        console.log(`db_url is : ${index_1.db_url}`);
        console.log(`db_name is : ${index_1.db_name}`);
        yield mongoose_1.default.connect(index_1.db_url + "/" + index_1.db_name, () => {
            console.log("DB is connected!");
        });
    });
};
exports.connectDB = connectDB;
const UserSchema = new mongoose_1.default.Schema({
    family_name: { type: String, required: true },
    given_name: { type: String, required: true },
    email: { type: String, required: true },
    identifier: { type: String, required: true },
    owned_biks: { type: [Number], required: true },
    check_out_bike: { type: Number, required: true },
    checked_out_time: { type: Number, required: true },
    suspended: { type: Boolean, required: true },
    access_token: { type: String, required: true },
    refresh_token: { type: String, required: true },
    signed_waiver: { type: Boolean, required: true },
    state: { type: String, required: true },
});
const BikeSchema = new mongoose_1.default.Schema({
    date_added: { type: Number, required: true },
    image: { type: String, required: true },
    active: { type: Boolean, required: true },
    condition: { type: Boolean, required: true },
    owner_id: { type: String, required: true },
    lock_combination: { type: Number, required: true },
    notes: { type: [Object], required: true },
    rating: { type: Number, required: true },
    rating_history: { type: [Object], required: true },
    location_long: { type: Number, required: true },
    location_lat: { type: Number, required: true },
    check_out_id: { type: String, required: true },
    check_out_history: { type: [Object], required: true },
    name: { type: String, required: true },
    type: { type: String, required: true },
    size: { type: String, required: true },
});
const User = mongoose_1.default.model("User", UserSchema);
const Bike = mongoose_1.default.model("Bike", BikeSchema);
// information/instructions: add a new user to database
// @params: User object
// @return: user object with _id from DB
// bugs: no known bugs
const addUsertoDB = (newUser) => __awaiter(void 0, void 0, void 0, function* () {
    console.log(`in addUsertoDB`);
    return new Promise((resolve) => {
        User.create(newUser).then((user) => {
            console.log("ADED!");
            console.log(user);
            resolve(user);
        });
    });
});
exports.addUsertoDB = addUsertoDB;
// information/instructions: retrive user by identifier
// @params: identifier as string
// @return: array of user object(s) , empty means to user was found
// bugs: no known bugs
const findUserByIdentifier = (identifier) => __awaiter(void 0, void 0, void 0, function* () {
    return new Promise((resolve, reject) => {
        User.find({ identifier: identifier }).then((user) => {
            console.log(user);
            resolve(user);
        });
    });
});
exports.findUserByIdentifier = findUserByIdentifier;
// information/instructions: retrive user by DB Id
// @params: DB id as string
// @return: array of user object(s) , empty means to user was found
// bugs: no known bugs
const findUserByID = (id) => __awaiter(void 0, void 0, void 0, function* () {
    const user = yield User.find({ _id: new ObjectID(id) });
    console.log(user);
    return user;
});
exports.findUserByID = findUserByID;
// information/instructions: retrive user by accsess token
// @params: accsess token as string
// @return: array of user object(s) , empty means to user was found
// bugs: no known bugs
const findUserByAccessToekn = (access_toekn) => __awaiter(void 0, void 0, void 0, function* () {
    const user = yield User.find({ access_token: access_toekn });
    console.log(user);
    return user;
});
exports.findUserByAccessToekn = findUserByAccessToekn;
// information/instructions: updates users access token on DB
// @params: user DB ID and new access token as string
// @return: true in success and flase in failure
// bugs: no known bugs
const updateAccessTokeninDB = (id, new_access_token) => __awaiter(void 0, void 0, void 0, function* () {
    User.updateOne({ _id: new ObjectID(id) }, { access_token: new_access_token }, function (err, docs) {
        if (err) {
            console.log(err);
            return false;
        }
        else {
            console.log("access token is updated on DB");
            return true;
        }
    });
});
exports.updateAccessTokeninDB = updateAccessTokeninDB;
// information/instructions: updates users state on DB
// @params: user DB ID and new state as string
// @return: true in success and flase in failure
// bugs: no known bugs
const updateStateinDB = (id, new_state) => __awaiter(void 0, void 0, void 0, function* () {
    User.updateOne({ _id: new ObjectID(id) }, { state: new_state }, function (err, docs) {
        if (err) {
            console.log(err);
            return false;
        }
        else {
            console.log("state is updated on DB");
            return true;
        }
    });
});
exports.updateStateinDB = updateStateinDB;
// information/instructions: retrive user by DB Id
// @params: DB id as string
// @return: array of user object(s) , empty means to user was found
// bugs: no known bugs
const findUserByState = (state) => __awaiter(void 0, void 0, void 0, function* () {
    const user = yield User.find({ state: state });
    console.log(user);
    return user;
});
exports.findUserByState = findUserByState;
// information/instructions: updates users refresh token on DB
// @params: user DB ID and new refresh token as string
// @return: true in success and flase in failure
// bugs: no known bugs
const updateRefreshTokeninDB = (id, new_refresh_token) => __awaiter(void 0, void 0, void 0, function* () {
    User.updateOne({ _id: new ObjectID(id) }, { refresh_token: new_refresh_token }, function (err, docs) {
        if (err) {
            console.log(err);
            return false;
        }
        else {
            console.log("access token is updated on DB");
            return true;
        }
    });
});
exports.updateRefreshTokeninDB = updateRefreshTokeninDB;
// information/instructions: add a bike to db
// @params: bike object
// @return: bike object with _id
// bugs: no known bugs
const addBiketoDB = (newBike) => __awaiter(void 0, void 0, void 0, function* () {
    const result = yield Bike.create(newBike);
    console.log("ADED!");
    console.log(result);
    return result;
});
exports.addBiketoDB = addBiketoDB;
// information/instructions: get all bikes in DB
// @params: none
// @return: array of bikes
// bugs: no known bugs
const getAllBikes = () => __awaiter(void 0, void 0, void 0, function* () {
    const result = yield Bike.find();
    console.log("All Bikes");
    console.log(result);
    return result;
});
exports.getAllBikes = getAllBikes;
// information/instructions: retrive bike by DB Id
// @params: DB id as string
// @return: array of user object(s) , empty means to user was found
// bugs: no known bugs
const findBikeByID = (id) => __awaiter(void 0, void 0, void 0, function* () {
    const bike = yield Bike.find({ _id: new ObjectID(id) });
    console.log(bike);
    return bike;
});
exports.findBikeByID = findBikeByID;
// information/instructions: updates and exisitng bike with a new bike object.
// @params: bike object
// @return: none
// bugs: no known bugs
const updateAnExisitngBike = (id, newBike) => __awaiter(void 0, void 0, void 0, function* () {
    const result = yield Bike.replaceOne({ _id: new ObjectID(id) }, newBike);
    console.log("updated!");
});
exports.updateAnExisitngBike = updateAnExisitngBike;
//# sourceMappingURL=db.js.map