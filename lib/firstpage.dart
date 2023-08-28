import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstPage extends StatefulWidget {
  Function callback;
  FirstPage(this.callback);
  @override
  _FirstPage createState() => _FirstPage();
}

class _FirstPage extends State<FirstPage> {
  void initState() {
    super.initState();
    initPrefs();
  }

  SharedPreferences? prefs;
  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Widget build(BuildContext context) {
    globals.gpsLoaded = true;
    print('FirstPage');

    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        getCard(Icons.view_list_rounded, 'Browse', 11),
        getCard(Icons.qr_code_2_outlined, 'Scan code', 12),
        getCard(Icons.map_outlined, 'Show map', 13),
        getCard(
            Icons.person_outlined,
            globals.userId == "" ? "Login" : "Profile",
            globals.userId == "" ? 4 : 14),
        getCard(Icons.add_a_photo_outlined, 'Add photo', 15),
        getCard(Icons.search_outlined, 'Search', 16),
      ],
    );
  }

  getCard(icn, txt, pg) {
    return Container(
//      height: 150,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: InkWell(
          onTap: () {
            print("object tapped");
            this.widget.callback(pg);
          },
          child: Align(
            child: ListTile(
              dense: false,
              title: Icon(
                icn,
                color: Colors.black,
                size: 64,
                semanticLabel: '-',
              ),
              subtitle: Text(
                txt,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
