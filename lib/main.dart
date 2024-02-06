import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:h3devs/firebase_options.dart';
import 'package:h3devs/homePage/homePage.dart';
import 'package:h3devs/login.dart';
import 'package:h3devs/register.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'City Loads',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
<<<<<<< HEAD
      home: Login(),
=======
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasData) {
              return const MyHomePage();
            } else {
              return const Login();
            }
          }
        },
      ),
>>>>>>> 4f165e1a3477a14d9468b7009725dc0a201f06b9
    );
  }
}
