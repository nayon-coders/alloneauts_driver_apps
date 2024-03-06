import 'package:flutter/material.dart';


appLoading(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(
              width: 20,
            ),
            Text("Loading..."),
          ],
        ),
      );
    },
  );
}