import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
final _firestore = Firestore.instance;
String pn;
Map<int,String> mon={1:'JAN',2:'FEB',3:'MAR',4:'APR',5:'MAY',6:'JUN',
  7:'JUL',8:'AUG',9:'SEP',10:'OCT',11:'NOV',12:'DEC'};
var format;
FirebaseUser loggedInUser;
final _auth = FirebaseAuth.instance;
void getCurrentUser() async {
  try {
    final user = await _auth.currentUser();
    if (user != null) {
      loggedInUser = user;
    }
  } catch (e) {
    print(e);
  }
}
class MyList {
List<double> depth= [];
List<String> month=[];
List<String> timestamp=[];
List<String> year=[];
Future getData(String well_id) async{
  final data =await _firestore.collection('data').where('well_no', isEqualTo: '$well_id').orderBy('timestamp').getDocuments();
  for(var data in data.documents){
    depth.add(double.parse((data.data['depth']).toString()));
    format = new DateFormat('dd-MM-yyyy\nhh:mm a'); // 'hh:mm' for hour & min
    month.add(mon[data.data['timestamp'].toDate().month]);
    year.add((data.data['timestamp'].toDate().year).toString());
     timestamp.add(format.format(data.data['timestamp'].toDate()));// converting the timestamp to more readable format.
  }
}//fetching all the data of particular well id and storing it to the lists.
}
