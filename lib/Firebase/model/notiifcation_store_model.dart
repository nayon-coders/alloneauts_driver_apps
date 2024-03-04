class NotificationStoreModel{

  final String id;
  final String title;
  final String driverMessages;
  final String vendorMessages;
  final String driverEmail;
  final String vendorEmail;
  final String date;
  final bool isRead;

  NotificationStoreModel( {
    required this.id,
    required this.title,
    required this.date,
    required this.driverMessages,
    required this.vendorMessages,
    required this.driverEmail,
    required this.vendorEmail,
    required this.isRead
  });



  factory NotificationStoreModel.fromJson(Map<String, dynamic> json){
    return NotificationStoreModel(
      id: json["id"],
      title: json["title"],
      date: json["date"],
      driverMessages: json["driverMessages"],
      vendorMessages: json["vendorMessages"],
      driverEmail:  json["driverEmail"],
      vendorEmail: json["vendorEmail"],
      isRead: json["isRead"]
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "date": date,
    "driverMessages": driverMessages,
    "vendorMessages": vendorMessages,
    "driverEmail": driverEmail,
    "vendorEmail": vendorEmail,
    "isRead": isRead
  };

}