
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/app_toast.dart';

class PermissionHandler{

  //notification permission
  static Future<void> requestNotificationPermissions() async {
    if (Platform.isAndroid) {
      final PermissionStatus status = await Permission.notification.request();
      if (status.isGranted) {
        // Notification permissions granted
      } else if (status.isDenied) {
        // Notification permissions denied
      } else if (status.isPermanentlyDenied) {
        // Notification permissions permanently denied, open app settings
        await openAppSettings();
      }
    }
  }

  //location permission
  static Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppToast(text: 'Location services are disabled. Please enable the services', color: Colors.red);
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        AppToast(text: 'Location permissions are denied', color: Colors.red);
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      AppToast(text: 'Location permissions are permanently denied, we cannot request permissions.', color: Colors.red);
      return false;
    }
    return true;
  }


}