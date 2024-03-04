import 'dart:convert';import 'dart:io';import 'dart:math';import 'package:cloud_firestore/cloud_firestore.dart';import 'package:driver/Firebase/model/user_model.dart';import 'package:driver/view/auth/forgot_password_success.dart';import 'package:driver/view/auth/login.dart';import 'package:driver/view/bottom_navigation/screen/bootom_navigation.dart';import 'package:driver/widgets/alert.dart';import 'package:driver/widgets/app_toast.dart';import 'package:firebase_auth/firebase_auth.dart';import 'package:firebase_storage/firebase_storage.dart';import 'package:flutter/material.dart';import 'package:shared_preferences/shared_preferences.dart';class AuthController{  static final FirebaseAuth _auth = FirebaseAuth.instance;  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;  //signing with email  static Future<bool> signInWithEmailAndPassword({required String email, required String pass, required BuildContext context, required String deviceToken}) async {    try {      SharedPreferences _pref = await SharedPreferences.getInstance();      UserCredential userCredential = await _auth.signInWithEmailAndPassword(        email: email,        password: pass,      );      User? user = userCredential.user;      //first update the device token      await _firestore.collection('drivers_profile').doc(user!.email).update({"device_token": deviceToken});      //then check the user role      await _firestore.collection('drivers_profile').doc(user!.email).get().then((userData) {        UserProfileModel _userProfileModel = UserProfileModel.fromJson(jsonDecode(jsonEncode(userData.data()))); //user data        if(_userProfileModel.role == "driver"){          _pref.setString("user_id", user!.uid.toString());          _pref.setString("email", user!.email.toString());          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>AppBottomNavigation()), (route) => false);          AppToast(text: "Login Success", color: Colors.green);        }else{          AppToast(text: "You are not a driver", color: Colors.red);        }      });      return true;    } on FirebaseAuthException catch (e) {      print('Error during email/password sign in: $e');      if(e.code == "invalid-email"){        AppToast(text: "Invalid credentials", color: Colors.red);      }      if(e.code == "invalid-email"){        AppToast(text: "The email address is badly formatted.", color: Colors.red);      }      if(e.code == "user-not-found") {        AppToast(            text: "There is no user record corresponding to this identifier",            color: Colors.red);      }      if(e.code == "wrong-password"){        AppToast(            text: "The password is invalid or the user does not have a password.",            color: Colors.red);      }      if(e.code == "too-many-requests"){        AppToast(            text: "The password is invalid or the user does not have a password.",            color: Colors.red);      }      return false;      // Handle different Firebase Auth exceptions (e.g., invalid email, wrong password)    }  }  //signup  static Future<bool> signUp({required BuildContext context, required Map<String, dynamic> data}) async {    try {      Random rnd = new Random();      int id = rnd.nextInt(10);      SharedPreferences _pref = await SharedPreferences.getInstance();      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(        email: data["email"],        password: data["password"],      );      User? user = userCredential.user;      // Update user profile in Firestore without a profile image      await _firestore.collection('drivers_profile').doc(data["email"]).set(data);        // Add other profile information as need);      _pref.setString("user_id", user!.uid.toString());      _pref.setString("email", user!.email.toString());      print('User signed up: ${user.uid}');      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>AppBottomNavigation()), (route) => false);      AppToast(text: "Registration Success", color: Colors.green);      return true;    } on FirebaseAuthException catch (e) {      print('Error during signup: $e');      if(e.code == 'email-already-in-use'){        ScaffoldMessenger.of(context).showSnackBar(SnackBar(          content: Text("The email address is already in use by another account."),          backgroundColor: Colors.red,          duration: Duration(milliseconds: 3000),        ));      }      return false;      // Handle different Firebase Auth exceptions    }  }  //logout  static Future<void> signOut(context) async {    try {      SharedPreferences _pref = await SharedPreferences.getInstance();      await FirebaseAuth.instance.signOut();      _pref.remove("user_id");      _pref.remove("email");      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login()), (route) => false);      AppToast(text: "Login Success", color: Colors.green);    } catch (e) {      print("Error signing out: $e");    }  }  static Future<void> deleteAccount(context) async {    try {      SharedPreferences _pref = await SharedPreferences.getInstance();      // Get the currently signed-in user      User? user = FirebaseAuth.instance.currentUser;      if (user != null) {        // Delete the user account        await user.delete();        _pref.remove("user_id");        _pref.remove("email");        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Login()), (route) => false);        AppToast(text: "Account Deletion Success", color: Colors.green);        print("User account deleted successfully");      } else {        print("No user signed in");      }    } catch (e) {      print("Error deleting user account: $e");    }  }  static   Future<void> resetPassword({required String email, required BuildContext context}) async {    try {      await FirebaseAuth.instance.sendPasswordResetEmail(        email: email,      );      // Password reset email sent successfully      Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordSuccess(email: email)));      AppToast(text: "Password reset email sent successfully. Check Your mail.", color: Colors.green);      print("Password reset email sent successfully");      // You can navigate to a success screen or show a success message here    } catch (e) {      AppToast(text: "We can not find your account.", color: Colors.red);      // An error occurred while sending the password reset email      print("Error sending password reset email: $e");      // You can display an error message to the user    }  }  ///verify email throw firebase  static Future sendEmailVerification() async {    User? user = _auth.currentUser;    if (user != null) {      try {        await user.sendEmailVerification();        AppToast(text: "A email send to your email. Check and verify  the email.", color: Colors.green);      } catch (e) {        // Show an error message        print('Error sending email verification: $e');      }    }  }  ///  //get driver profile   static Stream getDriverProfile(){    try{      return _firestore.collection("drivers_profile").doc(_auth.currentUser!.email).snapshots();    }catch(e){      print("Error getting driver profile: $e");      return Stream.empty();    }  }  static updateDriverProfile({required String name, required String email, required String phone, required String image, File? profile}) {    try{      //check profile is empty or not      if(profile != null){        // Upload the new profile image to Firebase Storage        String imagePath = 'driver_profile/${_auth.currentUser!.uid}.jpg';        UploadTask uploadTask = FirebaseStorage.instance.ref().child(imagePath).putFile(profile);        uploadTask.whenComplete(() => null);        // Get the download URL of the uploaded image        uploadTask.then((value) async {          String downloadURL = await FirebaseStorage.instance.ref(imagePath).getDownloadURL();          await _firestore.collection("drivers_profile").doc(_auth.currentUser!.email).update({            "name": name,            "email": email,            "phone": phone,            "profile" : downloadURL          });          AppToast(text: "Profile has been updated", color: Colors.green);        });      }else{        _firestore.collection("drivers_profile").doc(_auth.currentUser!.email).update({          "name": name,          "email": email,          "phone": phone,          "profile" : image        });        AppToast(text: "Profile has been updated", color: Colors.green);      }    }catch(e){      print("Error updating driver profile: $e");    }  }  //change password  static Future changePassword({required String newPassword, required BuildContext context}) async {    try {      User? user = _auth.currentUser;      await user!.updatePassword(newPassword);      AppToast(text: "Password has been changed", color: Colors.green);      Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));    } catch (e) {      print("Error updating password: ${e.toString()}");      if(e!.toString().contains("firebase_auth/requires-recent-login")){       AppAler.showMyDialog(           message: "This operation is sensitive and requires recent authentication. Log in again before retrying this request.",           context: context,           onClickText: "Login",           icon: Icons.error,           onClick: ()=>signOut(context)       );       }      AppToast(text: "Error updating password", color: Colors.red);    }  }}