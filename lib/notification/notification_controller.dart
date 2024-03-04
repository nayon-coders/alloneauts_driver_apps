import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../app_config.dart';


class NotificationController{

  //send notification to user
  static Future<bool> sendNotification({required String id, required String title, required String body, required List<String> token, required String image, required BuildContext context})async{

    print("image $image");
    try{

      var res = await http.post(Uri.parse(AppConfig.NOTIFICATION_URL),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization' : AppConfig.FIREBASE_SERVER_KEY
          },
          body: jsonEncode({
            "registration_ids": token,
            "notification": {
              "body": body,
              "title": title,
              "android_channel_id": "pushnotificationapp",
              "sound": false,
              "image": image,
              "payload": "$id",
            },
            "data": {
              "id" : id
            }
          }
          )
      );
      print("res body ${res.body}");
      if(res.statusCode == 200){
        return true;
      }else{
        return false;
      }
    }catch(e){
      print("error: $e");
      return false;
    }

  }


  //data add into firebase



}