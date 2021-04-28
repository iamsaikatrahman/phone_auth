import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth/views/home_screen.dart';
import 'package:phone_auth/views/login_screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phone Authentication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InitializWidget(),
    );
  }
}

class InitializWidget extends StatefulWidget {
  @override
  _InitializWidgetState createState() => _InitializWidgetState();
}

class _InitializWidgetState extends State<InitializWidget> {
  FirebaseAuth _auth;
  User _user;
  bool isLoading = true;
  @override
  void initState() {
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : _user == null
            ? LoginScreen()
            : HomeScreen();
  }
}
