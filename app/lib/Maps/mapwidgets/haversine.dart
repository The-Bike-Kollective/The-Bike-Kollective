//References: https://github.com/yeradis/haversine.dart/issues/3
import 'dart:math';

// information/instructions: utilizes haversine formula to obtain 
// the distance between two points on a map (adjusted to return miles)
// @params: lat/long for end and curent points
// @return: miles between two points on map
// bugs: none
// TODO: none
class GreatCircleDistance {
  final double R = 6371000; // radius of Earth, in meters
  double latitude1, longitude1;
  double latitude2, longitude2;

  GreatCircleDistance(
      {required this.latitude1,
      required this.latitude2,
      required this.longitude1,
      required this.longitude2});

  double distance() {
    double phi1 = this.latitude1 * pi / 180; // φ1
    double phi2 = this.latitude2 * pi / 180; // φ2
    var deltaPhi = (this.latitude2 - this.latitude1) * pi / 180; // Δφ
    var deltaLambda = (this.longitude2 - this.longitude1) * pi / 180; // Δλ

    var a = sin(deltaPhi / 2) * sin(deltaPhi / 2) +
        cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return (R * c) / 1609.344;
  }
}
