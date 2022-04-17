import express, { Express, Request, Response } from "express";
import dotenv from "dotenv";
import { auth_url, get_tokens } from "./services/google_auth";

dotenv.config({ path: ".env" });

const app: Express = express();
const port = process.env.PORT;

app.get("/", (req: Request, res: Response) => {
  res.send("Express + TypeScript Server running! :)");
});

// information/instructions: for login redirect to google service
// @params: [Maybe] state
// @return: redirect url
// bugs: no known bugs
// TODO: decide on state and login design , might be changed based on frond end team design 
// TODO : refactor into correct file
app.get("/login", (req: Request, res: Response) => {
  // TODO: implement state and DB tasks
  res.redirect(auth_url);
});

// information/instructions: call back url for google Oauth2 service. it provides Auth code for JWT inquiry
// @params: [Maybe] state
// @return: redirect url
// bugs: no known bugs
// TODO: decide on state and login design , might be changed based on frond end team design 
// TODO : refactor into correct file
// TODO : Add DB calls
app.get("/profile", async (req: Request, res: Response) => {
  try {
    const code = req.query.code;
    const { tokens } = await get_tokens(code);
    console.log(tokens);
    res.send(tokens);
  } catch (e) {
    console.log(e);
    res.send(e);
  }
});

app.listen(port, () => {
  console.log(`⚡️[server]: Server is running at https://localhost:${port}`);
});
