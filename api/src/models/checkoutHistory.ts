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
            this.total_minutes=this.calculateMinutes(checkin_timestamp,checkout_timestamp),
            this.condition_on_return=condition_on_return,
            this.note=note,
            this.rating=rating,
            this.checkout_location=checkout_location,
            this.checkin_location=checkin_location
            this.id=id;
        }

    calculateMinutes=(start:number,end:number)=>{

        let elapsedTimeMS = end-start;   //miliseconds
        let elapsedTimeS=elapsedTimeMS/1000  //secconds
        let elapsedTimeM=Math.floor(elapsedTimeS/60)    // minutes

        console.log(`Minutes clac: ${end} - ${start} = ${elapsedTimeMS}(ms)\n/60 = ${elapsedTimeS} (s) \n/60 = ${elapsedTimeM} (min)`)

        return elapsedTimeM
    }
    
}


export {CheckoutHistory, ICheckoutHistory , ILocation}