"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.User = void 0;
class User {
    constructor(family_name, given_name, email, identifier, owned_biks, checked_out_bike, checked_out_time, suspended, access_token, refresh_token, signed_waiver, state, id) {
        this.id = id;
        this.family_name = family_name;
        this.given_name = given_name;
        this.email = email;
        this.identifier = identifier;
        this.owned_biks = owned_biks;
        this.checked_out_bike = checked_out_bike;
        this.checked_out_time = checked_out_time;
        this.suspended = suspended;
        this.access_token = access_token;
        this.refresh_token = refresh_token;
        this.signed_waiver = signed_waiver;
        this.state = state;
    }
}
exports.User = User;
//# sourceMappingURL=user.js.map