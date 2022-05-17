
interface INote{
    id:string,
    timestamp:number,
    note_body:string
}

interface IRating{
    id:string,
    timestamp:number,
    rating_value:number
}

interface ICheckOut{
    id:string,
    check_out_time:number
    check_in_time: number,
    damaged_on_return:boolean,
}

interface IBike {
    id?: string;
    date_added: number;
    image: string;
    active: boolean;
    condition: boolean;
    owner_id: string;
    lock_combination: number;
    notes: Array<INote>;
    rating: number;
    rating_history: Array<IRating>;
    location_long: number;
    location_lat:number;
    check_out_id:string;
    check_out_time:number;
    check_out_history:Array<ICheckOut>;
    name: string;
    type:string;
    size:string;
}


class Bike {
    id?: string;
    date_added: number;
    image: string;
    active: boolean;
    condition: boolean;
    owner_id: string;
    lock_combination: number;
    notes: Array<INote>;
    rating: number;
    rating_history: Array<IRating>;
    location_long: number;
    location_lat:number;
    check_out_id:string;
    check_out_time:number;
    check_out_history:Array<ICheckOut>;
    name: string;
    type:string;
    size:string;
    
    
  constructor(
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
    location_lat:number,
    check_out_id:string,
    check_out_time:number,
    check_out_history:Array<ICheckOut>,
    name: string,
    type: string,
    size: string,
    id?: string | undefined,
  ) {
      this.id = id;
      this.date_added = date_added;
      this.image= image;
      this.active=active;
      this.condition= condition;
      this.owner_id=owner_id;
      this.lock_combination= lock_combination;
      this.notes= notes;
      this.rating=rating;
      this.rating_history=rating_history;
      this.location_long=location_long;
      this.location_lat=location_lat;
      this.check_out_id=check_out_id;
      this.check_out_time=check_out_time;
      this.check_out_history=check_out_history;
      this.name=name;    
      this.type=type;
      this.size=size;  
  }
    
}


export {Bike, IBike, IRating, ICheckOut,INote}