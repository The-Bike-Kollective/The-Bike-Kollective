import express, { Express, Request, Response } from "express";
import dotenv from "dotenv";
import {
  getAuthURL,
  get_tokens,
  getProfileInfo,
  printKeys,
} from "./services/google_auth";
import { connectDB, addUsertoDB } from "./db/db";
const userRoutes = require("./routes/userRoutes");
const bikeRoutes = require("./routes/bikeRoutes");
const imageRoutes = require("./routes/imageRoutes");
const checkoutRecordsRoutes = require("./routes/checkoutRecords");
const reportRoutes = require("./routes/reportRoute");



import { userRegistration } from "./routes/userHelperFunctions";

dotenv.config({ path: ".env" });

export const app: Express = express();
const port = process.env.PORT;
export const db_url = process.env.DB_URL;
export const db_name = process.env.DB_NAME;

app.use(express.json({ limit: "5mb" }));
app.use(express.urlencoded({ limit: "5mb" }));

const bodyParser = require("body-parser");
app.use(bodyParser.json());

const cors = require("cors");
app.use(cors());

// @Debug
// TODO: clean in final release
connectDB();
printKeys();

app.use("/users", userRoutes);
app.use("/bikes", bikeRoutes);
app.use("/images", imageRoutes);
app.use("/records",checkoutRecordsRoutes);
app.use("/reports",reportRoutes);

// information/instructions: for login redirect to google service
// @params: [Maybe] state
// @return: redirect url
// bugs: no known bugs
// TODO: decide on state and login design , might be changed based on frond end team design
// TODO : refactor into correct file
app.get("/login", (req: Request, res: Response) => {
  // TODO: implement state and DB tasks
  res.redirect(getAuthURL());
});

// @Debug
// TODO: clean in final release
app.get("/", (req: Request, res: Response) => {
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
app.get("/profile", async (req: Request, res: Response) => {
  const code = req.query.code as string;
  const state = req.query.state as string;

  // call user registration

  userRegistration(code, state)
    .then((code) => {
      // user exists or registred . deep link to loading page
      //belo line is for debug. no need to send the code in this call

      // commnet below if using flutter app and uncomment the 2 lines after. leave as is if using POSTMAN
      // res.status(200).send({ auth_code: code, state: state });
      
      console.log({ auth_code: code, state: state });
      res.redirect('https://thebikekollective.page.link/Eit5')
    })
    .catch((err) => {
      // something went wrong. deep link to error page!
      res.status(400).send({ message: "somthing went wrong" });
    });
});

app.listen(port, () => {
  console.log(`⚡️[server]: Server is running at https://localhost:${port}`);
});
