import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groundwater_monitoring/components/RoundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groundwater_monitoring/components/customdialog.dart';
import '../constants.dart';
import 'NavigationPage.dart';
import 'package:connectivity/connectivity.dart';
Future<bool> check() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}// This function checks if mobile internet or wifi is available

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_STATE,
}// named constant

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';// for navigation with named roots

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId;
  bool showLoading = false;
  String phoneNo;
  String smsOTP;
  String errorMessage = '';
  FocusNode focusNode = FocusNode();
  String hintText = 'Enter phone number';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        hintText = '';
      }
      setState(() {});
    });// focusnode to control a textfield content when it has focus or it has lost the focus.
  }

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      setState(() {
        showLoading = false;
        currentState = MobileVerificationState.SHOW_OTP_STATE;
      });// when the code is sent the current screen will get modified to OTP screen.
    };//Get called when the OTP will be successfully sent to user's phone.
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo,
          codeAutoRetrievalTimeout: (String verId) {
            this.verificationId = verId;
          },// Tries to automatically fetch the OTP for the given amount of time.
          codeSent: smsOTPSent,
          timeout: const Duration(seconds: 0),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },// Called when OTP verification gets completed.
          verificationFailed: (AuthException exceptio) {
            print('{$exceptio.message}');
          });// Called when OTP verification gets failed.
    } catch (e) {
      handleError(e);
    }
  }

  handleError(error) {
    Navigator.of(context).pop();
    print(error);
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: "Error",
        description: error.message,
        buttonText: "Okay",
      ),
    );
  }// This function tries to authenticate user with the help of phone number and OTP
  // If successful homescreen will be shown
  // If not proper error message will be shown

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      Navigator.of(context).pop();
      Navigator.pushNamed(context, NavigationScreen.id);
    } on PlatformException catch (err) {
      // Handle err
      handleError(err);
    } catch (e) {
      handleError(e);
    }
  } // This function matches entered otp, verification id generated at the time when OTP was sent belongs to user and also
  // it with the current user if everything is fine user will be redirected to the homescreen or a proper error message will
  // be shown.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: showLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: currentState ==
                        MobileVerificationState.SHOW_MOBILE_FORM_STATE
                    ? getMobileFormWidget(context)
                    : getOtpFormWidget(context)),
      ),
    );
  }// Displays the current screen as phone number fetching screen or OTP screen depending on the value of current state.

  getMobileFormWidget(context) {
    return <Widget>[
      Column(
        children: [
          Container(
            height: 150,
            child: Image.asset('images/water.png'),
          ),
          TextField(
            focusNode: focusNode,
            onChanged: (value) {
              phoneNo = '+91' + value;
              bool chk=validatePhoneNo(value);
              if(chk) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      CustomDialog(
                        title: "Error",
                        description: "Enter Valid Phone Number",
                        buttonText: "Okay",
                      ),
                );// if phoneNo is not valid error message will be shown.
              }
            },
            decoration: kTextFieldDecoration.copyWith(
                hintText: hintText, prefixText: '+91'),
          ),
          RoundedButton(
              onPressed: () async {
                print(phoneNo);
                setState(() {
                  showLoading = true;
                });
                check().then((internet) {
                  if (internet != null && internet) {
                    verifyPhone();
                  }// if there is an internet connect phoneverification takes place
                  else{
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomDialog(
                        title: "Error",
                        description: "No internet",
                        buttonText: "Okay",
                      ),
                    );
                  }//no internet error message will be shown
                  // No-Internet Case
                });

              },
              colour: Colors.black,
              title: 'Send'),
        ],
      ),
    ];
  }// This function will render the screen to take phone number from the user.

  getOtpFormWidget(context) {
    return <Widget>[
      Column(
        children: [
          Container(
            height: 150,
            child: Image.asset('images/water.png'),
          ),
          TextField(
            onChanged: (value) {
              smsOTP = value;
            },
            decoration:
                kTextFieldDecoration.copyWith(hintText: 'Enter the OTP'),
          ),
          RoundedButton(
              onPressed: () async {
                setState(() {
                  showLoading = true;
                });

                signIn();
              },
              colour: Colors.black,
              title: 'Verify'),
        ],
      ),
    ];
  }// This function will render the screen to take OTP from the user.
bool validatePhoneNo(value){
   if(double.tryParse(value) == null)
    return false;
  return true;
}
}// checking if the entered phone number is valid or not.
