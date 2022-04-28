import express, { Express, Request, Response } from "express";
import dotenv from "dotenv";
import {
  getAuthURL,
  get_tokens,
  getProfileInfo,
  printKeys,
} from "./services/google_auth";
import { connectDB, addUsertoDB } from "./db/db";
const userRoutes = require('./routes/userRoutes');
const bikeRoutes = require('./routes/bikeRoutes');


dotenv.config({ path: ".env" });

export const app: Express = express();
const port = process.env.PORT;

app.use(express.json({limit: '5mb'}));
app.use(express.urlencoded({limit: '5mb'}));

const bodyParser = require('body-parser')
app.use(bodyParser.json())



// @Debug
// TODO: clean in final release
connectDB();
printKeys();

const imageRoutes = require('./routes/imageRoutes');

app.use('/users',userRoutes)
app.use('/bikes',bikeRoutes)
app.use('/images',imageRoutes)



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

    const code = req.query.code;

    res.send({'auth_code':code})
    
});

app.listen(port, () => {
  console.log(`⚡️[server]: Server is running at https://localhost:${port}`);
});
