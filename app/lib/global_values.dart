

String authCode = "ya29.a0ARrdaM9ER-RnZz0-OuGDNfolZysqlLWzM8T8TCh9Q0nicK-VjKvwkrWLWFYENaaWBl5agXyWCYnHOMVo9p78esen2BAtTOfD3Sra98O0jSfr0SpBJ_EkWZYI-45nxIyPkYzaAIOpyd8QzXHFgv4klggQm0Z9";

String userIdentifier = "106003633980667953838";

const String localUrlBrowser = "http://localhost:5000";

const String localUrlEmulator = "https://10.0.2.2:5000";

//this will hold the url to the cloud db. 
const String cloudUrl1 = "http://ec2-35-164-203-209.us-west-2.compute.amazonaws.com:5000";

const String cloudUrl2 = "http://ec2-54-71-143-21.us-west-2.compute.amazonaws.com:5000";

const String cloudUrl3 = "http://ec2-35-166-192-222.us-west-2.compute.amazonaws.com:5000";

const String globalUrl = cloudUrl3;


//global variable where front-end can access access toke
//for every post/get request to back-end

String? ACCESS_TOKEN;
String? CURRENT_USER_IDENTIFIER;
int? CHECKED_OUT_BIKE_COMBO;

//bool isLoggedIn = false;
//String? CHECKED_OUT_BIKE;

//void setCheckedOutBike(String bikeId) {CHECKED_OUT_BIKE = bikeId;}
//String? getCheckedOutBike() => CHECKED_OUT_BIKE;
//bool isLoggedInGetter() => isLoggedIn;
//void setLoginStatus(bool status) {isLoggedIn = status;} 
int? getCheckedOutBikeCombo() => CHECKED_OUT_BIKE_COMBO;
void setCheckedOutBikeCombo(int newCombo) { CHECKED_OUT_BIKE_COMBO = newCombo;}
String? getAccessToken() => ACCESS_TOKEN;
void updateAccessToken(String? newToken) {ACCESS_TOKEN = newToken!;}
String? getCurrentUserIdentifier() => CURRENT_USER_IDENTIFIER;
void updateCurrentUserIdentifier(newId) {CURRENT_USER_IDENTIFIER= newId;}
String getGlobalUrl() => globalUrl;

