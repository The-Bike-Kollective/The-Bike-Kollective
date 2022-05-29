import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:the_bike_kollective/Maps/directions_model.dart';
import 'package:the_bike_kollective/Maps/directions_repository.dart';
import 'package:the_bike_kollective/Maps/mapwidgets/haversine.dart';
import 'package:the_bike_kollective/models.dart';

late Bike? bike;
Position? _currentPosition;

// information/instructions: user clicks "Route to Bike"
// from bike details page and the route is started to just that marker. 
// Once user reaches bike, user can begin check-out
// @params: Bike object
// @return: none
// bugs: none
// TODO: none
// 1. Connect user profile page w/ lock code
class MapsViewFromList extends StatefulWidget {
  Bike destinationBike;
  MapsViewFromList({Key? key, required this.destinationBike}) : super(key: key);

  @override
  _MapsViewFromList createState() => _MapsViewFromList(destinationBike);
}

class _MapsViewFromList extends State<MapsViewFromList> {
  Bike destinationBike;
  _MapsViewFromList(this.destinationBike);

  LatLng _initialcameraposition = LatLng(40.738380, -73.988426);
  late GoogleMapController _googleMapController;
  LatLng? _endLocation = null;
  LatLng? _userLocation = null;
  Directions? _info = null;
  late Marker _marker;

  @override
  void initState() {
    setMarker();
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Bike Kollective'),
        actions: [
          if (_info != null)
            TextButton(
              onPressed: () => _showNearBikeDialog(),
              style: TextButton.styleFrom(
                primary: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('Go Near Bike'),
            ),
          if (_info != null)
            TextButton(
              onPressed: () => _showDestinationDialog(),
              style: TextButton.styleFrom(
                primary: Colors.white,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('Go to Bike'),
            ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _initialcameraposition),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              markers: {_marker},
              polylines: {
                if (_info != null)
                  Polyline(
                    polylineId: const PolylineId('overview_polyline'),
                    color: Colors.red,
                    width: 5,
                    points: _info!.polylinePoints
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                  ),
              },
            ),
            if (_info != null)
              Positioned(
                top: 20.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      )
                    ],
                  ),
                  child: Text(
                    '${_info?.totalDistance}, ${_info?.totalDuration}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
// information/instructions: instantiates google map cntlr 
// and calls functions to set marker on map
// @params: Google Map Controller 
// @return: nothing returned
// bugs: none
// TODO: none
  void _onMapCreated(GoogleMapController _cntlr) {
    _googleMapController = _cntlr;
    setMarker();
    _getCurrentLocation();
  }

// information/instructions: sets bike information to marker
// @params: none
// @return: none
// bugs: none
// TODO: none
  void setMarker() async {
    setState(() {
      _marker = Marker(
          markerId: MarkerId(destinationBike.name),
          position: LatLng(destinationBike.locationLong.toDouble(),
              destinationBike.locationLat.toDouble()),
          infoWindow: InfoWindow(
            title: destinationBike.name,
            onTap: () {},
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          onTap: () {});
    });
  }

// information/instructions: get's the mobile device's current location and adjusts camera position accordingly
// requires user's permission to provide location to app
// @params: none
// @return: none
// bugs: none
// TODO: none
  _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });

    _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 13),
      ),
    );
    _getDirection();
  }

// information/instructions: calls google direction api to 
//obtain location and time (walking) from two points
// @params: one bike
// @return: none
// bugs: none
// TODO: none
  void _getDirection() async {
    if (_currentPosition == null) {
      return Future.error('Current Location not found');
    }

    setState(() {
      _userLocation =
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    });

    final directions = await DirectionsRepository()
        .getDirections(origin: _userLocation, destination: _marker.position);

    setState(() => _info = directions);
  }

// information/instructions: when user arrives near the bike
// the user is presented option to check-out bike
// @params: one bike
// @return: none
// bugs: none
// TODO: none
  void _showDestinationDialog() async {
    LatLng _finalLocation = _marker.position;

    _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _finalLocation, zoom: 14.5, tilt: 50.0),
      ),
    );
    // information/instructions: bike details are displayed in modal bottom
    // provides user option to check-out bike
    final result = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("You have arrived at the bike."),
              ElevatedButton(
                onPressed: () {
                  //To DO: OPEN BIKE Check-out
                  Get.back();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue, elevation: 0),
                child: const Text("Proceed to Bike Check-out"),
              ),
              ElevatedButton(
                onPressed: () {
                  //To DO: OPEN BIKE Check-out
                  Get.back();
                  Get.back();
                },
                style:
                    ElevatedButton.styleFrom(primary: Colors.red, elevation: 0),
                child: const Text("Report Bike Missing"),
              ),
              const Text(
                  "Bike will be reported missing to The Bike Kollective."),
              const Text(
                  "You will be redirected to the bike page to find a new bike."),
            ],
          ),
        );
      },
    );
  }

// information/instructions: revised modal bottom to show 
// if bike is not within vicinity to meet check-in criteria 
// utilizes Haversine formula to obtain distnace between two points
// @params: none
// @return: none
// bugs: none
// TODO: none
  void _showNearBikeDialog() async {
    num distance;
    LatLng _finalLocation = LatLng(destinationBike.locationLong.toDouble(),
        destinationBike.locationLat.toDouble());

    _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _finalLocation, zoom: 14.5, tilt: 50.0),
      ),
    );

    distance = GreatCircleDistance(
            latitude1: _userLocation!.latitude,
            longitude1: _userLocation!.longitude,
            latitude2: _finalLocation.latitude,
            longitude2: _finalLocation.longitude)
        .distance();

    print("DISTANCE");
    print(distance);

     //if distance is greater than 0.5m, does not meet criteria for check-out and
    // shows modal bottom to continue routing to bike
    if (distance > 0.5) {
      final result = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (_) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                    "You are still more than 0.5 miles away from the bike."),
                const Text(
                    "Please move closer to the bike to begin bike check-out."),
                //BIKE IS SEEN
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue, elevation: 0),
                  child: const Text("Return to Route"),
                ),
              ],
            ),
          );
        },
      );
    //if distance is less than 0.5m, meets criteria for check-out and
   // shows modal bottom to proceed to bike check-out
    } else {
      final result = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (_) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("You have arrived at the bike."),
                //BIKE IS SEEN
                ElevatedButton(
                  onPressed: () {
                    //To DO: IMPLEMENT REDIRECT TO PROFILE PAGE W/BIKE INFO + LOCK COMBO
                    Get.back();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue, elevation: 0),
                  child: const Text("Proceed to Bike Check-out"),
                ),
                //BIKE IS MISSING
                ElevatedButton(
                  onPressed: () {
                    //To DO: SEND REQUET TO BACK_END TO MARK BIKE AS MISSING
                    Get.back();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.red, elevation: 0),
                  child: const Text("Report Bike Missing"),
                ),
                const Text(
                    "Bike will be reported missing to The Bike Kollective."),
                const Text(
                    "You will be redirected to the bike page to find a new bike."),
              ],
            ),
          );
        },
      );
    }
  }
}
