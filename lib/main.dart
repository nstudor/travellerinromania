import 'dart:io' as io;
import 'dart:convert';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'globals.dart' as globals;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:travellerinromania/gpsperiodic.dart';
import 'package:travellerinromania/splashscreen.dart';
import 'package:travellerinromania/poipage.dart';
import 'package:travellerinromania/firstpage.dart';
import 'package:travellerinromania/loginpage.dart';
import 'package:travellerinromania/registerpage.dart';
import 'package:travellerinromania/profilepage.dart';
import 'package:travellerinromania/showmappage.dart';
import 'package:travellerinromania/scanqrcode.dart';
import 'package:travellerinromania/errorpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calator prin Romania',
      theme: ThemeData(
          primarySwatch: MaterialColor(
        Color.fromRGBO(113, 147, 100, 1).value,
        const <int, Color>{
          50: Color.fromRGBO(113, 147, 100, 0.1),
          100: Color.fromRGBO(113, 147, 100, 0.2),
          200: Color.fromRGBO(113, 147, 100, 0.3),
          300: Color.fromRGBO(113, 147, 100, 0.4),
          400: Color.fromRGBO(113, 147, 100, 0.5),
          500: Color.fromRGBO(113, 147, 100, 0.6),
          600: Color.fromRGBO(113, 147, 100, 0.7),
          700: Color.fromRGBO(113, 147, 100, 0.8),
          800: Color.fromRGBO(113, 147, 100, 0.9),
          900: Color.fromRGBO(113, 147, 100, 1),
        },
      )),
      home: const MyHomePage(title: 'Calator prin Romania'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late StreamSubscription<Position> positionStream;
  SharedPreferences? prefs;

  @override
  void initState() {
    doInitState();
    super.initState();
  }

  doRefresh(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  doInitState() async {
    if (await Permission.location.request().isGranted) {
      positionStream = GeolocationService.subscribeToPositionStream();
    }

    prefs = await SharedPreferences.getInstance();
    globals.prefsLoaded = true;

    globals.userId = prefs!.getString('user_id') ?? "";
    globals.userName = prefs!.getString('user_name') ?? "";
    globals.userMail = prefs!.getString('user_mail') ?? "";

    setState(() {
      print('settingState 1');
      _selectedIndex = 1;
    });
    //}
  }

  getPage() {
    print('geting Page: $_selectedIndex');
    if (globals.prefsLoaded) {
      switch (_selectedIndex) {
        case 0:
          return splashScreen(this.doRefresh);
        case 1:
          return FirstPage(this.doRefresh);
        case 4:
          return LoginPage(this.doRefresh);
        case 5:
          return RegisterPage(this.doRefresh);
        case 6:
          return poiPage(this.doRefresh);
        //Text("Requesting Page " + globals.poiId);
        // case 11:
        //   return BrowsePage(this.doRefresh);
        case 12:
          return ScanQRPage(this.doRefresh);
        case 13:
          return ShowMapPage(this.doRefresh);
        case 14:
          return ProfilePage(this.doRefresh);

        // case 15:
        //   return AddPhotoPage(this.doRefresh);
        // case 16:
        //   return SearchPage(this.doRefresh);
      }
      return ErrorPage(this.doRefresh);
    }
    return splashScreen(this.doRefresh);
  }

  @override
  Widget build(BuildContext context) {
    return showAppBar();
  }

  showAppBar() {
    if (_selectedIndex == 1) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: getPage(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            print("object tapped");
            doRefresh(1);
          },
          child: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.black,
            size: 32,
            semanticLabel: '-',
            shadows: [
              Shadow(color: Colors.white, blurRadius: 15.0),
            ],
          ),
        ),
        title: Text(widget.title),
      ),
      body: getPage(),
    );
  }
}
