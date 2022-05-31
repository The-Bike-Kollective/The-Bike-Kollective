import 'dart:math';

List<num> generateCoordinates() {
  double latMax = 44.567607;
  double latMin = 44.557131;
  double longMax = -123.284569;
  double longMin = -123.260601;

  double lat = Random().nextDouble() * (latMax - latMin) + latMin;
  double long = Random().nextDouble() * (longMax - longMin) + longMin;

  List<double> coordinates = [lat, long];

  return coordinates;
}



