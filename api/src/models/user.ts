interface IUser {
  id?: number;
  family_name: string;
  given_name: string;
  email: string;
  identifier: string;
  owned_biks: Array<number>;
  checked_out_bike: string;
  checked_out_time: number;
  suspended: boolean;
  access_token: string;
  refresh_token: string;
  signed_waiver: boolean;
  state:string;
}

class User {
    id?: number;
    family_name: string;
    given_name: string;
    email: string;
    identifier: string;
    owned_biks: Array<number>;
    checked_out_bike: string;
    checked_out_time: number;
    suspended: boolean;
    access_token: string;
    refresh_token: string;
    signed_waiver: boolean;
    state: string;
    
  constructor(
    family_name: string,
    given_name: string,
    email: string,
    identifier: string,
    owned_biks: Array<number>,
    checked_out_bike: string,
    checked_out_time: number,
    suspended: boolean,
    access_token: string,
    refresh_token: string,
    signed_waiver: boolean,
    state : string,
    id?: number | undefined,
  ) {
      this.id = id;
      this.family_name = family_name;
      this.given_name= given_name;
      this.email=email;
      this.identifier= identifier;
      this.owned_biks=owned_biks;
      this.checked_out_bike= checked_out_bike;
      this.checked_out_time= checked_out_time;
      this.suspended=suspended;
      this.access_token=access_token;
      this.refresh_token=refresh_token;
      this.signed_waiver=signed_waiver;
      this.state=state;
  }
    
}

export {IUser , User}
