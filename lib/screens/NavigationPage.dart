import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groundwater_monitoring/screens/Profile.dart';
import 'package:groundwater_monitoring/screens/welcome_screen.dart';
import 'data_input_screen.dart';
import 'graph.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:groundwater_monitoring/datacontroller/datafetch.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
const _url = 'http://rutag.iitd.ac.in/rutag/?q=ground-water-level-measuring-device';
enum NavigationState {
  HOME,
  GRAPH,
  PROFILE,
}
NavigationState currentstate = NavigationState.HOME;
class NavigationScreen extends StatefulWidget {
  static String id = 'navigation_screen';
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

void _launchURL() async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  String phone;

  void initState() {
    // TODO: implement initState
   getCurrentUser();//As the page gets loaded, fetch the current user so that its phone number can be passed to profile page.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Groundwater Monitoring"),
        backgroundColor: Colors.black,
      ),
      //below is the code for adding side navigation bar
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: SafeArea(
          child: Container(
            color: Colors.black,
            child: ListView(
              // Important: Remove any padding from the ListView.
              //listview is used to contain collection of things
              // here we will add two options about and logout using tiles and give them functionality.
              padding: EdgeInsets.zero,

              children: <Widget>[
                Container(
                  height: 60,
                  padding: EdgeInsets.fromLTRB(8, 15, 8, 8),
                  child: Text(
                    'Groundwater Monitoring',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.purple,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(height: 0, thickness: 1, color: Colors.purple),
                ListTile(
                  title: Text(
                    'About',
                    style: TextStyle(fontSize: 18, color: Colors.purple),
                  ),

                  onTap: _launchURL,//will take the user to RuTAG website
                  // Update the state of the app.
                  // ...
                ),
                Divider(height: 0, thickness: 1, color: Colors.purple),
                ListTile(
                  title: Text('Logout',
                      style: TextStyle(fontSize: 18, color: Colors.purple)),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                    Future<void> _signOut() async {
                      await FirebaseAuth.instance.signOut();//will logout the user from firebase
                    }

                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, WelcomeScreen.id);
                    // will redirect the user to welcomescreen as a result of logging out
                  },
                ),
                Divider(height: 0, thickness: 1, color: Colors.purple),
              ],
            ),
          ),
        ),
      ),
      //backgroundColor: Colors.blueAccent,
      body: SafeArea(
          child: Column(children: <Widget>[
          GNav(
            // GNav will add Navigation buttons at the top of the screen.
//rippleColor: Colors.grey[800],
          rippleColor: Colors.white,
              backgroundColor: Colors.black,
//  hoverColor: Colors.grey[700],
              hoverColor: Colors.blueAccent,
              haptic: true, // haptic feedback
              tabBorderRadius: 15,
              tabActiveBorder: Border.all(
                  color: Colors.blueAccent, width: 1), // tab button border
              tabBorder: Border.all(
                  color: Colors.blueAccent, width: 1), // tab button border
              tabShadow: [
                BoxShadow(color: Colors.purple.withOpacity(0.5), blurRadius: 8)
              ], // tab button shadow
              curve: Curves.easeOutExpo, // tab animation curves
              duration: Duration(milliseconds: 900), // tab animation duration
              gap: 8, // the tab button gap between icon and text
              color: Colors.purple, // unselected icon color
              activeColor: Colors.white, // selected icon and text color
              iconSize: 30, // tab button icon size
              tabBackgroundColor: Colors.blueAccent
                  .withOpacity(0.1), // selected tab background color
              padding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: 5), // navigation bar padding
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                  onPressed: () {
                    setState(() {
                      currentstate = NavigationState.HOME;
                    });
                  },
                ),
                GButton(
                  icon: Icons.add_chart,
                  text: 'Graphs',
                  onPressed: () {
                    setState(() {
                      currentstate = NavigationState.GRAPH;
                    });
                  },
                ),
                GButton(
                  icon: Icons.account_circle,
                  text: 'Profile',
                  onPressed: () {
                    phone= loggedInUser.phoneNumber;
                    setState(() {
                      currentstate = NavigationState.PROFILE;
                    });
                  },
                ),
              ])


          ,
        Expanded(
            child: currentstate == NavigationState.HOME
                ? dataInputScreen()
                : currentstate == NavigationState.GRAPH
                    ? Graph()
                    : Profile(phone))
      ])),
      // The screen will render as dataInput screen or graph or profile screen depending on the value of current state.
    );
    }
  }

