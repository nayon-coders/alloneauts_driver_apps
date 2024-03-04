import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/widgets/appButton.dart';
import 'package:driver/widgets/side_byside_text.dart';
import 'package:flutter/material.dart';

import '../../../Firebase/controller/car_rent_controller.dart';
import '../../../utilitys/colors.dart';
class PaymentHistory extends StatefulWidget {
  const PaymentHistory({super.key});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF3F3F3),
        elevation: 0,
        title: const Text("Payment History",
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
                return data.isNotEmpty ?  SingleChildScrollView(
                  padding: EdgeInsets.all(15),
                  child: _paymentHistory(data[0]),
                ) : const Center(child: Text("No assign vehicles found"),);

              }else{
                return const Center(child: Text("No assign vehicles found"),);
              }
            }
        ),
      ),
    );
  }

 Widget _paymentHistory(QueryDocumentSnapshot<Map<String, dynamic>> data) {

    var carInfo = data.data()["car"]["car_info"];
    var carOwnerInfo = data.data()["car"]["vendor_info"];
    var driverInfo = data.data()["driver"];
    var paymentHistory = data.data()["payment_history"];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text("${carInfo["price"]} \$",
                style: TextStyle(
                    color: AppColors.mainColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w600
                ),
              ),
              SizedBox(height: 5,),
              Text("Payment per ${carInfo["rent_type"]} ",
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20,),
        Text("Next Payment",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.black
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
              color: Color(0xffF3F3F3),
              borderRadius: BorderRadius.circular(5)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SIngleCarDetailsRow(title: "Next Payment Date: ", value: paymentHistory["next_payment"]["date"]),
                  SizedBox(height: 7,),
                  SIngleCarDetailsRow(title: "Next Pay amount: ", value: "${paymentHistory["next_payment"]["amount"]}\$"),
                ],
              ),
              AppButton(
                  fontSize: 10,
                  height: 30,
                  width: 100,
                  text: "Pay Now",
                  onClick: (){}
              )
            ],
          ),
        ),

        SizedBox(height: 20,),
        Text("Payment History",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.black
          ),
        ),
        SizedBox(height: 10,),
        SizedBox(
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: paymentHistory["payment_list"].length,
            itemBuilder: (_, index){
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: Color(0xffF3F3F3),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: ListTile(
                  title: Text("Amount: ${paymentHistory["payment_list"][index]["amount"]}\$",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black
                    ),
                  ),
                  subtitle: Text("${paymentHistory["payment_list"][index]["date"]}",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black
                  ),
                ),
                  trailing: Container(
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: paymentHistory["payment_list"][index]["status"] == "pending" ? Colors.blue :  paymentHistory["payment_list"][index]["status"] == "paid" ? AppColors.mainColor : Colors.red,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text("${paymentHistory["payment_list"][index]["status"]}",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white
                      ),
                    )
                  )
                ),
              );
            },
          ),
        )

      ],
    );

  }
}
