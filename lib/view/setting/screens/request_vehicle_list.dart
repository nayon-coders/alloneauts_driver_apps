import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/Firebase/controller/car_rent_controller.dart';
import 'package:driver/widgets/alert.dart';
import 'package:driver/widgets/app_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utilitys/colors.dart';
import '../../../widgets/car_list_view.dart';
import '../../../widgets/side_byside_text.dart';
import '../../single_car/single_cart.dart';


class RequestVehiclesList extends StatefulWidget {
  const RequestVehiclesList({super.key});

  @override
  State<RequestVehiclesList> createState() => _RequestVehiclesListState();
}

class _RequestVehiclesListState extends State<RequestVehiclesList> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.mainBg,
      appBar: AppBar(
        backgroundColor: Color(0xffF3F3F3),
        elevation: 0,
        title: const Text("Request Vehicle's List",
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
      body:StreamBuilder(
        stream: FirebaseCarRentController.getMyCars(),
        builder: (context, snapshot) {

         if(snapshot.connectionState == ConnectionState.waiting) {
           return const Center(
             child: CircularProgressIndicator(color: AppColors.mainColor,),);
         }else if(snapshot.hasData){
           if(snapshot.data!.docs!.length == 0) {
             return const Center(
               child: Text("No Data Found"),
             );
           }else{
             return Container(
               width: size.width,
               height: size.height,
               padding: EdgeInsets.all(20),
               child: ListView.builder(
                 shrinkWrap: true,
                 itemCount: snapshot.data!.docs.length,
                 itemBuilder: (_, index){
                   var data =  snapshot.data!.docs[index].data(); //get data

                   //only show my data
                    if(data["driver"]["email"] == _auth.currentUser!.email){
                      return data["status"] == "cancel"  ? Center() :Container(
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: const Offset(0, 0),
                            )
                          ]
                        ),
                        child: ListTile(
                          onTap: (){
                            showCarInfo(snapshot.data!.docs[index]);
                          },
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(data["car"]["car_info"]["images"]["carImage"]),
                          ),
                          title: Text(data["car"]["car_info"]["name"]),
                          subtitle: Text(data["status"],
                            style: TextStyle(
                              color: data["status"] == "pending" ? Colors.blue: AppColors.mainColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400
                            )
                          ),
                          trailing: Text("${data["car"]["car_info"]["price"]} \$",
                            style: TextStyle(
                              color: AppColors.mainColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      );
                    }

                 },
               ),

             );
           }
         }else{
           return const Center(
             child: Text("No Data Found"),
           );
         }
        }
      )
    );
  }

  //show a bottom sheet with car info
  void showCarInfo(info) {
    var data = info["car"];
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
        ),
        context: context,
        builder: (context){
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Car Info",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(data["car_info"]["images"]["carImage"]),
                      ),
                      SizedBox(width: 20,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data["car_info"]["name"],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text("${data["car_info"]["price"]}\$/${data["car_info"]["rent_type"]}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text("Car Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black
                    ),
                  ),
                  SizedBox(height: 10,),
                  data["car_info"]["model"] != null ? SIngleCarDetailsRow(
                    title: "Vehicle Model",
                    value: "${data["car_info"]["model"] ?? "Car Color"}",
                  ) : Center(),
                  SizedBox(height: 7,),
                  data["car_info"]["color"] != null ? SIngleCarDetailsRow(
                    title: "Vehicle Color",
                    value: "${data["car_info"]["color"] ?? "Car Color"}",
                  ) : Center(),
                  SizedBox(height: 7,),
                  data["car_info"]["mileage"] != null ? SIngleCarDetailsRow(
                    title: "Vehicle Millage",
                    value: "${data["car_info"]["mileage"]}",
                  ) : Center(),
                  SizedBox(height: 7,),
                  data["car_info"]["rent_type"] != null ? SIngleCarDetailsRow(
                    title: "Rent Type",
                    value: "${data["car_info"]["rent_type"]}",
                  ) : Center(),
                  SizedBox(height: 7,),
                  data["car_info"]["price"] != null ? SIngleCarDetailsRow(
                    title: "Rent Price",
                    value: "${data["car_info"]["price"]}",
                  ) : Center(),
                  SizedBox(height: 15,),
                  const Text("Vehicle owner info",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black
                    ),
                  ),
                  SizedBox(height: 10,),
                  data["vendor_info"]["f_name"] != null ? SIngleCarDetailsRow(
                    title: "Owner Name",
                    value: "${ data["vendor_info"]["f_name"]} ${data["vendor_info"]["l_name"]}",
                  ) : Center(),
                  SizedBox(height: 7,),
                  data["vendor_info"]["email"] != null ? SIngleCarDetailsRow(
                    title: "Owner Email",
                    value: "${ data["vendor_info"]["email"]}",
                  ) : Center(),
                  SizedBox(height: 7,),
                  data["vendor_info"]["phone"] != null ? SIngleCarDetailsRow(
                    title: "Owner phone",
                    value: "${ data["vendor_info"]["phone"]}",
                  ) : Center(),

                  SizedBox(height: 15,),
                  const Text("Request Status",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: info["status"] == "pending" ? Colors.blue : AppColors.mainColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text(info["status"],
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  InkWell(
                    onTap: (){
                      AppAler.showMyDialog(
                          message: "Are you sure? You want to cancel the request? Once you cancel the request it will be delete from you and from vendor.",
                          context: context,
                          icon: Icons.error_outline,
                          onClickText: "Cancel",
                          onClick: ()=>FirebaseCarRentController.cancelRequest(requestId: info.id, context: context)
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text("Cancel",
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          );
        }
    );
  }


}
