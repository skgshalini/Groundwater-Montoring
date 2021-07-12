import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
class chart extends StatelessWidget {
  List<String> mon;
  List<String> timedate;
  List<double> dep;
  List<String> year;
  List<BarSeries> cs = [];
  List<Graphdata> g = [];
  chart(this.timedate, this.mon, this.dep,this.year);
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBackgroundColor: Colors.black,
      legend: Legend(isVisible: true),// will able and disable sub graphs
      series: chartseries(mon, timedate, dep,year),// taking collection of sub graphs as input
      primaryXAxis: CategoryAxis(isVisible: false),
      primaryYAxis: NumericAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          numberFormat: NumberFormat.decimalPattern(),
          title: AxisTitle(
              text: 'Depth in meters of the well',
              textStyle: TextStyle(fontSize: 10))),
      isTransposed: true,
      tooltipBehavior: TooltipBehavior(enable: true),// tapping on the  bars data in details will be shown
    );
  } // this function will create the whole graph

    BarSeries<Graphdata, String> bar({String name, List<Graphdata> dataSource}) {
      return BarSeries<Graphdata, String>(
          name: name,// gives subgraph a name.
          dataSource: dataSource,// collection of objects(bars in a subgraph) . objects will have fields for x-axis value
                                 // and y-axis value.
          xValueMapper: (Graphdata gd, _) => gd.timestamp,
          yValueMapper: (Graphdata gd, _) => gd.depth,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          enableTooltip: true,
          legendIconType: LegendIconType.rectangle);
    }// this fuction will create a subgraph
    List<ChartSeries> chartseries(
        List<String> mon, List<String> timedate, List<double> dep,List<String> year) {
      if (mon.length != 0) {
        String c = mon.elementAt(0);
        int i = 0;
        for (String v in mon) {// until all the data of specific well is not get processed
          if (v.compareTo(c) != 0) { // if the month changes it means a sub graph is finished we will add
            // this sub graph to the collection of sub grgh
            cs.add(bar(name: mon[i - 1]+' '+year[i-1], dataSource: g));
            g = [];
            g.add(Graphdata(dep[i], timedate[i]));
            i++;
            c = mon[i - 1];} else {
            g.add(Graphdata(dep[i], timedate[i]));
            i++;}}// if the month is same keep creating a sub graph.
      cs.add(bar(name: mon[i - 1]+' '+year[i-1], dataSource: g)); //at the end when one subgraph is left add it to the collection
    }
    return cs;}
}
class Graphdata {
  Graphdata(this.depth, this.timestamp);
  final String timestamp;
  final double depth;
}
