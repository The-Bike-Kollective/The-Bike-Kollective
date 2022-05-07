"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Bike = void 0;
class Bike {
    constructor(date_added, image, active, condition, owner_id, lock_combination, notes, rating, rating_history, location_long, location_lat, check_out_id, check_out_time, check_out_history, id) {
        this.id = id;
        this.date_added = date_added;
        this.image = image;
        this.active = active;
        this.condition = condition;
        this.owner_id = owner_id;
        this.lock_combination = lock_combination;
        this.notes = notes;
        this.rating = rating;
        this.rating_history = rating_history;
        this.location_long = location_long;
        this.location_lat = location_lat;
        this.check_out_id = check_out_id;
        this.check_out_time = check_out_time;
        this.check_out_history = check_out_history;
    }
}
exports.Bike = Bike;
//# sourceMappingURL=bike.js.map