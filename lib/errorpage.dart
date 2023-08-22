import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ErrorPage extends StatefulWidget {
  Function callback;
  ErrorPage(this.callback);
  @override
  _ErrorPage createState() => _ErrorPage();
}

class _ErrorPage extends State<ErrorPage> {
  void initState() {
    super.initState();
    initPrefs();
  }

  SharedPreferences? prefs;
  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Widget build(BuildContext context) {
    return Container(
        child: Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Align(
        child: ListTile(
          dense: false,
          title: Icon(
            Icons.error_outline_outlined,
            color: Colors.red,
            size: 64,
            semanticLabel: '-',
            shadows: [
              Shadow(
                  color: Colors.redAccent,
                  blurRadius: 15.0,
                  offset: Offset(2.0, 2.0))
            ],
          ),
          subtitle: Text(
            "Error: \nNot implemented !",
            style: TextStyle(fontSize: 32),
            textAlign: TextAlign.center,
          ),
        ),
        alignment: Alignment.center,
      ),
    ));
  }
}
