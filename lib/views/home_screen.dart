import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth/views/login_screens.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.logout),
        onPressed: () async {
          await _auth.signOut();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LoginScreen(),
            ),
          );
        },
      ),
      body: Center(
        child: Text("Home Screen"),
      ),
    );
  }
}
