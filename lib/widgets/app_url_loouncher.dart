import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUrlLauncher {
  static void call(String number) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    await launchUrl(launchUri);
  }
}