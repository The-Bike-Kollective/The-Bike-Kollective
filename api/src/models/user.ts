interface IUser {
  id?: number;
  family_name: string;
  given_name: string;
  email: string;
  identifier: string;
  owned_bikes: Array<string>;
  checked_out_bike: string;
  checked_out_time: number;
  suspended: boolean;
  access_token: string;
  refresh_token: string;
  signed_waiver: boolean;
  state:string;
  checkout_history:Array<string>;
  checkout_record_id: string;
}

class User {
    id?: number;
    family_name: string;
    given_name: string;
    email: string;
    identifier: string;
    owned_bikes: Array<string>;
    checked_out_bike: string;
    checked_out_time: number;
    suspended: boolean;
    access_token: string;
    refresh_token: string;
    signed_waiver: boolean;
    state: string;
    checkout_history:Array<string>;
    checkout_record_id: string;
    
  constructor(
    family_name: string,
    given_name: string,
    email: string,
    identifier: string,
    owned_bikes: Array<string>,
    checked_out_bike: string,
    checked_out_time: number,
    checkout_record_id: string,
    suspended: boolean,
    access_token: string,
    refresh_token: string,
    signed_waiver: boolean,
    state : string,
    checkout_history:Array<string>,
    id?: number | undefined,
  ) {
      this.id = id;
      this.family_name = family_name;
      this.given_name= given_name;
      this.email=email;
      this.identifier= identifier;
      this.owned_bikes=owned_bikes;
      this.checked_out_bike= checked_out_bike;
      this.checked_out_time= checked_out_time;
      this.suspended=suspended;
      this.access_token=access_token;
      this.refresh_token=refresh_token;
      this.signed_waiver=signed_waiver;
      this.state=state;
      this.checkout_history=checkout_history;
      this.checkout_record_id=checkout_record_id;
  }
    
}

export {IUser , User}
