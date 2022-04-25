import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// information/instructions: this function is called whenver
//the user clicks the "Sign in With Google" button. THis is
//linked to the Google auth link
// @params: no params
// @return: nothing returned
// bugs: no known bugs
// TODO:
// 1. Remove email and pw (only using google login for now)
_launchURLInApp() async {
  const url =
      'https://accounts.google.com/o/oauth2/v2/auth/oauthchooseaccount?access_type=offline&prompt=consent&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email&include_granted_scopes=true&response_type=code&client_id=701199836944-k9grqhb7tl30mm974iv62k6ge3ha2cqs.apps.googleusercontent.com&redirect_uri=http%3A%2F%2F127.0.0.1%3A5000%2Fprofile&flowName=GeneralOAuthFlow';

  if (await canLaunch(url)) {
    await launch(url, forceSafariVC: true, forceWebView: true);
  } else {
    throw 'Could not launch $url';
  }
}


// information/instructions: create account widget
// @params: no params
// @return: nothing returned
// bugs: no known bugs
// TODO:
// 1. Remove email and pw (only using google login for now)
class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).hintColor.withOpacity(0.2),
                            offset: Offset(0, 10),
                            blurRadius: 20)
                      ]),
                  //FORM
                  child: Form(
                    key: globalFormKey,
                    child: Column(
                      children: <Widget>[
                        // ignore: prefer_const_constructors
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          "Create Account",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        // ignore: prefer_const_constructors

                        SizedBox(
                          height: 20,
                        ),
                        //ignore: unnecessary_new

                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          //onSaved:
                          validator: (input) => input!.contains("@")
                              ? "Email Id should be Valid"
                              : null,
                          decoration: new InputDecoration(
                              hintText: "Email Address",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.2),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              prefixIcon: Icon(Icons.email,
                                  color: Theme.of(context).accentColor)),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        TextFormField(
                            keyboardType: TextInputType.text,
                            //onSaved:
                            validator: (input) => input!.length < 3
                                ? "Password should be more than 3 characters"
                                : null,
                            decoration: new InputDecoration(
                              hintText: "Password",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.2),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              prefixIcon: Icon(Icons.email,
                                  color: Theme.of(context).accentColor),
                              suffixIcon: IconButton(
                                  onPressed: () {},
                                  color: Theme.of(context)
                                      .accentColor
                                      .withOpacity(0.4),
                                  icon: Icon(Icons.visibility_off)),
                            )),

                        SizedBox(
                          height: 20,
                        ),

                        new Container(
                          child: new RaisedButton(
                            onPressed: _launchURLInApp,
                            child: new Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Image.asset(
                                  'btn_google_signin_light_focus_web@2x.png',
                                  height: 48.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
