import 'package:the_bike_kollective/home_view.dart';
import 'package:flutter/material.dart';
import 'package:the_bike_kollective/profile_view.dart';
import 'package:the_bike_kollective/models.dart';
import 'package:the_bike_kollective/Login/spash_screen.dart';
import 'package:the_bike_kollective/access_token.dart';
import 'package:the_bike_kollective/access_token.dart';

// information/instructions: user reads and either
// 1. accepts agreement > redirected to logged in home page
// 2. declines agreement > redirected to landing page
// @params: no params
// @return: nothing returned
// bugs: no known bugs
// TODO:
//  1. write terms and conditions
//  2. redirect user to home page if declines (inform user w/pop-up)
//  3. redirect user to user page if accepts (implement user info)
//  4. clean-up code and separate into different widgets
//  5. send signedWaiver = true to update back-end if accepts signs waiver
const String pdfText = """MEMBERSHIP RULES
Lorem ipsum dolor sit amet. Sed repudiandae voluptas et consequatur perspiciatis 
cum quia corrupti aut illum iusto cum voluptatem maxime. Est numquam maxime est culpa 
reiciendis et odit eaque et sapiente blanditiis ad voluptas omnis. Ut quod atque 
id illo atque et nihil eligendi in eius sint et quisquam explicabo sed nobis enim. 
Et assumenda vitae nam dignissimos incidunt quo dolores maiores. Et eveniet nemo est 
amet blanditiis qui voluptates fugit qui galisum quam eum velit iusto! Aut earum magni 
hic commodi cumque sed aliquid modi sed dolorem incidunt et internos provident est 
perspiciatis provident. In fugiat provident est voluptates quasi aut provident 
molestiae? Aut alias iste est quis nostrum aut laborum iusto qui reiciendis 
libero. Et dicta esse ea repellendus officiis id excepturi temporibus in 
deserunt ducimus. Id delectus omnis aut atque sapiente ea eius corrupti.""";

class AgreementPage extends StatefulWidget {
  //const AgreementPage({Key? key}) : super(key: key);

  @override
  _AgreementPage createState() => _AgreementPage();
}

class _AgreementPage extends State<AgreementPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();

  // This function is triggered when the button is clicked
  //saving for future
  void _doSomething() {
    // Do something
  }
  

  @override
  Widget build(BuildContext context) {
    print("Test: access token via global variable below ");
    print(accessToken01);
    
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  margin:
                      const EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).hintColor.withOpacity(0.2),
                            offset: const Offset(0, 10),
                            blurRadius: 20)
                      ]),

                  //FORM
                  child: Form(
                    key: globalFormKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          "User Agreement",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        // ignore: prefer_const_constructors

                        SizedBox(
                          height: 20,
                        ),
                        //ignore: unnecessary_new
                        Container(
                            height: 150,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Center(
                                  child: Text(
                                    pdfText,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ))),

                        SizedBox(
                          height: 20,
                        ),

                        Container(
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeView()),
                              );
                              debugPrint('Cancel clicked');
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[Text('Cancel')],
                            ),
                          ),
                        ),
                        Container(
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileView(),),
                              );
                              debugPrint('Agree clicked');
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[Text('Agree')],
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
