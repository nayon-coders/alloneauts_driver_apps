import 'package:driver/utilitys/colors.dart';import 'package:driver/view/home/widgets/all_car_home_view.dart';import 'package:flutter/material.dart';class ViewAllCars extends StatefulWidget {  const ViewAllCars({Key? key}) : super(key: key);  @override  State<ViewAllCars> createState() => _ViewAllCarsState();}class _ViewAllCarsState extends State<ViewAllCars> {  final _searchController = TextEditingController();  String? _searchValue = "";  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =  GlobalKey<RefreshIndicatorState>();  @override  Widget build(BuildContext context) {    var size = MediaQuery.of(context).size;    return Scaffold(      appBar: AppBar(        backgroundColor: Color(0xffF3F3F3),        elevation: 0,        title: const Text("View All Car",          style: TextStyle(              color: AppColors.black,              fontSize: 19          ),        ),        leading: InkWell(            onTap: ()=>Navigator.pop(context),            child: Container(              width: 40,              height: 40,              margin: EdgeInsets.all(10),              decoration: BoxDecoration(                color: Color(0xffD9D9D9),                borderRadius: BorderRadius.circular(5),              ),              child: Center(                child: Icon(Icons.arrow_back, color: AppColors.black, size: 20,),              ),            )),        bottom: PreferredSize(          preferredSize: Size.fromHeight(60),          child: Container(              margin: EdgeInsets.only(left: 15, right: 15),              child: Row(                children: [                  Expanded(child: TextFormField(                    controller: _searchController,                    onChanged: (v){                      setState(() {                        _searchValue = v;                      });                    },                    decoration: InputDecoration(                        hintText: "Search your dream car",                        hintStyle: TextStyle(                            fontWeight: FontWeight.w400,                            color: Colors.grey,                            fontSize: 13                        ),                        fillColor: AppColors.white,                        filled: true,                        contentPadding: EdgeInsets.only(left: 10, right: 10),                        border: OutlineInputBorder(                            borderRadius: BorderRadius.circular(100),                            borderSide: BorderSide(width: 1, color: AppColors.grey200)                        ),                        enabledBorder: OutlineInputBorder(                            borderRadius: BorderRadius.circular(100),                            borderSide: BorderSide(width: 1, color: AppColors.grey200)                        ),                        focusedBorder: OutlineInputBorder(                            borderRadius: BorderRadius.circular(100),                            borderSide: BorderSide(width: 1, color: AppColors.grey200)                        ),                        prefixIcon: Icon(Icons.search, color: AppColors.grey200, size: 20,),                      suffixIcon: InkWell(                        onTap: (){                          _searchController.clear();                          setState(() {                            _searchValue = "";                          });                        },                        child: Icon(Icons.clear, color: AppColors.grey200, size: 20,),                    ),                  )                  )              ),                  SizedBox(width: 10,),                  InkWell(                    onTap: ()=>showFilterDialog(context),                    child: Container(                      width: 50,                      height: 50,                      decoration: BoxDecoration(                        color: AppColors.black,                        borderRadius: BorderRadius.circular(100),                      ),                      child: Center(                          child: Icon(Icons.filter_list_outlined, color: AppColors.white, size: 30,)                      ),                    ),                  )                ],              )          ),        )      ),      body: RefreshIndicator(          key: _refreshIndicatorKey,          color: Colors.white,          backgroundColor: Colors.blue,          strokeWidth: 4.0,          onRefresh: () async {            setState(() {});          },          child: Container(        width: size.width,        height: size.height,        padding: EdgeInsets.all(20),        child: SingleChildScrollView(          child: Column(            mainAxisAlignment: MainAxisAlignment.start,            crossAxisAlignment: CrossAxisAlignment.start,            children: [              AllCarHomeView(view: "All", searchValue: _searchValue,)            ],          ),        ),      )),    );  }  showFilterDialog(BuildContext context) {    showModalBottomSheet(        shape: RoundedRectangleBorder(          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),        ),        context: context,        builder: (context) {          return const Center(child: Text("Filter coming soon..."),);          // return Container(          //     padding: EdgeInsets.all(20),          //     child: Column(          //       mainAxisAlignment: MainAxisAlignment.start,          //   crossAxisAlignment: CrossAxisAlignment.start,          //   mainAxisSize: MainAxisSize.min,          //   children: <Widget>[          //     Text("Filter",          //       style: TextStyle(          //           fontSize: 20,          //           fontWeight: FontWeight.w600,          //           color: AppColors.black          //       ),          //     ),          //     ListTile(          //       leading: new Icon(Icons.photo),          //       title: new Text('Photo'),          //       onTap: () {          //         Navigator.pop(context);          //       },          //     ),          //     ListTile(          //       leading: new Icon(Icons.music_note),          //       title: new Text('Music'),          //       onTap: () {          //         Navigator.pop(context);          //       },          //     ),          //     ListTile(          //       leading: new Icon(Icons.videocam),          //       title: new Text('Video'),          //       onTap: () {          //         Navigator.pop(context);          //       },          //     ),          //     ListTile(          //       leading: new Icon(Icons.share),          //       title: new Text('Share'),          //       onTap: () {          //         Navigator.pop(context);          //       },          //     ),          //   ],          // ));        }        );  }}