import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/widgets/app_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class WishListController{

  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;


  //add to wishlist
  static Future<bool> addToFavorite({required Map<String, dynamic> data})async{
    try{
      await _firestore.collection("drivers_wishlist").add(data);
      AppToast(text: "Car added into your favourite list. ", color: Colors.green);
      return true;
    }catch(e){
      return false;
    }
  }

  //remove from wishlist
  static Future<bool> removeFromFavorite({required String carId})async{
    try{
     //remove from wishlist where car id is == card id
      var existingWishList = _firestore.collection("drivers_wishlist").get();
      existingWishList.then((value) {
        for (var i = 0; i < value.docs.length; i++) {
          if(value.docs[i].data()["car_info"]["car_id"] == carId && value.docs[i].data()["driver_info"] == _auth.currentUser!.email) {
            _firestore.collection("drivers_wishlist").doc(value.docs[i].id).delete();
            AppToast(text: "Car remove from your favourite list.", color: Colors.green);
            return true;
          }
        }
      });
      return true;
    }catch(e){
      print("error: $e");
      return false;
    }
  }

  //get wishlist
  static Stream<QuerySnapshot<Map<String, dynamic>>> getWishList() {
    return _firestore.collection("drivers_wishlist").where("driver_info", isEqualTo: _auth.currentUser!.email).snapshots();
  }

  //check wishlist exists or not
  static Future<bool> checkWishlistExists({required dynamic carId})async{
    try{
      User? user = _auth.currentUser;
      QuerySnapshot<Map<String, dynamic>> documentSnapshot = await _firestore.collection("drivers_wishlist").get();
      if (documentSnapshot.docs.isNotEmpty) {
        for (var i = 0; i < documentSnapshot.docs.length; i++) {

          if (documentSnapshot.docs[i].data()["car_info"]["car_id"] == carId && documentSnapshot.docs[i].data()["driver_info"] == _auth.currentUser!.email){
            return true;
          }
        }
        return false;
      } else {
        return false;
      }
    }catch(e){
      return false;
    }
  }



}