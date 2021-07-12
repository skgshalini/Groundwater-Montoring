import 'package:flutter/material.dart';
import 'package:groundwater_monitoring/screens/NavigationPage.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/NavigationPage.dart';

Future<void> main() async {
  runApp(GroundwaterMonitoring());
  //runApp takes a widget here it is taking GroundwaterMonitoring widget and will make it root of the widget tree.
}//main function is the entry point of the application, execution will start from here.

class GroundwaterMonitoring extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        NavigationScreen.id: (context) => NavigationScreen(),
      }//Named Routes is the simplest way to navigate to the different screens using naming concepts. When a user
      // needs multiple screens in an app depending on its need then we have to navigate from one screen to another
      // and also return back many times back on the previous screen
        //we use a naming concept so as to remember screens with its name provided by the user and then we can
      // directly access that route or page directly through Navigator.pushNamed() method.
    );
    //MaterialApp is the starting point of our app, it tells Flutter that we are going to use Material components
    // and follow material design in our app.
  }
}
