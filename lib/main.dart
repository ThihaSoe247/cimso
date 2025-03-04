
import 'package:cimso_heckathon/screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Membership App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: RegisterPage(), // Login page as the initial screen
    );
  }
}
