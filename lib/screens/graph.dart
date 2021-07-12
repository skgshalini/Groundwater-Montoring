import 'package:flutter/material.dart';
import 'package:groundwater_monitoring/logic/chart.dart';
import 'package:groundwater_monitoring/datacontroller//data.dart';
import 'package:groundwater_monitoring/datacontroller/datafetch.dart';
import 'package:dropdown_search/dropdown_search.dart';

class Graph extends StatefulWidget {
  @override
  _Graph createState() => _Graph();
}

class _Graph extends State<Graph> {
  MyList m;
  List<String> mon = [];
  List<String> timedate = [];
  List<double> dep = [];
  List<String> year = [];
  String well_id = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.fromLTRB(50, 1, 15, 8),
          // creating drop-down list for selecting well.
          child: DropdownSearch<String>(
              mode: Mode.MENU,
              showSelectedItem: true,
              items: kWells,// giving well ids
              onChanged: (value) async {
                m = MyList();
                well_id = value;
                await m.getData(well_id);// this fuction will fetch all the data related to given well id
                setState(() {
                  mon = m.month;
                  timedate = m.timestamp;
                  dep = m.depth;
                  year = m.year;
                });
                // timedate will be on the x-axis and dep will be on y-axis.
                //mon and year will be used to create sub graphs and our graph is a collection of these sub graphs.
              },
              selectedItem: "Select a well"),
        ),
        Expanded(child: chart(timedate, mon, dep, year)),
        // the chart function will create the graph widget that will be shown in this screen.
      ],
    );
  }
}
