library my_prj.globals;

import 'dart:async';
import 'dart:convert';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

double screensize = 10.0;
double gpsLatitude = 0.0;
double gpsLongitude = 0.0;
double gpsAccuracy = 0.0;

bool prefsLoaded = false;
String userId = "";
String userName = "";
String userMail = "";

String poiId = "";

String textInfo = "";

int gpsTime = DateTime.now().millisecondsSinceEpoch;

bool gpsChanged = false;
bool gpsLoaded = false;

MapController skMapController = MapController();
MapController skPoisController = MapController();
late StreamController<Position> positionStreamController =
    StreamController<Position>();

List<Marker> userMarker = [
  Marker(
    width: 30,
    height: 30,
    point: LatLng(gpsLatitude, gpsLongitude),
    builder: (ctx) => Icon(
      shadows: <Shadow>[Shadow(color: Colors.white, blurRadius: 15.0)],
      Icons.accessibility,
      size: 30,
      color: Colors.purpleAccent,
    ),
  )
];

dynamic postData(String endpoint, dynamic postdata) async {
  final response = await http.post(
      Uri.parse("https://monumente.eot.ro/" + endpoint + ".api"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: postdata);
  String data = '{"error":"Bad response from API"}';
  if (response.statusCode == 200) {
    data = response.body;
  }
  String postStr = json.encode(postdata);
  print("GOT API for " + endpoint + " : " + postStr + "\n" + data);
  return json.decode(data);
}

void showMessage(context, String x, Color cl) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      width: MediaQuery.of(context).size.width - 20,
      backgroundColor: cl,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      behavior: SnackBarBehavior.floating,
      content: Text(
        x,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
}
