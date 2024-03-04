import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseNotificationController{

  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  //add notification

  //send notification data into firebase
  static Future<bool> sendNotificationData({required Map<String, dynamic> data})async{
    try{
      await _firestore.collection("notification").add(data);
      return true;
    }catch(e){
      return false;
    }
  }

  //get notification data
  static Stream<QuerySnapshot<Map<String, dynamic>>> getNotificationData() {
    return _firestore.collection("notification").where("driverEmail", isEqualTo: _auth.currentUser!.email).snapshots();
  }

  //update notification is read or not
  static Future<bool> updateNotificationIsRead({required String id})async{
    try{
      await _firestore.collection("notification").doc(id).update({"isRead": true});
      return true;
    }catch(e){
      return false;
    }
  }

}