import 'package:firebase_auth/firebase_auth.dart';
import 'package:groundwater_monitoring/components/RoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:groundwater_monitoring/screens/login_screen.dart';
import 'NavigationPage.dart';

class WelcomeScreen extends StatefulWidget {
  // creating WelcomeScreen as stateful widget its state can be changed by user interaction.
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  child: Image.asset('images/water.png'),
                  // Image. asset() function add image from the given path to our widget tree as a widget.
                  height: 100.0,
                ),
                TextLiquidFill(
                  text: 'Groundwater Monitoring',
                  textStyle: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                // TextliquidFill is an animation the text defined under this function will be animated.
              ],
            ),
            SizedBox(
              height: 15,
            ),
            // SizeBox is used to give space between two widgets.
            RoundedButton(
                onPressed: () {
                  FirebaseAuth.instance.currentUser().then((user) {
                    if (user != null) {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, NavigationScreen.id);
                    } else
                      Navigator.pushNamed(context, LoginScreen.id);
                  });//checking if the user exists already.
                  //if he exists redirecting him to homeScreen.
                  // if not will be redirected to login screen.
                },
                colour: Colors.black,
                title: 'Log In'),
          ],
        ),
        // All the widgets under column widgets will be aligned in a vertical position.
      ),
    );
    //Scaffold is used under MaterialApp, it gives you many basic functionalities, like AppBar, BottomNavigationBar,
    // Drawer, FloatingActionButton etc.
  }
}
