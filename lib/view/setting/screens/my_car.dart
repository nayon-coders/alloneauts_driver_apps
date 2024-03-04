import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/Firebase/controller/car_rent_controller.dart';
import 'package:driver/widgets/app_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../utilitys/colors.dart';
import '../../../widgets/app_url_loouncher.dart';
import '../../../widgets/side_byside_text.dart';

class MyCar extends StatefulWidget {
  const MyCar({super.key});

  @override
  State<MyCar> createState() => _MyCarState();
}

class _MyCarState extends State<MyCar> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF3F3F3),
        elevation: 0,
        title: const Text("My Vehicle's ",
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
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.white,
        backgroundColor: Colors.blue,
        strokeWidth: 4.0,
        onRefresh: () async {
         setState(() {

         });
        },
        child: StreamBuilder(
          stream: FirebaseCarRentController.getMyCars(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(color: AppColors.mainColor,),);
            }else if(snapshot.hasData){
              //check the status if the status is assign or not
               List<QueryDocumentSnapshot<Map<String, dynamic>>> data =[];
              for(var i in snapshot.data!.docs){
                if(i.data()["status"] == "assign"){
                  data.add(i);
                }
              }
               return data.isNotEmpty ? SingleChildScrollView(
                 padding: EdgeInsets.all(15),
                 child: _MyCarInfo(data: data[0].data(),),
               ) : Center(child: Text("No car found."),);

            }else{
              return const Center(child: Text("No car found"),);
            }
          }
        ),
      ),
    );
  }

  Widget _MyCarInfo({required Map<String, dynamic> data}) {
    var carInfo = data["car"]["car_info"];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          child: AppNetWorkImage(url: carInfo["images"]["carImage"], height: 200, width: double.infinity, boxFit: BoxFit.contain,)
       ),
        SizedBox(height: 20,),
        Text("Vehicle Details",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.black
          ),
        ),
        SizedBox(height: 10,),
        carInfo["model"] != null ? SIngleCarDetailsRow(
          title: "Vehicle Model",
          value: "${carInfo["model"] ?? "Car Color"}",
        ) : Center(),
        SizedBox(height: 7,),
        carInfo["color"] != null ? SIngleCarDetailsRow(
          title: "Vehicle Color",
          value: "${carInfo["color"] ?? "Car Color"}",
        ) : Center(),
        SizedBox(height: 7,),
        carInfo["mileage"] != null ? SIngleCarDetailsRow(
          title: "Vehicle Millage",
          value: "${carInfo["mileage"]}",
        ) : Center(),
        SizedBox(height: 7,),
        carInfo["rent_type"] != null ? SIngleCarDetailsRow(
          title: "Rent Type",
          value: "${carInfo["rent_type"]}",
        ) : Center(),
        SizedBox(height: 7,),
        carInfo["price"] != null ? SIngleCarDetailsRow(
          title: "Rent Price",
          value: "${carInfo["price"]}",
        ) : Center(),
        SizedBox(height: 20,),
        const Text("Vehicle owner info",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.black
          ),
        ),
        SizedBox(height: 10,),
        data["car"]["vendor_info"]["f_name"] != null ? SIngleCarDetailsRow(
          title: "Owner Name",
          value: "${ data["car"]["vendor_info"]["f_name"]} ${data["car"]["vendor_info"]["l_name"]}",
        ) : Center(),
        SizedBox(height: 7,),
        data["car"]["vendor_info"]["email"] != null ? SIngleCarDetailsRow(
          title: "Owner Email",
          value: "${ data["car"]["vendor_info"]["email"]}",
        ) : Center(),
        SizedBox(height: 7,),
        data["car"]["vendor_info"]["phone"] != null ? SIngleCarDetailsRow(
          onTap: ()=>AppUrlLauncher.call(data["car"]["vendor_info"]["phone"]),
          title: "Owner phone",
          value: "${ data["car"]["vendor_info"]["phone"]}",
        ) : Center(),

        SizedBox(height: 20,),

        const Text("Vehicle Documents",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.black
          ),
        ),
        SizedBox(height: 10,),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Fh1",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black
              ),
            ),
            SizedBox(height: 10,),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AppNetWorkImage(url: carInfo["images"]["fh1"],),
            ),
          ],
        ),
        SizedBox(height: 10,),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Driver Declaration",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black
              ),
            ),
            SizedBox(height: 10,),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AppNetWorkImage(url: carInfo["images"]["driverDiclaration"],),
            ),
          ],
        ),
        SizedBox(height: 10,),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Insurance",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black
              ),
            ),
            SizedBox(height: 10,),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AppNetWorkImage(url: carInfo["images"]["insurance"],),
            ),
          ],
        ),


        SizedBox(height: 20,),
        const Text("Vehicle assigning information",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.black
          ),
        ),
        SizedBox(height: 10,),
        data["assigning_informations"]["date"] != null ? SIngleCarDetailsRow(
          title: "Assign date",
          value: "${data["assigning_informations"]["date"]}",
        ) : Center(),
        SizedBox(height: 7,),
        data["assigning_informations"]["payment_per"] != null ? SIngleCarDetailsRow(
          title: "Payment Per ${data["assigning_informations"]["payment_per"]}",
          value: "\$${ data["assigning_informations"]["payment"]}/${data["assigning_informations"]["payment_per"]}",
        ) : Center(),

        SizedBox(height: 50,)

      ],
    );
  }
}
