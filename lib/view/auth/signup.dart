import 'dart:math';import 'package:driver/Firebase/controller/auth_controller.dart';import 'package:driver/utilitys/app_const.dart';import 'package:driver/utilitys/colors.dart';import 'package:driver/view/auth/login.dart';import 'package:driver/widgets/appButton.dart';import 'package:driver/widgets/app_inputs.dart';import 'package:driver/widgets/text_widgets.dart';import 'package:firebase_messaging/firebase_messaging.dart';import 'package:flutter/material.dart';import 'package:font_awesome_flutter/font_awesome_flutter.dart';import 'package:geolocator/geolocator.dart';class SingUp extends StatefulWidget {  const SingUp({Key? key}) : super(key: key);  @override  State<SingUp> createState() => _SingUpState();}class _SingUpState extends State<SingUp> {  final _signUpFormState = GlobalKey<FormState>();  final _fullName = TextEditingController();  final _email = TextEditingController();  final _phone = TextEditingController();  final _pass = TextEditingController();  final _cPass = TextEditingController();  final _firstName = TextEditingController();  final _lastName = TextEditingController();  bool _showPassword = true;  bool _isLoading = false;  /// current possitions  Position? _currentPosition;  ///  ///  /// ======= get driver location =====  Future<void> _getCurrentPosition() async {    await Geolocator.getCurrentPosition(        desiredAccuracy: LocationAccuracy.high)        .then((Position position) {      setState(() => _currentPosition = position);    }).catchError((e) {      debugPrint(e);    });  }  ///  /// ====== init state ======  @override  void initState() {    // TODO: implement initState    super.initState();    getDeviceTokenToSendNotification();    _getCurrentPosition();  }  var deviceTokenToSendPushNotification;  Future<void> getDeviceTokenToSendNotification() async {    final FirebaseMessaging _fcm = FirebaseMessaging.instance;    final token = await _fcm.getToken();    deviceTokenToSendPushNotification = token.toString();    print("Token Value $deviceTokenToSendPushNotification");  }  @override  Widget build(BuildContext context) {    return Scaffold(      backgroundColor: AppColors.bgColor,      body:SingleChildScrollView(        padding: EdgeInsets.only(top: 100, bottom: 20, right: 20, left: 20),        child: Column(          mainAxisAlignment: MainAxisAlignment.start,          crossAxisAlignment: CrossAxisAlignment.start,          children: [            Image.asset("${AppConst.app_logo}" , height: 120, width: 120,),            SizedBox(height: 20,),            TextWithSubText(              title: "Login",              subTitle: "Enter your email and we'll send you a login code",            ),            SizedBox(height: 20,),            Form(                key: _signUpFormState,                child: Column(                  children: [                    AppInput(                      title: "First Name",                      hintText: "First Name",                      controller: _firstName,                      validator: (v){                        if(v!.isEmpty){                          return "First name must not be empty.";                        }else{                          return null;                        }                      },                    ),                    SizedBox(height: 20,),                    AppInput(                      title: "Last Name",                      hintText: "Last Name",                      controller: _lastName,                      validator: (v){                        if(v!.isEmpty){                          return "Last must not be empty.";                        }else{                          return null;                        }                      },                    ),                    SizedBox(height: 20,),                    AppInput(                      title: "Email",                      hintText: "jhon@gmail.com",                      controller: _email,                      validator: (v){                        if(v!.isEmpty){                          return "Email must not be empty.";                        }else{                          return null;                        }                      },                    ),                    SizedBox(height: 20,),                    AppInput(                      title: "Phone",                      hintText: "Phone Number",                      controller: _phone,                      validator: (v){                        if(v!.isEmpty){                          return "Phone Number must not be empty.";                        }else{                          return null;                        }                      },                    ),                    SizedBox(height: 20,),                    AppInput(                      title: "Password",                      hintText: "password",                      controller: _pass,                      obscureText: _showPassword,                      suffixIcon: IconButton(                        onPressed: (){                          setState(() {                            _showPassword = !_showPassword;                          });                        },                        icon: Icon(_showPassword ?Icons.visibility: Icons.visibility_off, color: AppColors.bgColor,),),                      validator: (v){                        if(v!.isEmpty){                          return "Password must not be empty.";                        }else if(v!.length > 7){                          return "Password must be 6 characters";                        }else{                          return null;                        }                      },                    ),                    SizedBox(height: 20,),                    AppInput(                      title: "Confirm Password",                      hintText: "Confirm password",                      controller: _cPass,                      obscureText: _showPassword,                      suffixIcon: IconButton(                        onPressed: (){                          setState(() {                            _showPassword = !_showPassword;                          });                        },                        icon: Icon(_showPassword ?Icons.visibility: Icons.visibility_off, color: AppColors.bgColor,),),                      validator: (v){                        if(v!.isEmpty){                          return "Confimr Password must not be empty.";                        }else if(v!.toString() != _pass.text){                          return "Confirm Password doesn't match.";                        }else{                          return null;                        }                      },                    ),                    SizedBox(height: 30,),                    AppButton(                      onClick: ()async{                        if(_isLoading){                          return null;                        }else{                          Random rnd = new Random();                          int id = rnd.nextInt(10);                          setState(() => _isLoading = true);                          var data = {                            "id" : id.toString(),                            "name": "${_firstName.text} ${_lastName.text}",                            "email" : _email.text,                            "phone" : _phone.text,                            "password" : _pass.text,                            "rle" : "driver", // "user" or "driver                            "profile" : null,                            "account_status" : "1",                            "account_verify" : "0",                            "email_verify" : "0",                            "phone_verify" : "0",                            "driver_licence" : null,                            "location" : {                              "lat" : _currentPosition!.latitude,                              "lng" : _currentPosition!.longitude,                              "address" : null                            },                            "device_token" : deviceTokenToSendPushNotification,                          };                          print("data === ${data}");                          await AuthController.signUp(context: context, data: data);                        }                        setState(() => _isLoading = false);                      },                      text: "Sign Up",                      isLoading: _isLoading,                    ),                    SizedBox(height: 30,),                    InkWell(                        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Login())),                        child: Center(                            child: RichText(                              text: TextSpan(                                  children: [                                    TextSpan(text: "I have an account.",                                      style: TextStyle(                                          color: AppColors.black,                                          fontWeight: FontWeight.w400,                                          fontSize: 14                                      ),                                    ),                                    TextSpan(text: " Login Now",                                      style: TextStyle(                                          color: AppColors.blue,                                          fontWeight: FontWeight.w600,                                          fontSize: 14                                      ),                                    )                                  ]                              ),                            )                        ))                  ],                ))          ],        ),      ),    );  }}