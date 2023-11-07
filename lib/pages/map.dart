import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);
  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? _userLocation;
  bool onPressed = true;
  bool onDragged = false;
  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? destinationIcon;
  final Set<Marker> _markers = <Marker>{};
  final Set<Polyline> _polylines = <Polyline>{};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = 'AIzaSyCisVfjXt6N2BZHq1zN1KoaZun7i-_Zkek';
  double longitude1 = 5.5435012;
  double latitude1 = -0.3232041;
  double longitude2 = 5.6256966;
  double latitude2 = -0.3504172;
  double latitude3 = 5.5470796;
  double longitude3 = -0.3399502;
  @override
  void initState() {
    super.initState();
    _getUserLocation();
    setSourceAndDestinationIcons();
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5),
      'assets/mosque_marker_bright.png',
    );

    destinationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5),
      'assets/mosque_marker.png',
    );
  }

  Future<void> _getUserLocation() async {
    Location location = Location();
    polylinePoints = PolylinePoints();

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final _locationData = await location.getLocation();
    setState(() {
      _userLocation = _locationData;
    });
    location.onLocationChanged.listen((LocationData cLoc) {
      _userLocation = cLoc;
      updatePinOnMap();
    });
  }

  void showPinsOnMap() {
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    var pinPosition =
        LatLng(_userLocation!.latitude!, _userLocation!.longitude!);
    // get a LatLng out of the LocationData object
    var destPosition = LatLng(latitude3, longitude3);
    // add the initial source location pin
    _markers.add(
      Marker(
          markerId: const MarkerId('sourcePin'),
          position: pinPosition,
          icon: sourceIcon!),
    );
    // destination pin
    _markers.add(
      Marker(
          markerId: const MarkerId('destPin'),
          position: destPosition,
          icon: destinationIcon!),
    );

    setPolylines();
  }

  void setPolylines() async {
    PointLatLng origin =
        PointLatLng(_userLocation!.latitude!, _userLocation!.longitude!);
    PointLatLng dest = PointLatLng(latitude3, longitude3);
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      origin,
      dest,
      //travelMode: TravelMode.walking,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        _polylines.add(Polyline(
            width: 5, // set the width of the polylines
            polylineId: const PolylineId('poly'),
            color: const Color(0xffFFD700),
            points: polylineCoordinates));
      });
    }
  }

  final Completer<GoogleMapController> _controller = Completer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _userLocation != null
            ? Stack(
                children: [
                  GoogleMap(
                    myLocationButtonEnabled: false,
                    markers: _markers,
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    onCameraMoveStarted: _dragMap,
                    polylines: _polylines,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _userLocation!.latitude!,
                        _userLocation!.longitude!,
                      ),
                      zoom: 15.4746,
                      tilt: 0,
                      bearing: 0,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      showPinsOnMap();
                      //updatePinOnMap();
                    },
                  ),
                  Positioned(
                    top: 50,
                    right: 15,
                    left: 15,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xffFFD700)),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: const ImageIcon(
                              AssetImage('assets/mosque_marker.png'),
                              color: Color(0xffFFD700),
                            ),
                            //Icon(Icons.menu),
                            onPressed: () {},
                          ),
                          const Expanded(
                            child: TextField(
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.go,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15),
                                hintText: "Search...",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator(
                color: Color(0xffFFD700),
              ),
      ),
      floatingActionButton: _userLocation != null
          ? FloatingActionButton(
              backgroundColor: const Color(0xffFFD700),
              onPressed: _goToCurrentLocation,
              child: onPressed
                  ? const Icon(
                      Icons.my_location,
                      color: Color(0xffFFFFFF),
                    )
                  : const Icon(
                      Icons.location_searching,
                      color: Color(0xffFFFFFF),
                    ),
            )
          : Container(),
    );
  }

  Future<void> _goToCurrentLocation() async {
    setState(() {
      onDragged = true;
    });
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      zoom: 15.4746,
      tilt: 0,
      bearing: 0,
      target: LatLng(
        _userLocation!.latitude!,
        _userLocation!.longitude!,
      ),
    )));
  }

  void _dragMap() {
    if (onDragged) {
      onPressed = true;
      onDragged = false;
    } else {
      onPressed = false;
    }
    setState(() {});
  }

  void updatePinOnMap() async {
    setState(() {
      // updated position
      var pinPosition =
          LatLng(_userLocation!.latitude!, _userLocation!.longitude!);

      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(
        Marker(
          markerId: const MarkerId('sourcePin'),
          position: pinPosition, // updated position
          icon: sourceIcon!,
        ),
      );
    });
  }
}
