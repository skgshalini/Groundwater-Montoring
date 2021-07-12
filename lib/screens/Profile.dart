import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  String phone;

  Profile(this.phone);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 150.0,
            height: 150.0,
            decoration: BoxDecoration(
                color: Colors.purple,
                image: DecorationImage(
                    image: NetworkImage(
                        'https://image.flaticon.com/icons/png/512/64/64572.png'),
                    fit: BoxFit.cover),
                // images will be fetched from the internet and will be shown as profile pic.
                borderRadius: BorderRadius.all(Radius.circular(75.0)),
                //borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(blurRadius: 8.0, color: Colors.purpleAccent)
                ]),
          ),
          SizedBox(
            height: 15,
          ),
          Center(
            child: new Text(
              phone,
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            // user's phone number will be displayed.
          ),
        ],
      ),
    );
  }
}
