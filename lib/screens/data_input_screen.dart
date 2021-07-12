import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:groundwater_monitoring/components/RoundedButton.dart';
import 'package:groundwater_monitoring/components/customdialog.dart';
import 'package:groundwater_monitoring/constants.dart';
import 'package:groundwater_monitoring/datacontroller/DataInsert.dart';
import 'package:groundwater_monitoring/datacontroller/datafetch.dart';
import 'package:groundwater_monitoring/datacontroller/data.dart';


final nameHolder = TextEditingController();
clearTextInput() {
  nameHolder.clear();
}

class dataInputScreen extends StatefulWidget {
  static String id = 'data_input_screen';

  @override
  _dataInputScreenState createState() => _dataInputScreenState();
}

class _dataInputScreenState extends State<dataInputScreen> {
  String well_id;
  double depth;
  @override
  void initState() {
    super.initState();
    getCurrentUser();// fetch the user so that its phone number can be saved to the cloud.
  }
  @override
  Widget build(BuildContext context) {
    return
        Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // adding drop-down list.
          DropdownSearch<String>(
              mode: Mode.MENU,
              showSelectedItem: true,
              items: kWells,
              onChanged: (value) {
                well_id = value;
              },
              selectedItem: "Well_1"),
          SizedBox(
            height: 28.0,
          ),
          // adding text field so that user can enter depth
          TextField(
              onChanged: (value) {
              bool c=  isNumericUsing_tryParse(value);
              if(c)
                depth = double.parse(value);
              else
                {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => CustomDialog(
                      title: "Error",
                      description: "Enter Valid Data",
                      buttonText: "Okay",
                    ),
                  );
                }
              },
              controller: nameHolder,
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter Depth')),
          SizedBox(
            height: 12.0,
          ),
          // adding save button pressing which data will get uploaded to the cloud.
          RoundedButton(
              onPressed: () async {
                final DateTime datetime = DateTime.now();
                Timestamp timestamp = Timestamp.fromDate(datetime);
                addData(phone:loggedInUser.phoneNumber,timestamp:timestamp, depth:depth,well_id:well_id,context:context);
              },
              colour: Colors.black,
              title: 'Save'),
        ],
      ),
    );
    //  );
  }
  bool isNumericUsing_tryParse(String string) {
    if (string == null || string.isEmpty) {
      return false;
    }
    final number = num.tryParse(string);

    if (number == null) {
      return false;
    }
    return true;
  }// this function will make user to enter only numeric values.
}
