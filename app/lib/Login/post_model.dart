class Customer {
  String? id;
  String? familyName;
  String? givenName;
  String? email;
  String? identifier;
  //List<dynamic>? ownedBikes;
  String? checkedOutBike;
  int? checkedOutTime;
  bool? suspended;
  String? accessToken;
  String? refreshToken;
  bool? signedWaiver;
  String? state;
  //List<dynamic>? checkoutHistory;
  String? checkoutRecordId;

  Customer({
    required this.id,
    required this.familyName,
    required this.givenName,
    required this.email,
    required this.identifier,
    //required this.ownedBikes,
    required this.checkedOutBike,
    required this.checkedOutTime,
    required this.suspended,
    required this.accessToken,
    required this.refreshToken,
    required this.signedWaiver,
    required this.state,
    //required this.checkoutHistory,
    required this.checkoutRecordId,
  });

  factory Customer.fromJson(Map<String, dynamic> parsedJson) {
    return Customer(
      id: parsedJson["id"],
      familyName: parsedJson["family_name"],
      givenName: parsedJson["given_name"],
      email: parsedJson["email"],
      identifier: parsedJson["identifier"],
      //ownedBikes: List<dynamic>.from(parsedJson["owned_bikes"].map((x) => x)),
      checkedOutBike: parsedJson["checked_out_bike"],
      checkedOutTime: parsedJson["checked_out_time"],
      suspended: parsedJson["suspended"],
      accessToken: parsedJson["access_token"],
      refreshToken: parsedJson["refresh_token"],
      signedWaiver: parsedJson["signed_waiver"],
      state: parsedJson["state"],
      //checkoutHistory:
      //    List<dynamic>.from(parsedJson["checkout_history"].map((x) => x)),
      checkoutRecordId: parsedJson["checkout_record_id"],
    );
  }
} 