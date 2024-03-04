import 'package:driver/utilitys/colors.dart';import 'package:flutter/material.dart';import '../../../Firebase/notification_controller.dart';class NotificationView extends StatefulWidget {  const NotificationView({Key? key}) : super(key: key);  @override  State<NotificationView> createState() => _NotificationViewState();}class _NotificationViewState extends State<NotificationView> {  @override  Widget build(BuildContext context) {    return Scaffold(      backgroundColor: AppColors.mainBg,      appBar: AppBar(        backgroundColor: Color(0xffF3F3F3),        elevation: 0,        title: const Text("Notification",          style: TextStyle(              color: AppColors.black,              fontSize: 19          ),        ),        leading: InkWell(            onTap: ()=>Navigator.pop(context),            child: Container(              width: 40,              height: 40,              margin: EdgeInsets.all(10),              decoration: BoxDecoration(                color: Color(0xffD9D9D9),                borderRadius: BorderRadius.circular(5),              ),              child: Center(                child: Icon(Icons.arrow_back, color: AppColors.black, size: 20,),              ),            )),        actions: [          ///TODO: Add setting icon          // Container(          //   width: 40,          //   height: 40,          //   margin: EdgeInsets.all(10),          //   decoration: BoxDecoration(          //     color: Color(0xffD9D9D9),          //     borderRadius: BorderRadius.circular(5),          //   ),          //   child: Center(          //     child: Icon(Icons.settings, color: AppColors.black, size: 20,),          //   ),          // ),        ],      ),      body: StreamBuilder(        stream: FirebaseNotificationController.getNotificationData(),        builder: (context, snapshot) {          if(snapshot.connectionState == ConnectionState.waiting){            return Center(              child: CircularProgressIndicator(),            );          }else if(snapshot.hasData){            return snapshot.data!.docs!.length == 0                ? Center(child: Text("No Notification found"),)                : ListView.builder(                  itemCount: snapshot.data!.docs!.length,                  itemBuilder: (_, index){                    var data = snapshot.data!.docs![index].data();                    return Container(                        padding: EdgeInsets.only(left: 20, right: 20),                        decoration: BoxDecoration(                            color: data["isRead"] ? Colors.white : Colors.grey.shade300                        ),                        child: ListTile(                          onTap: (){                            FirebaseNotificationController.updateNotificationIsRead(id: snapshot.data!.docs![index].id);                          },                          title: Text("${data["title"]}"),                          subtitle: Text("${data["date"]}"),                        )                    );                  },                );          }else {            return Center(              child: Text("No Notification Found"),            );          }        }      )    );  }}