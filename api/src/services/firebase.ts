// Import the functions you need from the SDKs you need

import { initializeApp } from "firebase/app";
import { getStorage , ref , uploadBytes , getDownloadURL,uploadString} from "firebase/storage";

const fs = require("fs");
const path = require("path");

// load firebase Config
const firebaseConfigPath = path.join(__dirname, "../../firebaseConfig.json");
let firebaseConfig = JSON.parse(fs.readFileSync(firebaseConfigPath, "utf8"));

// Initialize Firebase
const firebaseApp = initializeApp(firebaseConfig);

// Get a reference to the storage service, which is used to create references in your storage bucket
const storage = getStorage(firebaseApp);


const uploadImage= async (file:any)=>{
    // create a random name for image
    const imageFile = "bike"+Date.now()+'.jpg'
    // create a refrence o the image
    const imageRef = ref(storage, imageFile);

    return new Promise (resolve =>{

        // upload image to refrence
        uploadBytes(imageRef, file).then((snapshot) => {
            console.log('Uploaded a blob or file!');
            
            // return download url
            getDownloadURL(imageRef)
            .then((url) => {
            console.log('download URL is: ');
            console.log(url);
            resolve(url)  
            })     
    })
})}


export {uploadImage}
