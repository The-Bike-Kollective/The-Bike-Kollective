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
exports.db_name = exports.db_url = exports.app = void 0;
const express_1 = __importDefault(require("express"));
const dotenv_1 = __importDefault(require("dotenv"));
const google_auth_1 = require("./services/google_auth");
const db_1 = require("./db/db");
const userRoutes = require("./routes/userRoutes");
const bikeRoutes = require("./routes/bikeRoutes");
const imageRoutes = require("./routes/imageRoutes");
const userHelperFunctions_1 = require("./routes/userHelperFunctions");
dotenv_1.default.config({ path: ".env" });
exports.app = (0, express_1.default)();
const port = process.env.PORT;
exports.db_url = process.env.DB_URL;
exports.db_name = process.env.DB_NAME;
exports.app.use(express_1.default.json({ limit: "5mb" }));
exports.app.use(express_1.default.urlencoded({ limit: "5mb" }));
const bodyParser = require("body-parser");
exports.app.use(bodyParser.json());
const cors = require("cors");
exports.app.use(cors());
// @Debug
// TODO: clean in final release
(0, db_1.connectDB)();
(0, google_auth_1.printKeys)();
exports.app.use("/users", userRoutes);
exports.app.use("/bikes", bikeRoutes);
exports.app.use("/images", imageRoutes);
// information/instructions: for login redirect to google service
// @params: [Maybe] state
// @return: redirect url
// bugs: no known bugs
// TODO: decide on state and login design , might be changed based on frond end team design
// TODO : refactor into correct file
exports.app.get("/login", (req, res) => {
    // TODO: implement state and DB tasks
    res.redirect((0, google_auth_1.getAuthURL)());
});
// @Debug
// TODO: clean in final release
exports.app.get("/", (req, res) => {
    res.send("Express + TypeScript Server running! :)");
});
// @Debug
// information/instructions: call back url for google Oauth2 service. it provides Auth code for JWT inquiry
// @params: Auth Code as URL param
// @return: Auth code as json with "auth_code" key
// bugs: no known bugs
// TODO: decide on state and login design , might be changed based on frond end team design
// TODO : refactor into correct file
// TODO : Add DB calls
exports.app.get("/profile", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const code = req.query.code;
    const state = req.query.state;
    // call user registration
    (0, userHelperFunctions_1.userRegistration)(code, state)
        .then((code) => {
        // user exists or registred . deep link to loading page
        //belo line is for debug. no need to send the code in this call
        res.status(200).send({ auth_code: code, state: state });
    })
        .catch((err) => {
        // something went wrong. deep link to error page!
        res.status(400).send({ message: "somthing went wrong" });
    });
}));
exports.app.listen(port, () => {
    console.log(`⚡️[server]: Server is running at https://localhost:${port}`);
});
//# sourceMappingURL=index.js.map