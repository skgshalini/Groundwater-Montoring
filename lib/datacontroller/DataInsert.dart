import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groundwater_monitoring/components/customdialog.dart';
import 'package:groundwater_monitoring/logic/location.dart';
import 'package:groundwater_monitoring/screens/data_input_screen.dart';
final _firestore = Firestore.instance;
Location l=  Location();
addData({phone:String,timestamp:Timestamp,depth:double,well_id:String,context:BuildContext}) async {
  await l.getCurrentLocation();
  await _firestore.collection('data').add({
    'phone': phone,
    'timestamp': timestamp,
    'depth': depth,
    'well_no': well_id,
    'latitude':l.latitude.toString(),
    'longitude':l.longitude.toString()
  }).then((result) {
    nameHolder.clear();
    print("Success!");
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: "Success",
        description: "Data uploaded successfully!",
        buttonText: "Okay",
      ),
    );
  }).catchError((error) {
    print("Error!");
  });
} // uploading the data to the cloud if data gets uploaded successfully success message will be shown
// otherwise error message will be shown.