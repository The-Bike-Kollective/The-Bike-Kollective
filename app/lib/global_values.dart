String authCode =
    "ya29.a0ARrdaM9ER-RnZz0-OuGDNfolZysqlLWzM8T8TCh9Q0nicK-VjKvwkrWLWFYENaaWBl5agXyWCYnHOMVo9p78esen2BAtTOfD3Sra98O0jSfr0SpBJ_EkWZYI-45nxIyPkYzaAIOpyd8QzXHFgv4klggQm0Z9";

String userIdentifier = "106003633980667953838";

const String localUrlBrowser = "http://localhost:5000";

const String localUrlEmulator = "https://10.0.2.2:5000";

//this will hold the url to the cloud db.
const String cloudUrl1 =
    "http://ec2-35-164-203-209.us-west-2.compute.amazonaws.com:5000";

const String cloudUrl2 =
    "http://ec2-54-71-143-21.us-west-2.compute.amazonaws.com:5000";

const String cloudUrl3 =
    "http://ec2-35-166-192-222.us-west-2.compute.amazonaws.com:5000";

const String globalUrl = cloudUrl3;

//group API
const String googleAPIKey = "AIzaSyD-HlsqR99_XmX5NM0Cy-1nEsau-FSwkgk";
//Esther's test API
//const String googleAPIKey = "AIzaSyBenbjlXEuimwrotoKfNvbuOLn0bBuRTvc";

const String userAgreement =
    """These Terms of Service constitute a legally binding agreement 
(the “Agreement”) between you and The Bike Kollective, Inc., its parents, subsidiaries, representatives, 
affiliates, officers and directors (collectively, “The Bike Kollective,” “we,” “us” or “our”) governing your 
use of the The Bike Kollective application (the “The Bike Kollective App”), website, and technology platform 
(collectively, the “The Bike Kollective Platform”).

PLEASE BE ADVISED: THIS AGREEMENT CONTAINS PROVISIONS THAT GOVERN HOW CLAIMS BETWEEN YOU AND The Bike Kollective 
CAN BE BROUGHT (SEE SECTION 17 BELOW). THESE PROVISIONS WILL, WITH LIMITED EXCEPTION, REQUIRE YOU TO SUBMIT CLAIMS 
YOU HAVE AGAINST The Bike Kollective TO BINDING AND FINAL ARBITRATION ON AN INDIVIDUAL BASIS, NOT AS A PLAINTIFF OR CLASS 
MEMBER IN ANY CLASS, GROUP OR REPRESENTATIVE ACTION OR PROCEEDING. AS A DRIVER OR DRIVER APPLICANT, YOU HAVE AN OPPORTUNITY TO OPT OUT OF ARBITRATION WITH RESPECT TO CERTAIN CLAIMS AS PROVIDED IN SECTION 17.

By entering into this Agreement, and/or by using or accessing the The Bike Kollective Platform you expressly acknowledge 
that you understand this Agreement (including the dispute resolution and arbitration provisions in Section 17) and accept all 
of its terms. IF YOU DO NOT AGREE TO BE BOUND BY THE TERMS AND CONDITIONS OF THIS AGREEMENT, YOU MAY NOT USE OR ACCESS THE
 The Bike Kollective PLATFORM OR ANY OF THE SERVICES PROVIDED THROUGH THE The Bike Kollective PLATFORM. If you use the 
 The Bike Kollective Platform in another country, you agree to be subject to The Bike Kollective's terms of service for that country.

When using the The Bike Kollective Platform, you also agree to conduct yourself in accordance with our Community Guidelines, 
which shall form part of this Agreement between you and The Bike Kollective.

The Bike Kollective is a student project and is not meant to be used for public use. Any use outside of the 
scope of Oregon State University's CS 467 course is at the risk of the user. This app should only be accessed by 
those within Oregon State University and alumni, unless provided by David, Ali and Esther.""";

//global variable where front-end can access access toke
//for every post/get request to back-end

String? ACCESS_TOKEN;
String? CURRENT_USER_IDENTIFIER;
bool isLoggedIn = false;
String? CHECKED_OUT_BIKE;

void setCheckedOutBike(String bikeId) {
  CHECKED_OUT_BIKE = bikeId;
}

String? getCheckedOutBike() => CHECKED_OUT_BIKE;
bool isLoggedInGetter() => isLoggedIn;
void setLoginStatus(bool status) {
  isLoggedIn = status;
}

String? getAccessToken() => ACCESS_TOKEN;
void updateAccessToken(String? newToken) {
  ACCESS_TOKEN = newToken!;
}

String? getCurrentUserIdentifier() => CURRENT_USER_IDENTIFIER;
void updateCurrentUserIdentifier(newId) {
  CURRENT_USER_IDENTIFIER = newId;
}

String getGlobalUrl() => globalUrl;
