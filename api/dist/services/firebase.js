"use strict";
// Import the functions you need from the SDKs you need
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.uploadImage = void 0;
const app_1 = require("firebase/app");
const storage_1 = require("firebase/storage");
const fs = require("fs");
const path = require("path");
// load firebase Config
const firebaseConfigPath = path.join(__dirname, "../../firebaseConfig.json");
let firebaseConfig = JSON.parse(fs.readFileSync(firebaseConfigPath, "utf8"));
// Initialize Firebase
const firebaseApp = (0, app_1.initializeApp)(firebaseConfig);
// Get a reference to the storage service, which is used to create references in your storage bucket
const storage = (0, storage_1.getStorage)(firebaseApp);
const uploadImage = (file) => __awaiter(void 0, void 0, void 0, function* () {
    // create a random name for image
    const imageFile = "bike" + Date.now() + '.jpg';
    // create a refrence o the image
    const imageRef = (0, storage_1.ref)(storage, imageFile);
    return new Promise(resolve => {
        // upload image to refrence
        (0, storage_1.uploadBytes)(imageRef, file).then((snapshot) => {
            console.log('Uploaded a blob or file!');
            // return download url
            (0, storage_1.getDownloadURL)(imageRef)
                .then((url) => {
                console.log('download URL is: ');
                console.log(url);
                resolve(url);
            });
        });
    });
});
exports.uploadImage = uploadImage;
//# sourceMappingURL=firebase.js.map