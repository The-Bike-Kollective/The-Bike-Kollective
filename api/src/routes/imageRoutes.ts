import express from "express";
import {uploadImage} from '../services/firebase'

const router = express.Router();

router.get("/", async (req, res) => {
  
    res.send("OK");
  });


router.post("/" , async (req, res) => {

    const data = req.body.image
    console.log("data is: ")
    // console.log(data)
    const buffer = Buffer.from(data, "base64");
    console.log(buffer)
    const downloadURL = await uploadImage(buffer)
    res.send(downloadURL)
});



module.exports = router;


