import 'dart:ui';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:flutter_html/flutter_html.dart';

class poiPage extends StatefulWidget {
  Function callback;
  poiPage(this.callback);
  @override
  _poiPage createState() => _poiPage();
}

class _poiPage extends State<poiPage> {
  bool _poiLoaded = false;
  String _poiHtml = "";

  void initState() {
    loadPOI();
    super.initState();
  }

  loadPOI() async {
    print("Loading POI");
    dynamic upload = await globals.postData(
        "loadpoi", jsonEncode(<String, String?>{'code': globals.poiId}));
    POIPage html = POIPage.fromMap(upload);
    _poiHtml = html.html!;
    print("POI html " + _poiHtml);
    setState(() {
      _poiLoaded = true;
    });
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: _poiLoaded
            ? Html(data: _poiHtml)
            : Column(children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset('assets/logo.png', fit: BoxFit.fitWidth),
                ),
                Text("Loading...",
                    style: Theme.of(context).textTheme.headlineSmall)
              ]));
  }
}

class POIPage {
  final String? html;
  POIPage({this.html});
  factory POIPage.fromMap(Map<String, dynamic> map) {
    return POIPage(
      html: map['html'],
    );
  }
}
