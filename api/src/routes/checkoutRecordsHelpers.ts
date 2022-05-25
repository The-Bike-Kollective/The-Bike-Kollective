import {CheckoutHistory} from "../models/checkoutHistory";


// create cehcekoutHistory object from DB
// @params: Bike data from DB
// @return: Bike data for HTTP response
// bugs: no known bugs
const createhistoryObjectfromDB = (checkoutRecordDB: any) => {
  
    let checkoutObject = new CheckoutHistory(
      checkoutRecordDB.user_identifier,
      checkoutRecordDB.bike_id,
      checkoutRecordDB.checkout_timestamp,
      checkoutRecordDB.checkin_timestamp,
      checkoutRecordDB.total_minutes,
      checkoutRecordDB.condition_on_return,
      checkoutRecordDB.note,
      checkoutRecordDB.rating,
      checkoutRecordDB.checkout_location,
      checkoutRecordDB.checkin_location,
      checkoutRecordDB._id    
    )
  
    console.log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~checkoutObject is created")
    console.log(checkoutObject)
    
    return checkoutObject;
  };


  export { createhistoryObjectfromDB};