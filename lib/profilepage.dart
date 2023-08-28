import 'dart:io';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  Function callback;
  ProfilePage(this.callback);
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  SharedPreferences? prefs;
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          globals.userName,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          globals.userMail,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class RegData {
  final String? status;
  final String? error;
  RegData({this.status, this.error});
  factory RegData.fromMap(Map<String, dynamic> map) {
    return RegData(
      status: map['status'],
      error: map['error'],
    );
  }
}
