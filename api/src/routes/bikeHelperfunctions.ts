import { IBike, IRating, INote } from "../models/bike";
import {
  CheckoutHistory,
  ICheckoutHistory,
  ILocation,
} from "../models/checkoutHistory";

// create bike object for DB processing
// @params: bike data from req
// @return: bike data for DB processes
// bugs: no known bugs
const createBikeObject = (
    date_added: number,
    image: string,
    active: boolean,
    condition: boolean,
    owner_id: string,
    lock_combination: number,
    notes: Array<INote>,
    rating: number,
    rating_history: Array<IRating>,
    location_long: number,
    location_lat: number,
    check_out_id: string,
    check_out_time: number,
    check_out_history: Array<string>,
    name: string,
    type: string,
    size: string
  ) => {
    let bikeObject: IBike = {
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
  
  // create bike object for response.
  // @params: Bike data from DB
  // @return: Bike data for HTTP response
  // bugs: no known bugs
  const createBikeObjectfromDB = (bikeFromDB: any) => {
    let bikeObject: IBike = {
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
  
  // create HTTP response body
  // @params: bike data and access token
  // @return: formatted body for HTTP response.
  // bugs: no known bugs
  const createBikeResponse = (bikeObject: any, access_token: string) => {
    return { bike: bikeObject, access_token: access_token };
  };
  
  function validateNoteObject(note: any): note is INote {
    return note.id !== undefined;
  }
  
  const createNewCheckout = (
    user_identifier: string,
    bike_id: string,
    checkout_location: ILocation,
    checkout_timestamp: number,
    checkin_location: ILocation
  ) => {
    let newCheckout: ICheckoutHistory = {
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
  
  const createNewLocation = (long: number, lat: number) => {
    let newLocation: ILocation = {
      lat: lat,
      long: long,
    };
  
    console.log(`newLocation created:`);
    console.log(newLocation);
  
    return newLocation;
  };


  export {createNewCheckout,
    createNewLocation,
    validateNoteObject,
    createBikeResponse,
    createBikeObjectfromDB,
    createBikeObject
  }



    
