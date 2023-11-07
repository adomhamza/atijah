import 'package:atijah/pages/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  runApp(const MyApp());
}
// https://maps.googleapis.com/maps/api/place/findplacefromtext/json
//   ?fields=formatted_address%2Cname%2Crating%2Copening_hours%2Cgeometry
//   &input=Mosque
//   &inputtype=textquery
//   &key=AIzaSyCisVfjXt6N2BZHq1zN1KoaZun7i-_Zkek

// https://maps.googleapis.com/maps/api/place/nearbysearch/json
//   ?keyword=mosque
//   &components=country:GHA|country:NGA|country:TGO
//   &type=mosque
//   &key=AIzaSyCisVfjXt6N2BZHq1zN1KoaZun7i-_Zkek

// https://maps.googleapis.com/maps/api/place/autocomplete/json
// ?input=Mosque
//   &components=country:GHA|country:NGA|country:TGO
//   &types=mosque
//   &key=AIzaSyCisVfjXt6N2BZHq1zN1KoaZun7i-_Zkek