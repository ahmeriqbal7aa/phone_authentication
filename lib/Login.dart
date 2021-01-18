import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginInPage extends StatefulWidget {
  @override
  _LoginInPageState createState() => _LoginInPageState();
}

class _LoginInPageState extends State<LoginInPage> {
  String phoneNo;
  String smsSent;
  String verificationID;

  // TODO Create Verify Phone Function
  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verID) {
      this.verificationID = verID;
    };
    final PhoneCodeSent smsCodeSent = (String verID, [int forceCodeResend]) {
      this.verificationID = verID;
      // after code sent, we call smsCodeDialog() method
      smsCodeDialog(context).then((value) {
        print('Code Sent');
      });
    };
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential auth) {
      print('Verification Complete');
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      print('Verification Failed');
      print('${e.message}');
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: this.phoneNo,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrievalTimeout,
    );
  }

  // TODO Create SMS Code Dialog Function
  Future<bool> smsCodeDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter SMS Code'),
          content: TextField(
            onChanged: (value) {
              this.smsSent = value;
            },
          ),
          contentPadding: EdgeInsets.all(10.0),
          actions: [
            RaisedButton(
              onPressed: () {
                var user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/Logout');
                } else {
                  Navigator.of(context).pop();
                  // here signIn() method will be called
                  signIn(smsSent);
                }
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  //TODO Create Sign In Function
  Future<void> signIn(String smsCode) async {
    // FirebaseAuth.instance.signInWithPhoneNumber(phoneNo).then((user) {
    //   Navigator.pushReplacementNamed(context, '/LoginPage');
    // }).catchError((e) {
    //   print(e);
    // });
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationID,
      smsCode: smsCode,
    );
    await FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      Navigator.pushReplacementNamed(context, '/LogoutPage');
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Phone Authentication',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            SizedBox(height: 40.0),
            Text('Format: [+][country code][subscriber number]'),
            SizedBox(height: 40.0),
            TextField(
              cursorColor: Colors.black,
              style: TextStyle(fontSize: 18.0, color: Colors.black),
              maxLength: 13,
              onChanged: (value) {
                this.phoneNo = value;
              },
              decoration: InputDecoration(
                fillColor: Colors.orange.withOpacity(0.1),
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                labelText: 'Phone Number',
                labelStyle: TextStyle(
                  fontSize: 16.0,
                ),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              onPressed: verifyPhone,
              color: Colors.orangeAccent,
              child: Text('Verify', style: TextStyle(fontSize: 17.0)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
            ),
          ],
        ),
      ),
    );
  }
}
