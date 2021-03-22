import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
export 'package:geolocator/geolocator.dart';

Future<Position> determinePosition(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();


  if (!serviceEnabled) {
    Geolocator.openLocationSettings();
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permantly denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }
  try {
    Position position = await Geolocator.getCurrentPosition();
    return position;
  } on Exception catch (_){
    try{
      Position position = await Geolocator.getCurrentPosition(timeLimit: Duration(seconds: 3),forceAndroidLocationManager: true);
      return position;
    } on Exception catch (_){
      print("Could not get location");
      _gpsErrorDialog(context);


      return Future.error(
          'Could not get a GPS fix');
    }

    }

  }


_gpsErrorDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('GPS Error'),
          content: Text('Could not get a GPS fix'),
          actions: [
            MaterialButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}