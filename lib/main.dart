import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:h3devs/firebase_options.dart';
import 'package:h3devs/homePage/homePage.dart';

import 'package:h3devs/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'City Loads',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}
