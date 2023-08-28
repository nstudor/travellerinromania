import 'dart:io';
import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ShowMapPage extends StatefulWidget {
  Function callback;
  ShowMapPage(this.callback);
  @override
  _ShowMapPage createState() => _ShowMapPage();
}

class _ShowMapPage extends State<ShowMapPage> {
  SharedPreferences? prefs;
  Timer? periodicTimer;

  final MapController mapController = MapController();
  double latF = 44;
  double longF = 26;

  void initState() {
    periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      print('This is timer');
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: LatLng(globals.gpsLatitude, globals.gpsLatitude),
            zoom: 17,
          ),
          nonRotatedChildren: [
            AttributionWidget.defaultWidget(
              source: 'OpenStreetMap contributors',
              onSourceTapped: null,
            ),
          ],
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(markers: [
              Marker(
                width: 30,
                height: 30,
                point: LatLng(globals.gpsLatitude, globals.gpsLatitude),
                builder: (ctx) => Text(
                  "😃",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ]),
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
