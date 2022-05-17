"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const firebase_1 = require("../services/firebase");
const router = express_1.default.Router();
// @Debug
// TODO: clean in final release
router.get("/", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    res.send("OK");
}));
// information/instructions: upload recived Base64 encoded image on firestore and returns the download link
// @params: none . (base64 image in JSON body)
// @return: direct download link as string in JSON
// bugs: no known bugs
// TODO: error handling
router.post("/", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const data = req.body.image;
    console.log("data is: ");
    // console.log(data)
    const buffer = Buffer.from(data, "base64");
    console.log(buffer);
    const downloadURL = yield (0, firebase_1.uploadImage)(buffer);
    res.status(200).send({ url: downloadURL });
}));
module.exports = router;
//# sourceMappingURL=imageRoutes.js.map