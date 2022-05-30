"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createBikeObject = exports.createBikeObjectfromDB = exports.createBikeResponse = exports.validateNoteObject = exports.createNewLocation = exports.createNewCheckout = void 0;
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
    return bikeObject;
    // return Object.fromEntries(Object.entries(bikeObject).sort())
};
exports.createBikeObject = createBikeObject;
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
        size: bikeFromDB.size,
    };
    return bikeObject;
};
exports.createBikeObjectfromDB = createBikeObjectfromDB;
// create HTTP response body
// @params: bike data and access token
// @return: formatted body for HTTP response.
// bugs: no known bugs
const createBikeResponse = (bikeObject, access_token) => {
    return { bike: bikeObject, access_token: access_token };
};
exports.createBikeResponse = createBikeResponse;
function validateNoteObject(note) {
    return note.id !== undefined;
}
exports.validateNoteObject = validateNoteObject;
const createNewCheckout = (user_identifier, bike_id, checkout_location, checkout_timestamp, checkin_location) => {
    let newCheckout = {
        user_identifier: user_identifier,
        bike_id: bike_id,
        checkout_timestamp: checkout_timestamp,
        checkin_timestamp: -1,
        total_minutes: -1,
        condition_on_return: true,
        note: " ",
        rating: -1,
        checkout_location: checkout_location,
        checkin_location: checkin_location,
    };
    console.log(`newCheckout Record created:`);
    console.log(newCheckout);
    return newCheckout;
};
exports.createNewCheckout = createNewCheckout;
const createNewLocation = (long, lat) => {
    let newLocation = {
        lat: lat,
        long: long,
    };
    console.log(`newLocation created:`);
    console.log(newLocation);
    return newLocation;
};
exports.createNewLocation = createNewLocation;
//# sourceMappingURL=bikeHelperfunctions.js.map