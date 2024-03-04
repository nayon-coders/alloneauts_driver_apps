import 'dart:io';

import 'package:driver/Firebase/controller/auth_controller.dart';
import 'package:driver/Firebase/controller/image_picker_controller/pick_image.dart';
import 'package:driver/widgets/appButton.dart';
import 'package:driver/widgets/app_inputs.dart';
import 'package:driver/widgets/app_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utilitys/colors.dart';

class ChangeInfo extends StatefulWidget {
  const ChangeInfo({super.key});

  @override
  State<ChangeInfo> createState() => _ChangeInfoState();
}

class _ChangeInfoState extends State<ChangeInfo> {
  final _name = TextEditingController();
  final _email  = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _zip = TextEditingController();
  final _country = TextEditingController();

  File? _image;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF3F3F3),
        elevation: 0,
        title: const Text("Personal Information",
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
      body: StreamBuilder(
        stream: AuthController.getDriverProfile(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(color: AppColors.mainColor,),);
          }else if(snapshot.hasData){
            _name.text = snapshot.data["name"];
            _email.text = snapshot.data["email"];
            _phone.text = snapshot.data["phone"];

            return SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Personal Information",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: AppColors.black
                      ),
                    ),
                    SizedBox(height: 20,),
                    Center(
                      child: SizedBox(
                        width: 100, height: 100,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: _image != null
                                  ? Image.file(_image!, fit: BoxFit.cover, width: 100, height: 100,)
                                  : snapshot.data["profile"] != null
                                  ? AppNetWorkImage(url: "https://img.freepik.com/free-photo")
                                  : Image.asset("assets/images/profile.jpg", fit: BoxFit.cover, width: 100, height: 100,),
                            ),
                            Positioned(
                              bottom: 0, right: 0,
                              child: Container(
                                width: 30, height: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: IconButton(
                                  onPressed: ()=>_showBottomSheet(),
                                  icon: Icon(Icons.edit, color: AppColors.white, size: 15,),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    AppInput(title: "Name", hintText: "Name", controller: _name),
                    SizedBox(height: 15,),
                    AppInput(title: "Email", hintText: "email", controller: _email),
                    Text("You can not change your email address. If you want to change your email address, please contact support.",
                      style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.normal, color: Colors.red, fontStyle: FontStyle.italic
                      ),
                    ),
                    SizedBox(height: 15,),
                    AppInput(title: "Phone", hintText: "phone", controller: _phone),
                    Text("If you change your phone number, you need to verify again your new phone number.",
                      style: TextStyle(
                          fontSize: 10, fontWeight: FontWeight.normal, color: Colors.red, fontStyle: FontStyle.italic
                      ),
                    ),
                    SizedBox(height: 30,),
                    AppButton(
                        text: "Save Changes",
                        isLoading: _isLoading,
                        onClick: () =>_changeInfo(snapshot.data["profile"])
                    )
                  ]
              ),
            );
          }else{
            return const Center(child: Text("No data found"),);
          }
        }
      )

    );
  }

  _showBottomSheet() async{
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 20,),
              Text("Choose Image",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ListTile(
                leading: new Icon(Icons.camera),
                title: new Text('Camera'),
                onTap: () {
                  takenImage(ImageSource.camera).then((value) {
                    setState(() {
                      _image = value;
                    });
                    Navigator.pop(context);
                  });

                },
              ),
              ListTile(
                leading: new Icon(Icons.photo),
                title: new Text('Photo'),
                onTap: () {
                  takenImage(ImageSource.gallery).then((value) {
                    setState(() {
                      _image = value;
                    });
                    Navigator.pop(context);
                  });

                },
              ),


            ],
          );
        });
  }

  _changeInfo(image) {
    //if user selete image

    setState(() => _isLoading = true);
    AuthController.updateDriverProfile(
      name: _name.text,
      email: _email.text,
      phone: _phone.text,
      profile: _image,
      image: image ?? ""
    );
    setState(() => _isLoading = false);
  }
}
