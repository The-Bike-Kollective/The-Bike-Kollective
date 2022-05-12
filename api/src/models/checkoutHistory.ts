interface ILocation{
    long: number,
    lat: number
}

interface ICheckoutHistory{
    id?: string,
    user_identifier: string,
    bike_id: string,
    checkout_timestamp: number,
    checkin_timestamp: number,
    total_minutes: number,
    condition_on_return: boolean,
    note: string,
    rating: number,
    checkout_location: ILocation,
    checkin_location: ILocation
}

class CheckoutHistory{
    id?: string;
    user_identifier: string;
    bike_id: string;
    checkout_timestamp: number;
    checkin_timestamp: number;
    total_minutes: number;
    condition_on_return: boolean;
    note: string;
    rating: number;
    checkout_location: ILocation;
    checkin_location: ILocation;
    

    constructor(
        user_identifier: string,
        bike_id: string,
        checkout_timestamp: number,
        checkin_timestamp: number,
        total_minutes: number,
        condition_on_return: boolean,
        note: string,
        rating: number,
        checkout_location: ILocation,
        checkin_location: ILocation,
        id?: string | undefined,){
            this.user_identifier=user_identifier;
            this.bike_id=bike_id;
            this.checkout_timestamp=checkout_timestamp;
            this.checkin_timestamp=checkin_timestamp;
            this.total_minutes=total_minutes,
            this.condition_on_return=condition_on_return,
            this.note=note,
            this.rating=rating,
            this.checkout_location=checkout_location,
            this.checkin_location=checkin_location
            this.id=id;
        }

    calculateMinutes=()=>{

        let elapsedTimeMS = Math.abs(this.checkin_timestamp - this.checkout_timestamp);   //miliseconds
        let elapsedTimeS=elapsedTimeMS/1000  //secconds
        let elapsedTimeM=Math.floor(elapsedTimeS/60)    // minutes

        console.log(`Minutes clac: ${this.checkin_timestamp} - ${this.checkout_timestamp} = ${elapsedTimeMS}(ms)\n/60 = ${elapsedTimeS} (s) \n/60 = ${elapsedTimeM} (min)`)

        this.total_minutes = elapsedTimeM
    };

    checkInUpdate=(checkin_timestamp:number, checkin_location:ILocation,note:string, rating:number, condition_on_return:boolean)=>{
        this.checkin_timestamp=checkin_timestamp;
        this.checkin_location=checkin_location;
        this.note=note;
        this.rating=rating;
        this.condition_on_return=condition_on_return;
    }
       
}


export {CheckoutHistory, ICheckoutHistory , ILocation}