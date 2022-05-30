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
exports.bikeUpdateActivenessDB = exports.bikeUpdateAvergaeRatingDB = exports.changeUserSuspensionMoodeDB = exports.addBikeToOwnerListDB = exports.userSignedWaiverDB = exports.bikeUpdateNotesDB = exports.bikeUpdateConditionDB = exports.bikeUpdateRatingHistoryDB = exports.bikeUpdateLocationDB = exports.userCheckInABikeDB = exports.updateAnExisitngCheckoutHistory = exports.findCheckoutRecordByID = exports.addCheckoutRecordToDB = exports.userCheckoutABikeDB = exports.updateAnExisitngBike = exports.findBikeByID = exports.getAllBikes = exports.addBiketoDB = exports.updateStateinDB = exports.findUserByState = exports.updateRefreshTokeninDB = exports.updateAccessTokeninDB = exports.findUserByAccessToekn = exports.findUserByID = exports.findUserByIdentifier = exports.addUsertoDB = exports.connectDB = void 0;
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
    owned_bikes: { type: [String], required: true },
    checked_out_bike: { type: String, required: true },
    checked_out_time: { type: Number, required: true },
    suspended: { type: Boolean, required: true },
    access_token: { type: String, required: true },
    refresh_token: { type: String, required: true },
    signed_waiver: { type: Boolean, required: true },
    state: { type: String, required: true },
    checkout_history: { type: [String], required: true },
    checkout_record_id: { type: String, required: true },
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
    check_out_time: { type: Number, required: true },
    check_out_history: { type: [Object], required: true },
    name: { type: String, required: true },
    type: { type: String, required: true },
    size: { type: String, required: true },
});
const CheckoutHistorySchema = new mongoose_1.default.Schema({
    user_identifier: { type: String, required: true },
    bike_id: { type: String, required: true },
    checkout_timestamp: { type: Number, required: true },
    checkin_timestamp: { type: Number, required: true },
    total_minutes: { type: Number, required: true },
    condition_on_return: { type: String, required: true },
    note: { type: String, required: true },
    rating: { type: Number, required: true },
    checkout_location: { type: [Object], required: true },
    checkin_location: { type: [Object], required: true },
});
const User = mongoose_1.default.model("User", UserSchema);
const Bike = mongoose_1.default.model("Bike", BikeSchema);
const CheckoutHistory = mongoose_1.default.model("CheckoutHistory", CheckoutHistorySchema);
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
// information/instructions: updates users state on DB
// @params: user DB ID and new state as string
// @return: true in success and flase in failure
// bugs: no known bugs
const addBikeToOwnerListDB = (id, updated_bike_list) => __awaiter(void 0, void 0, void 0, function* () {
    User.updateOne({ _id: new ObjectID(id) }, { owned_bikes: updated_bike_list }, function (err, docs) {
        if (err) {
            console.log(err);
            return false;
        }
        else {
            console.log("Bike added to the owner list list");
            return true;
        }
    });
});
exports.addBikeToOwnerListDB = addBikeToOwnerListDB;
// information/instructions: retrive user by state 
// @params: state as string
// @return: array of user object(s) , empty means to user was found
// bugs: no known bugs
const findUserByState = (state) => __awaiter(void 0, void 0, void 0, function* () {
    const user = yield User.find({ state: state });
    console.log(user);
    return user;
});
exports.findUserByState = findUserByState;
const userSignedWaiverDB = (id) => __awaiter(void 0, void 0, void 0, function* () {
    const result = yield User.updateOne({ _id: new ObjectID(id) }, { $set: { signed_waiver: true } });
    console.log(`userSignedWaiverDB`);
    console.log(result);
    return true;
});
exports.userSignedWaiverDB = userSignedWaiverDB;
const changeUserSuspensionMoodeDB = (id, suspension) => __awaiter(void 0, void 0, void 0, function* () {
    const result = yield User.updateOne({ _id: new ObjectID(id) }, { $set: { suspended: suspension } });
    console.log(`changeUserSuspensionMoodeDB is changed to :${suspension}`);
    console.log(result);
    return true;
});
exports.changeUserSuspensionMoodeDB = changeUserSuspensionMoodeDB;
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
const getAllBikes = (type, size) => __awaiter(void 0, void 0, void 0, function* () {
    let result;
    if (type == null && size == null) {
        console.log("All Bikes. size and type both are null");
        result = yield Bike.find();
    }
    else if (type != null && size == null) {
        console.log("All Bikes. type is NOT null and size is null");
        result = yield Bike.find({ type: type });
    }
    else if (type == null && size != null) {
        console.log("All Bikes. type is null and size is NOT");
        result = yield Bike.find({ size: size });
    }
    else {
        console.log("All Bikes. size and type both are NOT null");
        result = yield Bike.find({ size: size, type: type });
    }
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
// information/instructions: custom update function. update value of a key in DB for bike
// @params: bike id, key and new value
// @return: noen
// bugs: no known bugs
const bikeUpdateLocationDB = (bike_id, new_location_long, new_location_lat) => __awaiter(void 0, void 0, void 0, function* () {
    const result = yield Bike.updateOne({ _id: new ObjectID(bike_id) }, { $set: { location_long: new_location_long,
            location_lat: new_location_lat } });
    console.log(`bikeUpdateLocationDB updated`);
    console.log(result);
    return true;
});
exports.bikeUpdateLocationDB = bikeUpdateLocationDB;
const bikeUpdateRatingHistoryDB = (bike_id, new_value) => __awaiter(void 0, void 0, void 0, function* () {
    const result = yield Bike.updateOne({ _id: new ObjectID(bike_id) }, { $set: { rating_history: new_value } });
    console.log(`bikeUpdateRatingHistoryDB updated`);
    console.log(result);
    return true;
});
exports.bikeUpdateRatingHistoryDB = bikeUpdateRatingHistoryDB;
const bikeUpdateConditionDB = (bike_id, new_value) => __awaiter(void 0, void 0, void 0, function* () {
    const result = yield Bike.updateOne({ _id: new ObjectID(bike_id) }, { $set: { condition: new_value } });
    console.log(`bikeUpdateConditionDB updated`);
    console.log(result);
    return true;
});
exports.bikeUpdateConditionDB = bikeUpdateConditionDB;
const bikeUpdateActivenessDB = (bike_id, new_value) => __awaiter(void 0, void 0, void 0, function* () {
    const result = yield Bike.updateOne({ _id: new ObjectID(bike_id) }, { $set: { active: new_value } });
    console.log(`bikeUpdateActivenessDB updated`);
    console.log(result);
    return true;
});
exports.bikeUpdateActivenessDB = bikeUpdateActivenessDB;
const bikeUpdateNotesDB = (bike_id, new_value) => __awaiter(void 0, void 0, void 0, function* () {
    const result = yield Bike.updateOne({ _id: new ObjectID(bike_id) }, { $set: { notes: new_value } });
    console.log(`bikeUpdateNotesDB updated`);
    console.log(result);
    return true;
});
exports.bikeUpdateNotesDB = bikeUpdateNotesDB;
const bikeUpdateAvergaeRatingDB = (bike_id) => __awaiter(void 0, void 0, void 0, function* () {
    // get bike information
    const bike = yield Bike.find({ _id: new ObjectID(bike_id) });
    let totalRating = 0;
    const ratings = bike[0].rating_history;
    ratings.forEach((rating) => {
        totalRating += rating.rating_value;
    });
    const averageRating = totalRating / ratings.length;
    const result = yield Bike.updateOne({ _id: new ObjectID(bike_id) }, { $set: { rating: averageRating.toFixed(1) } });
    console.log(`bikeUpdateAvergaeRatingDB updated. new rating is: ${averageRating.toFixed(1)}`);
    console.log(result);
    return true;
});
exports.bikeUpdateAvergaeRatingDB = bikeUpdateAvergaeRatingDB;
// information/instructions: updates and exisitng bike with a new bike object.
// @params: bike object
// @return: none
// bugs: no known bugs
const updateAnExisitngBike = (id, newBike) => __awaiter(void 0, void 0, void 0, function* () {
    const result = yield Bike.replaceOne({ _id: new ObjectID(id) }, newBike);
    console.log("updated!");
});
exports.updateAnExisitngBike = updateAnExisitngBike;
// information/instructions: check out a bike for a user and update models
// @params: user id, bike id and timestamp
// @return: none
// bugs: no known bugs
const userCheckoutABikeDB = (user_id, bike_id, user_identifier, timestamp, checkoutRecordId) => __awaiter(void 0, void 0, void 0, function* () {
    yield User.updateOne({ _id: new ObjectID(user_id) }, {
        $set: {
            checked_out_bike: bike_id,
            checked_out_time: timestamp,
            checkout_record_id: checkoutRecordId,
        },
    });
    yield Bike.updateOne({ _id: new ObjectID(bike_id) }, { $set: { check_out_id: user_identifier, check_out_time: timestamp } });
    console.log("Bike checked out in DB!");
    return true;
});
exports.userCheckoutABikeDB = userCheckoutABikeDB;
// information/instructions: check in a bike for a user and update models
// @params: user id, bike id and timestamp
// @return: none
// bugs: no known bugs
const userCheckInABikeDB = (user_id, bike_id, bike_check_out_history, user_checkout_history) => __awaiter(void 0, void 0, void 0, function* () {
    yield User.updateOne({ _id: new ObjectID(user_id) }, {
        $set: {
            checked_out_bike: "-1",
            checked_out_time: -1,
            checkout_record_id: "-1",
            checkout_history: user_checkout_history
        },
    });
    yield Bike.updateOne({ _id: new ObjectID(bike_id) }, { $set: { check_out_id: "-1", check_out_time: -1, check_out_history: bike_check_out_history } });
    console.log("Bike checked in back in DB!");
    return true;
});
exports.userCheckInABikeDB = userCheckInABikeDB;
// information/instructions: add a a checkoutRecord to DB
// @params: checkout object
// @return: checkout object with _id
// bugs: no known bugs
const addCheckoutRecordToDB = (newCheckoutRecord) => __awaiter(void 0, void 0, void 0, function* () {
    const result = yield CheckoutHistory.create(newCheckoutRecord);
    console.log(`Check out record ADED to DB. _id=${result._id}`);
    console.log(result);
    return result;
});
exports.addCheckoutRecordToDB = addCheckoutRecordToDB;
// information/instructions: retrive check out record by DB Id
// @params: DB id as string
// @return: array of checkout record object(s) , empty means no record with that id was found
// bugs: no known bugs
const findCheckoutRecordByID = (id) => __awaiter(void 0, void 0, void 0, function* () {
    const record = yield CheckoutHistory.find({ _id: new ObjectID(id) });
    console.log(record);
    return record;
});
exports.findCheckoutRecordByID = findCheckoutRecordByID;
// information/instructions: updates an exisitng checkout History with a new checkout object.
// @params: checkout object
// @return: none
// bugs: no known bugs
const updateAnExisitngCheckoutHistory = (newCheckoutObject) => __awaiter(void 0, void 0, void 0, function* () {
    const result = yield CheckoutHistory.replaceOne({ _id: new ObjectID(newCheckoutObject.id) }, newCheckoutObject);
    console.log(`cehckoutHistory with id =${newCheckoutObject.id} updated!`);
});
exports.updateAnExisitngCheckoutHistory = updateAnExisitngCheckoutHistory;
//# sourceMappingURL=db.js.map