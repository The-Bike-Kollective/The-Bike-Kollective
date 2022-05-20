import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:url_launcher_web/url_launcher_web.dart';
//import 'package:google_maps_flutter_web.dart';
import 'package:location/location.dart';
import 'dart:async';
//import 'dart:typed_data';
import 'package:the_bike_kollective/MenuDrawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:the_bike_kollective/Maps/directions_repository.dart';
import 'package:the_bike_kollective/Maps/directions_model.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart';
import 'package:location/location.dart';

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
  late Marker marker;
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





  
  // static const _initialCameraPosition = CameraPosition(
  //   target: LatLng(37.773972, -122.431297),
  //   zoom: 11.5,
  // );
  
  // //google map conroller variable
  // late GoogleMapController _googleMapController;
  // Marker? _origin;
  // Marker? _destination;
  // Directions? _info;

  // @override
  // void dispose() {
  //   _googleMapController.dispose();
  //   super.dispose();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       centerTitle: false,
  //       title: const Text('Google Maps'),
  //       actions: [
  //         if (_origin != null)
  //           TextButton(
  //             onPressed: () => _googleMapController.animateCamera(
  //               CameraUpdate.newCameraPosition(
  //                 CameraPosition(
  //                   target: _origin!.position,
  //                   zoom: 14.5,
  //                   tilt: 50.0,
  //                 ),
  //               ),
  //             ),
  //             style: TextButton.styleFrom(
  //               primary: Colors.green,
  //               textStyle: const TextStyle(fontWeight: FontWeight.w600),
  //             ),
  //             child: const Text('ORIGIN'),
  //           ),
  //         if (_destination != null)
  //           TextButton(
  //             onPressed: () => _googleMapController.animateCamera(
  //               CameraUpdate.newCameraPosition(
  //                 CameraPosition(
  //                   target: _destination!.position,
  //                   zoom: 14.5,
  //                   tilt: 50.0,
  //                 ),
  //               ),
  //             ),
  //             style: TextButton.styleFrom(
  //               primary: Colors.blue,
  //               textStyle: const TextStyle(fontWeight: FontWeight.w600),
  //             ),
  //             child: const Text('DEST'),
  //           )
  //       ],
  //     ),
  //     body: Stack(
  //       alignment: Alignment.center,
  //       children: [
  //         GoogleMap(
  //           myLocationButtonEnabled: false,
  //           zoomControlsEnabled: false,
  //           //seting to static initial camera position
  //           initialCameraPosition: _initialCameraPosition,
  //           onMapCreated: (controller) => _googleMapController = controller,
  //           //GoogleMap widget takes in a set of markers
  //           markers: {
  //             if (_origin != null) _origin,
  //             if (_destination != null) _destination
  //           },
  //           polylines: {
  //             if (_info != null)
  //               Polyline(
  //                 polylineId: const PolylineId('overview_polyline'),
  //                 color: Colors.red,
  //                 width: 5,
  //                 points: _info!.polylinePoints
  //                     .map((e) => LatLng(e.latitude, e.longitude))
  //                     .toList(),
  //               ),
  //           },
  //           //longpress gives latlong position (private method _addMarker
  //           onLongPress: _addMarker,
  //         ),
  //         if (_info != null)
  //           Positioned(
  //             top: 20.0,
  //             child: Container(
  //               padding: const EdgeInsets.symmetric(
  //                 vertical: 6.0,
  //                 horizontal: 12.0,
  //               ),
  //               decoration: BoxDecoration(
  //                 color: Colors.yellowAccent,
  //                 borderRadius: BorderRadius.circular(20.0),
  //                 boxShadow: const [
  //                   BoxShadow(
  //                     color: Colors.black26,
  //                     offset: Offset(0, 2),
  //                     blurRadius: 6.0,
  //                   )
  //                 ],
  //               ),
  //               child: Text(
  //                 '${_info!.totalDistance}, ${_info!.totalDuration}',
  //                 style: const TextStyle(
  //                   fontSize: 18.0,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //             ),
  //           ),
  //       ],
  //     ),
  //     //moves back to original camera position
  //     floatingActionButton: FloatingActionButton(
  //       backgroundColor: Theme.of(context).primaryColor,
  //       foregroundColor: Colors.black,
  //       onPressed: () => _googleMapController.animateCamera(
  //         _info != null
  //             ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
  //             : CameraUpdate.newCameraPosition(_initialCameraPosition),
  //       ),
  //       child: const Icon(Icons.center_focus_strong),
  //     ),
  //   );
  // }

  // void _addMarker(LatLng pos) async {
  //   // if Origin is not set OR Origin/Destination are both set
    
  //   if (_origin == null || (_origin != null && _destination != null)) {
  //     // Set origin
  //     setState(() {
  //       _origin = Marker(
  //         //every marker has a unique marker id
  //         markerId: const MarkerId('origin'),
  //         //display when user taps on marker
  //         infoWindow: const InfoWindow(title: 'Origin'),
  //         //icon is turned to green
  //         icon:
  //             BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
  //         //position is set to passed in lat/long values
  //         position: pos,
  //       );
        
  //       // Reset destination
  //       _destination = null;

  //       // Reset info
  //       _info = null;

  //     });
  //   } else {
  //     // Origin is already set
  //     // Set destination
  //     setState(() {
  //       _destination = Marker(
  //         markerId: const MarkerId('destination'),
  //         infoWindow: const InfoWindow(title: 'Destination'),
  //         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  //         position: pos,
  //       );
  //     });

  //     // Get directions
  //     final directions = await DirectionsRepository()
  //         .getDirections(origin: _origin!.position, destination: pos);
  //     setState(() => _info = directions);
  //   }
  // }



  

