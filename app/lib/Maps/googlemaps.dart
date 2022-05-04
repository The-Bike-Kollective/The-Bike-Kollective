import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:url_launcher_web/url_launcher_web.dart';
//import 'package:google_maps_flutter_web.dart';
import 'package:location/location.dart';
import 'dart:async';
//import 'dart:typed_data';
import 'package:the_bike_kollective/MenuDrawer.dart';


// information/instructions: user opens google maps and finds
// markers which display location of nearby bikes
// @params: no params
// @return: nothing returned
// bugs: no known bugs
// TODO:
// 1. obtain user location
// 2. obtain nearby bikes from back-end
// 3. when user clicks on bike, user can see info of bnike and route to it

class MapsView extends StatefulWidget {
  const MapsView({Key? key}) : super(key: key);

  @override
  _MapsView createState() => _MapsView();
}

class _MapsView extends State<MapsView> {
  LatLng _initialcameraposition = LatLng(40.738380, -73.988426);
  late GoogleMapController _googleMapController;
  Location _location = Location();
  late StreamSubscription _locationSubscription;
  late Marker markerr;
  late Circle circle;

  //List of bike locations
  List<Marker> markers = [];

  void _onMapCreated(GoogleMapController _cntlr) {
    _googleMapController = _cntlr;
    _location.onLocationChanged.listen((l) {
      _googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          //static location for testing purposes
          //goal is to obtain user's current location
          CameraPosition(target: LatLng(48.1418, 11.5795), zoom: 11.5),
          //CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
    });
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

//temporary marker data
  initialize() {
    Marker firstMarker = Marker(
      markerId: MarkerId('Munich International Airport'),
      position: LatLng(48.3510, 11.7764),
      infoWindow: InfoWindow(title: 'MUC'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    );
    Marker secondMarker = Marker(
      markerId: MarkerId('OlympiaPark'),
      position: LatLng(48.1755, 11.5518),
      infoWindow: InfoWindow(title: 'OlympiaPark'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    Marker thirdMarker = Marker(
      markerId: MarkerId('Marienplatz'),
      position: LatLng(48.1374, 11.5754),
      infoWindow: InfoWindow(title: 'Marienplatz'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    );
    Marker fourthMarker = Marker(
      markerId: MarkerId('Munich Central Station'),
      position: LatLng(48.1403, 11.5600),
      infoWindow: InfoWindow(title: 'Munich Central Station'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    );
    markers.add(firstMarker);
    markers.add(secondMarker);
    markers.add(thirdMarker);
    markers.add(fourthMarker);
    setState() {}
    ;
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

        ),
        //endDrawer: const MenuDrawer(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _initialcameraposition),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              markers: markers.map((e) => e).toSet(),
            ),
          ],
        ),
      ),
    );
  }
}
