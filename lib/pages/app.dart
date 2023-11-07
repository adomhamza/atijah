import 'package:atijah/pages/map.dart';
// import 'package:atijah/pages/qibla.dart';

import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Map(),
    );
  }
}


// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// class Map extends StatefulWidget {
//   const Map({Key? key}) : super(key: key);

//   @override
//   State<Map> createState() => _MapState();
// }

// class _MapState extends State<Map> {
//   late bool _serviceEnabled;
//   late PermissionStatus _permissionGranted;
//   LocationData? _userLocation;
//   bool onPressed = true;
//   bool onDragged = false;

//   @override
//   void initState() {
//     super.initState();
//     _getUserLocation();
//   }

//   Future<void> _getUserLocation() async {
//     Location location = Location();

//     // Check if location service is enable
//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return;
//       }
//     }

//     // Check if permission is granted
//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }

//     final _locationData = await location.getLocation();
//     setState(() {
//       _userLocation = _locationData;
//     });
//   }

//   final Completer<GoogleMapController> _controller = Completer();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: _userLocation != null
//             ? Stack(
//                 children: [
//                   GoogleMap(
//                     myLocationButtonEnabled: false,
//                     zoomControlsEnabled: false,
//                     myLocationEnabled: true,
//                     onCameraMoveStarted: _c,
//                     initialCameraPosition: CameraPosition(
//                       target: LatLng(
//                         // 19.018255973653343,
//                         // 72.84793849278007
//                         _userLocation!.latitude!, _userLocation!.longitude!,
//                       ),
//                       zoom: 15.4746,
//                       tilt: 0,
//                       bearing: 0,
//                     ),
//                     onMapCreated: (GoogleMapController controller) {
//                       _controller.complete(controller);
//                     },
//                   ),
//                   Positioned(
//                       top: 100,
//                       child: Container(
//                           padding: const EdgeInsets.only(top: 15),
//                           child:
//                               const Text("Search", textAlign: TextAlign.center),
//                           width: 200,
//                           height: 50,
//                           color: Colors.blue)),
//                 ],
//               )
//             : const CircularProgressIndicator(),
//       ),
//       floatingActionButton: _userLocation != null
//           ? FloatingActionButton(
//               backgroundColor: Colors.white,
//               onPressed: () async {
//                 await _goToTheLake();
//                 setState(() {
//                   onPressed = true;
//                 });
//               },
//               child: onPressed
//                   ? const Icon(
//                       Icons.my_location,
//                       color: Colors.black,
//                     )
//                   : const Icon(
//                       Icons.location_searching,
//                       color: Colors.black,
//                     ),
//             )
//           : Container(),
//     );
//   }

//   Future<void> _goToTheLake() async {
//     setState(() {
//       onPressed = true;
//       onDragged = true;
//     });
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//       zoom: 15.4746,
//       tilt: 0,
//       bearing: 0,
//       target: LatLng(
//         _userLocation!.latitude!,
//         _userLocation!.longitude!,
//       ),
//     )));
//   }

//   void _c() {
//     if (onDragged) {
//       onPressed = true;
//       onDragged = false;
//     } else {
//       onPressed = false;
//     }
//     setState(() {});
//   }
// }
