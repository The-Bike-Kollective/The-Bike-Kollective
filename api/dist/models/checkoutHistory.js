"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CheckoutHistory = void 0;
class CheckoutHistory {
    constructor(user_identifier, bike_id, checkout_timestamp, checkin_timestamp, total_minutes, condition_on_return, note, rating, checkout_location, checkin_location, id) {
        this.calculateMinutes = () => {
            let elapsedTimeMS = Math.abs(this.checkin_timestamp - this.checkout_timestamp); //miliseconds
            let elapsedTimeS = elapsedTimeMS / 1000; //secconds
            let elapsedTimeM = Math.floor(elapsedTimeS / 60); // minutes
            console.log(`Minutes clac: ${this.checkin_timestamp} - ${this.checkout_timestamp} = ${elapsedTimeMS}(ms)\n/60 = ${elapsedTimeS} (s) \n/60 = ${elapsedTimeM} (min)`);
            this.total_minutes = elapsedTimeM;
        };
        this.checkInUpdate = (checkin_timestamp, checkin_location, note, rating, condition_on_return) => {
            this.checkin_timestamp = checkin_timestamp;
            this.checkin_location = checkin_location;
            this.note = note;
            this.rating = rating;
            this.condition_on_return = condition_on_return;
        };
        this.user_identifier = user_identifier;
        this.bike_id = bike_id;
        this.checkout_timestamp = checkout_timestamp;
        this.checkin_timestamp = checkin_timestamp;
        this.total_minutes = total_minutes,
            this.condition_on_return = condition_on_return,
            this.note = note,
            this.rating = rating,
            this.checkout_location = checkout_location,
            this.checkin_location = checkin_location;
        this.id = id;
    }
}
exports.CheckoutHistory = CheckoutHistory;
//# sourceMappingURL=checkoutHistory.js.map