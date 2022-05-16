import express from "express";
import { uploadImage } from "../services/firebase";

const router = express.Router();

// @Debug
// TODO: clean in final release
router.get("/", async (req, res) => {
  res.send("OK");
});

// information/instructions: upload recived Base64 encoded image on firestore and returns the download link
// @params: none . (base64 image in JSON body)
// @return: direct download link as string in JSON
// bugs: no known bugs
// TODO: error handling
router.post("/", async (req, res) => {
  const data = req.body.image;
  console.log("data is: ");
  // console.log(data)
  const buffer = Buffer.from(data, "base64");
  console.log(buffer);
  const downloadURL = await uploadImage(buffer);
  res.status(201).send({ url: downloadURL });
});

module.exports = router;
