import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogoutPage extends StatefulWidget {
  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  String uid = '';
  getUid() {}
  @override
  void initState() {
    this.uid = '';
    try {
      var user = FirebaseAuth.instance.currentUser;
      setState(() {
        this.uid = user.uid;
      });
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Logout Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('You are now Logged In as:\n\n$uid')),
          SizedBox(height: 20.0),
          OutlineButton(
            borderSide: BorderSide(
              color: Colors.red,
              style: BorderStyle.solid,
              width: 3.0,
            ),
            child: Text('Logout'),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((action) {
                Navigator.pushReplacementNamed(context, '/Login');
              }).catchError((e) {
                print(e);
              });
            },
          )
        ],
      ),
    );
  }
}
