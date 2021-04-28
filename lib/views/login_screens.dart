import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth/views/home_screen.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  FirebaseAuth _auth = FirebaseAuth.instance;

  String verificationId;
  bool loading = false;
  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      loading = true;
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        loading = false;
      });
      if (authCredential?.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    }
  }

  getMobileFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        Padding(
          padding: EdgeInsets.all(14),
          child: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Phone Number",
            ),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            setState(() {
              loading = true;
            });
            await _auth.verifyPhoneNumber(
              phoneNumber: phoneController.text,
              verificationCompleted: (phoneAuthCredential) async {
                setState(() {
                  loading = false;
                });
                //---------auto verification code filup---------------//
                // signInWithPhoneAuthCredential(phoneAuthCredential);
                //---------auto verification code filup---------------//
              },
              verificationFailed: (verificationFailed) async {
                setState(() {
                  loading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(verificationFailed.message),
                  ),
                );
              },
              codeSent: (verificationId, resendingToken) async {
                setState(() {
                  loading = false;
                  currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                  this.verificationId = verificationId;
                });
              },
              codeAutoRetrievalTimeout: (verificationId) async {},
            );
          },
          child: Text("Send"),
        ),
        Spacer(),
      ],
    );
  }

  getOTPFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        Padding(
          padding: EdgeInsets.all(14),
          child: TextField(
            controller: otpController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "Enter OTP",
            ),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(
              verificationId: verificationId,
              smsCode: otpController.text,
            );
            signInWithPhoneAuthCredential(phoneAuthCredential);
          },
          child: Text("Veryfiy"),
        ),
        SizedBox(height: 16),
        Spacer(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: (loading)
            ? Center(child: CircularProgressIndicator())
            : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                ? getMobileFormWidget(context)
                : getOTPFormWidget(context),
      ),
    );
  }
}
