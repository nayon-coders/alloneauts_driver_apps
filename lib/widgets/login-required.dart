import 'package:driver/Firebase/controller/auth_controller.dart';
import 'package:flutter/material.dart';

import '../generated/assets.dart';
import '../utilitys/colors.dart';
import '../view/auth/login.dart';
import 'appButton.dart';

class LoginRequired extends StatelessWidget {
  final String text;
  const LoginRequired({
    super.key, required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(Assets.imagesRequiredLogin, height: 80, width: 80,),
          SizedBox(height: 20,),
          Text("Authontication Faild",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: AppColors.black
            ),
          ),
          SizedBox(height: 10,),
          Text("$text" ,
            textAlign: TextAlign.center
          ),
          SizedBox(height: 20,),
          AppButton(text: "Login Now", onClick: (){
           AuthController.signOut(context);
           // Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));

          }),
        ],
      ),
    );
  }
}
