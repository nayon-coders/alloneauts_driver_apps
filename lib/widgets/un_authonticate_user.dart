import 'package:flutter/material.dart';

import '../utilitys/colors.dart';
import '../view/auth/login.dart';
import 'appButton.dart';

class UnAuthonticateUser extends StatelessWidget {
  const UnAuthonticateUser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Authontication Faild",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: AppColors.black
            ),
          ),
          SizedBox(height: 10,),
          Text("Lofin first to access setting page" ),
          SizedBox(height: 20,),
          AppButton(text: "Login Now", onClick: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => Login()))),
        ],
      ),
    );
  }
}
