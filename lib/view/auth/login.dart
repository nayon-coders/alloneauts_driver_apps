import 'package:driver/Firebase/controller/auth_controller.dart';import 'package:driver/utilitys/app_const.dart';import 'package:driver/utilitys/colors.dart';import 'package:driver/view/auth/forget_password.dart';import 'package:driver/view/auth/signup.dart';import 'package:driver/view/bottom_navigation/screen/bootom_navigation.dart';import 'package:driver/widgets/app_inputs.dart';import 'package:driver/widgets/text_widgets.dart';import 'package:firebase_auth/firebase_auth.dart';import 'package:firebase_messaging/firebase_messaging.dart';import 'package:flutter/material.dart';import 'package:font_awesome_flutter/font_awesome_flutter.dart';import '../../widgets/alert.dart';import '../../widgets/appButton.dart';class Login extends StatefulWidget {  const Login({Key? key}) : super(key: key);  @override  State<Login> createState() => _LoginState();}class _LoginState extends State<Login> {  final _loginFormState = GlobalKey<FormState>();  final _email = TextEditingController();  final _pass = TextEditingController();  final _phone = TextEditingController();  bool _showPassword = true;  bool _isLoading = false;  var deviceTokenToSendPushNotification;  Future<void> getDeviceTokenToSendNotification() async {    final FirebaseMessaging _fcm = FirebaseMessaging.instance;    final token = await _fcm.getToken();    deviceTokenToSendPushNotification = token.toString();    print("Token Value $deviceTokenToSendPushNotification");  }  @override  void initState() {    // TODO: implement initState    super.initState();    getDeviceTokenToSendNotification();  }  @override  Widget build(BuildContext context) {    return Scaffold(      backgroundColor: AppColors.bgColor,      body:SingleChildScrollView(        padding: EdgeInsets.only(top: 100, bottom: 20, right: 20, left: 20),        child: Column(          mainAxisAlignment: MainAxisAlignment.start,          crossAxisAlignment: CrossAxisAlignment.start,          children: [            Image.asset("${AppConst.app_logo}" , height: 140, width: 140,),            SizedBox(height: 30,),            TextWithSubText(              title: "Login",              subTitle: "Enter your email and we'll send you a login code",            ),             SizedBox(height: 20,),            Form(              key: _loginFormState,                child: Column(                  children: [                    AppInput(                        title: "Email",                        hintText: "jhon@gmail.com",                        controller: _email,                        validator: (v){                              if(v!.isEmpty){                                return "Email must not be empty.";                              }else{                                return null;                              }                        },                     ),                    SizedBox(height: 20,),                    AppInput(                      title: "Password",                      hintText: "password",                      controller: _pass,                      obscureText: _showPassword,                      suffixIcon: IconButton(                        onPressed: (){                          setState(() {                            _showPassword = !_showPassword;                          });                        },                        icon: Icon(_showPassword ?Icons.visibility: Icons.visibility_off, color: AppColors.bgColor,),),                      validator: (v){                        if(v!.isEmpty){                          return "Password must not be empty.";                        }else{                          return null;                        }                      },                    ),                    Align(                      alignment: Alignment.centerRight,                      child: TextButton(                        onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotPassword())),                         child: Text("Forgot password?"),                      ),                    ),                    SizedBox(height: 30,),                    AppButton(                      onClick: ()async{                        setState(() => _isLoading = true);                        await AuthController.signInWithEmailAndPassword(email: _email.text, pass: _pass.text, context: context, deviceToken: deviceTokenToSendPushNotification);                        setState(() => _isLoading = false);                      },                      text: "Login",                      isLoading: _isLoading,                    ),                    SizedBox(height: 20,),                    Center(                      child: Text("Or login with social media",                        style: TextStyle(                          color: AppColors.black,                          fontWeight: FontWeight.w400,                          fontSize: 14                        ),                      ),                    ),                    SizedBox(height: 15,),                    InkWell(                      onTap: (){                        setState(() => _isLoading = true);                        //AppAler.appAlert(title: "Under Verification", message: "We are under verification to apply google service.", context: context);                        AuthController.signInWithGoogle(context: context, deviceToken: deviceTokenToSendPushNotification);                        //FirebaseAuth.instance.signOut(); // for testing                        setState(() => _isLoading = false);                      },                      child: Container(                        width: 200,                        height: 40,                        decoration: BoxDecoration(                            color: AppColors.red,                            borderRadius: BorderRadius.circular(5)                        ),                        child: _isLoading ? Center(child: CircularProgressIndicator(color: Colors.white,),) : Row(                          mainAxisAlignment: MainAxisAlignment.center,                          children: [                            FaIcon(FontAwesomeIcons.google, color: AppColors.white,),                            SizedBox(width: 8,),                            Text("Google",                              style: TextStyle(color: AppColors.white),                            )                          ],                        ),                      ),                    ),                    SizedBox(height: 30,),                    InkWell(                        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SingUp())),                        child: Center(                      child: RichText(                        text: TextSpan(                          children: [                            TextSpan(text: "I don't have an account.",                              style: TextStyle(                                  color: AppColors.black,                                  fontWeight: FontWeight.w400,                                  fontSize: 14                              ),                            ),                            TextSpan(text: " Signup Now",                              style: TextStyle(                                  color: AppColors.blue,                                  fontWeight: FontWeight.w600,                                  fontSize: 14                              ),                            )                          ]                        ),                      )                    ))                  ],                ))          ],        ),      ),    );  }}