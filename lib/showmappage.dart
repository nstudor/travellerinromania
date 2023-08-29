import 'dart:io';
import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

class ShowMapPage extends StatefulWidget {
  Function callback;
  ShowMapPage(this.callback);
  @override
  _ShowMapPage createState() => _ShowMapPage();
}

class _ShowMapPage extends State<ShowMapPage> {
  SharedPreferences? prefs;
  Timer? periodicTimer;

  Widget infoW = Text("");
  final MapController mapController = MapController();
  double latF = 0;
  double longF = 0;

  List<Marker> mrklist = [];

  void initState() {
    periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      num dist = sqrt(pow(globals.gpsLatitude - latF, 2) +
              pow(globals.gpsLongitude - longF, 2)) *
          50;

      if (dist > 1) {
        latF = globals.gpsLatitude;
        longF = globals.gpsLongitude;
        mapController.move(LatLng(latF, longF), 16);
        mrklist = [
          Marker(
            width: 30,
            height: 30,
            point: LatLng(globals.gpsLatitude, globals.gpsLongitude),
            builder: (ctx) => Text(
              "🧑",
              style: TextStyle(fontSize: 24),
            ),
          )
        ];
        List<POI> list = [];
        dynamic pointsAPI = await globals.postData(
            "points",
            jsonEncode(<String, String?>{
              'lat': latF.toString(),
              'lng': longF.toString()
            }));
        final convertedJsonObject = pointsAPI.cast<Map<String, dynamic>>();
        list =
            convertedJsonObject.map<POI>((json) => POI.fromJson(json)).toList();
        for (var p in list) {
          var marker = Marker(
            point: LatLng(p.lat, p.lng),
            width: 30.0,
            height: 30.0,
            builder: (ctx) => GestureDetector(
                onTap: () {
                  setState(() {
                    infoW = Container(
                      height: 100,
                      child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Column(children: [
                            ListTile(
                                leading: Text(
                                  p.icon,
                                  style: TextStyle(fontSize: 24),
                                ),
                                title: Html(data: p.denumire),
                                subtitle: Row(
                                  children: <Widget>[
                                    InkWell(
                                      child: Padding(
                                          padding: const EdgeInsets.all(
                                              5), //apply padding to all four sides
                                          child: Text("DETALII",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge)),
                                      onTap: () {
                                        globals.poiId = '#${p.id}';
                                        widget.callback(6);
                                      },
                                    ),
                                    InkWell(
                                      child: Padding(
                                          padding: const EdgeInsets.all(
                                              5), //apply padding to all four sides
                                          child: Text("DIRECTIONARE",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge)),
                                      onTap: () async {
                                        Uri googleUrl = Uri.parse(
                                            "google.navigation:q=${p.lat},${p.lng}mode=d");
                                        if (await canLaunchUrl(googleUrl)) {
                                          await launchUrl(googleUrl);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                trailing: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        infoW = Text("");
                                      });
                                    },
                                    child: Text(
                                      "❌",
                                      style: TextStyle(fontSize: 16),
                                    ))),
                          ])),
                    );
                  });
                },
                child: Text(
                  p.icon,
                  style: TextStyle(fontSize: 24),
                )),
          );
          mrklist.add(marker);
        }
      }
      setState(() {});
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
            center: LatLng(globals.gpsLatitude, globals.gpsLongitude),
            zoom: 16,
          ),
          nonRotatedChildren: [infoW],
          children: [
            TileLayer(
              urlTemplate:
                  'https://{s}.basemaps.cartocdn.com/rastertiles/voyager_labels_under/{z}/{x}/{y}{r}.png',
              userAgentPackageName: 'com.example.app',
              subdomains: ['a', 'b', 'c', 'd'],
            ),
            MarkerLayer(markers: mrklist),
          ],
        ));
  }

  @override
  void dispose() {
    periodicTimer!.cancel();
    mapController.dispose();
    super.dispose();
  }
}

class POI {
  String id;
  double lat;
  double lng;
  String link;
  String denumire;
  String public;
  String icon;

  POI(
      {required this.id,
      required this.lat,
      required this.lng,
      required this.link,
      required this.denumire,
      required this.public,
      required this.icon});
  factory POI.fromJson(Map<String, dynamic> json) {
    return POI(
        id: json["id"],
        lat: double.parse(json["lat"]),
        lng: double.parse(json["lng"]),
        link: json["link"],
        denumire: json["denumire"],
        public: json["public"],
        icon: json["icon"]);
  }
}
