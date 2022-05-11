interface ILocation{
    long: number,
    lat: number
}

interface ICheckoutHistory{
    id?: string,
    user_identifier: string,
    bike_id: string,
    check_out_timestamp: number,
    check_in_timestamp: number,
    total_minutes: number,
    condition_on_return: boolean,
    note: string,
    rating: number,
    pickup_location: ILocation,
    return_location: ILocation
}

class CheckoutHistory{
    id?: string;
    user_identifier: string;
    bike_id: string;
    check_out_timestamp: number;
    check_in_timestamp: number;
    total_minutes: number;
    condition_on_return: boolean;
    note: string;
    rating: number;
    pickup_location: ILocation;
    return_location: ILocation;
    

    constructor(
        user_identifier: string,
        bike_id: string,
        check_out_timestamp: number,
        check_in_timestamp: number,
        total_minutes: number,
        condition_on_return: boolean,
        note: string,
        rating: number,
        pickup_location: ILocation,
        return_location: ILocation,
        id?: string | undefined,){
            this.user_identifier=user_identifier;
            this.bike_id=bike_id;
            this.check_out_timestamp=check_out_timestamp;
            this.check_in_timestamp=check_in_timestamp;
            this.total_minutes=this.calculateMinutes(check_in_timestamp,check_out_timestamp),
            this.condition_on_return=condition_on_return,
            this.note=note,
            this.rating=rating,
            this.pickup_location=pickup_location,
            this.return_location=return_location
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