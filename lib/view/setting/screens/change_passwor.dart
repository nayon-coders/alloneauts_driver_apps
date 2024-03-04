import 'package:driver/Firebase/controller/auth_controller.dart';
import 'package:driver/widgets/appButton.dart';
import 'package:driver/widgets/app_inputs.dart';
import 'package:flutter/material.dart';

import '../../../utilitys/colors.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _key = GlobalKey<FormState>();
  final _newPassword = TextEditingController();
  final _retypePassword = TextEditingController();

  bool _isLoading  = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF3F3F3),
        elevation: 0,
        title: const Text("Password change",
          style: TextStyle(
              color: AppColors.black,
              fontSize: 19
          ),
        ),
        leading: InkWell(
            onTap: ()=>Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Icon(Icons.arrow_back, color: AppColors.black, size: 20,),
              ),
            )),

      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _key,
          child: Column(
            children: [
              AppInput(
                title: "New password",
                hintText: "New password",
                controller: _newPassword,
                validator: (v){
                  if(v!.isEmpty){
                    return "Password is required";
                  }
                  if(v.length < 6){
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              SizedBox(height: 15,),
              AppInput(
                title: "Retype password",
                hintText: "Retype password",
                controller: _retypePassword,
                validator: (v){
                  if(v!.isEmpty){
                    return "Password is required";
                  }
                  if(v != _newPassword.text){
                    return "Password does not match";
                  }
                  return null;

                },
              ),
              SizedBox(height: 30,),
              AppButton(
                  text: "Change Password",
                  isLoading: _isLoading,
                  onClick: ()async{
                    setState(() => _isLoading = true);
                    if(_key.currentState!.validate()){
                      //change password
                      await AuthController.changePassword(newPassword: _newPassword.text, context: context);
                    }
                    setState(() => _isLoading = false);

                  })
            ],
          ),
        ),
      ),
    );
  }
}
