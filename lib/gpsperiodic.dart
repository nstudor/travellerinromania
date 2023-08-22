import 'dart:io';
import 'dart:io' as io;
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'globals.dart' as globals;

class GeolocationService {
  static StreamSubscription<Position> subscribeToPositionStream() {
    return Geolocator.getPositionStream().listen((position) {
      globals.gpsLatitude = position.latitude;
      globals.gpsLongitude = position.longitude;
      globals.gpsAccuracy = position.accuracy;
      globals.gpsTime = DateTime.now().millisecondsSinceEpoch;
      globals.gpsChanged = true;
      print(
          'Latitude: ${globals.gpsLatitude} ; Longitude: ${globals.gpsLongitude} ; Accuracy: ${globals.gpsAccuracy}');
    });
  }
}
