// import 'package:driver/Firebase/controller/car_rent_controller.dart';
// import 'package:driver/utilitys/colors.dart';
// import 'package:driver/widgets/appButton.dart';
// import 'package:driver/widgets/app_network_image.dart';
// import 'package:driver/widgets/app_toast.dart';
// import 'package:flutter/material.dart';
//
// import '../../widgets/alert.dart';
// import '../../widgets/app_url_loouncher.dart';
//
//
// class SingleCar extends StatefulWidget {
//   final Map<String, dynamic>? singleCar;
//   const SingleCar({Key? key, this.singleCar}) : super(key: key);
//
//   @override
//   State<SingleCar> createState() => _SingleCarState();
// }
//
// class _SingleCarState extends State<SingleCar> {
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     print("widget ==== ${widget.singleCar}");
//   }
//
//
//   //bool _isLoading = false;
//   bool _isLoading = false;
//
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: AppColors.mainBg,
//       appBar: AppBar(
//         backgroundColor: Color(0xffF3F3F3),
//         elevation: 0,
//         title: const Text("Car Information",
//           style: TextStyle(
//               color: AppColors.black,
//               fontSize: 19
//           ),
//         ),
//         leading: InkWell(
//             onTap: ()=>Navigator.pop(context),
//             child: Container(
//               width: 40,
//               height: 40,
//               margin: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Color(0xffD9D9D9),
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               child: Center(
//                 child: Icon(Icons.arrow_back, color: AppColors.black, size: 20,),
//               ),
//             )),
//         actions: [
//           Container(
//             width: 40,
//             height: 40,
//             margin: EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Color(0xffD9D9D9),
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child: Center(
//               child: Icon(Icons.favorite, color: AppColors.black, size: 20,),
//             ),
//           ),
//         ],
//       ),
//
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             //car image 
//             Container(
//               width: size.width,
//               height: 300,
//               padding: EdgeInsets.all(30),
//               decoration: BoxDecoration(
//                   color: Color(0xffF3F3F3),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30),
//                   )
//               ),
//               child: AppNetWorkImage(url: "${widget.singleCar!["car_info"]["images"]["carImage"]}", height: 200, width: 200),
//             ),
//
//             SizedBox(height: 20,),
//             Padding(
//               padding: EdgeInsets.only(left: 20, right: 20),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("${widget.singleCar!["car_info"]["name"]}",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16,
//                         color: AppColors.black
//                     ),
//                   ),
//                   SizedBox(height: 10,),
//                   Row(
//                     children: [
//                       Icon(Icons.star, color: Colors.amber, size: 20,),
//                       SizedBox(width: 3,),
//                       Text("0",
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                               color: Colors.grey
//                           )
//                       ),
//                       SizedBox(width: 3,),
//                       Text("(0)",
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w400,
//                               color: Colors.grey
//                           )
//                       )
//
//                     ],
//                   ),
//                   SizedBox(height: 20,),
//                   Text("Car Information",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16,
//                         color: AppColors.black
//                     ),
//                   ),
//                   SizedBox(height: 10,),
//                   widget.singleCar!["car_info"]["vcolor"] != null ? SIngleCarDetailsRow(
//                     title: "Vehicle Color",
//                     value: "${widget.singleCar!["car_info"]["vcolor"] ?? "Car Color"}",
//                   ) : Center(),
//                   SizedBox(height: 7,),
//                   widget.singleCar!["car_info"]["mileage"] != null ? SIngleCarDetailsRow(
//                     title: "Vehicle Millage",
//                     value: "${widget.singleCar!["car_info"]["mileage"]}",
//                   ) : Center(),
//
//                   SizedBox(height: 30,),
//                   Text("Renter",
//                     style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16,
//                         color: AppColors.black
//                     ),
//                   ),
//                   SizedBox(height: 10,),
//                   ListTile(
//                     leading: ClipRRect(borderRadius: BorderRadius.circular(100), child: AppNetWorkImage(url: "https://img.freepik.com/free-photo/handsome-man-home_144627-9821.jpg", height: 60, width: 60)),
//                     title: Text("${widget.singleCar!["vendor_info"]["vendor_name"] ?? "Vendor Name"}",
//                       style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                           color: AppColors.black
//                       ),
//                     ),
//                     subtitle: Row(
//                       children: [
//                         Icon(Icons.star, color: Colors.amber, size: 20,),
//                         SizedBox(width: 3,),
//                         Text("4.6",
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey
//                             )
//                         ),
//                         SizedBox(width: 3,),
//                         Text("(89)",
//                             style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey
//                             )
//                         )
//
//                       ],
//                     ),
//                     trailing: SizedBox(
//                         width: 80,
//                         child: Row(
//                           children: [
//                             InkWell(
//                                 onTap: ()=> widget.singleCar!["vendor_info"]["phone"] != null ? AppUrlLauncher.call(widget.singleCar!["vendor_info"]["phone"] ?? "") : AppToast(text: "Phone is empty. You can not call him.", color: Colors.red),
//                                 child: Container(
//                                   width: 35,
//                                   height: 40,
//                                   margin: EdgeInsets.only(right: 10),
//                                   decoration: BoxDecoration(
//                                     color: Color(0xffD9D9D9),
//                                     borderRadius: BorderRadius.circular(5),
//                                   ),
//                                   child: Center(
//                                     child: Icon(Icons.call, color: AppColors.black, size: 20,),
//                                   ),
//                                 )),
//                             Container(
//                               width: 35,
//                               height: 40,
//                               decoration: BoxDecoration(
//                                 color: Color(0xffD9D9D9),
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: Center(
//                                 child: Icon(Icons.location_on, color: AppColors.black, size: 20,),
//                               ),
//                             ),
//                           ],
//                         )),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//       bottomNavigationBar: Container(
//         width: size.width,
//         height: 100,
//         padding: EdgeInsets.all(20),
//         decoration: BoxDecoration(
//             color: AppColors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(50),
//               topRight: Radius.circular(50),
//             ),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.grey.shade200,
//                   offset: Offset(0,1),
//                   blurRadius: 10,
//                   spreadRadius: 4
//               )
//             ]
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             RichText(
//                 text: TextSpan(
//                     children: [
//                       TextSpan(
//                           text: "\$450.90",
//                           style: TextStyle(
//                               fontSize: 30,
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.black
//                           )
//                       ),
//                       TextSpan(
//                           text: "/Day",
//                           style: TextStyle(
//                               fontSize: 25,
//                               fontWeight: FontWeight.w400,
//                               color: Colors.grey
//                           )
//                       )
//                     ]
//                 )
//             ),
//
//             AppButton(
//               width: 180,
//               height: 60,
//               onClick: ()async{
//                 setState(() => _isLoading = true);
//                 await FirebaseCarRentController.sendRequest(data: widget.singleCar!, context: context);
//                 setState(() => _isLoading = false);
//               },
//               isLoading: _isLoading,
//               text: "Send Request",
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
// class SIngleCarDetailsRow extends StatelessWidget {
//   const SIngleCarDetailsRow({
//     super.key, required this.title, required this.value,
//   });
//
//   final String title;
//   final String value;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Text("$title: ",
//           style: TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 14,
//               color: AppColors.black
//           ),
//         ),
//         Text("$value",
//           style: TextStyle(
//               fontWeight: FontWeight.w400,
//               fontSize: 14,
//               color: AppColors.black
//           ),
//         ),
//       ],
//     );
//   }
// }
//
//
