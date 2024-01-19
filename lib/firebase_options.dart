// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDnIpmoNSTZMVAdDdz9HRxefWn0aVcEbqI',
    appId: '1:377007798374:web:772e90538aceee031095a7',
    messagingSenderId: '377007798374',
    projectId: 'cityloads-301009',
    authDomain: 'cityloads-301009.firebaseapp.com',
    storageBucket: 'cityloads-301009.appspot.com',
    measurementId: 'G-0M687ZD5XE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCzstL4Uag6Uu-KJtoo8ZQmx-okRFyvHfE',
    appId: '1:377007798374:android:dc0d4ba5f2e2e0821095a7',
    messagingSenderId: '377007798374',
    projectId: 'cityloads-301009',
    storageBucket: 'cityloads-301009.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDqy_aZnvcHYqOxes-ZsylOWnCWalBTYS0',
    appId: '1:377007798374:ios:8c6dee1e556d23231095a7',
    messagingSenderId: '377007798374',
    projectId: 'cityloads-301009',
    storageBucket: 'cityloads-301009.appspot.com',
    androidClientId: '377007798374-5kllqrokb99b01mp61vtafa3mtsldpac.apps.googleusercontent.com',
    iosClientId: '377007798374-8var81fc6pl3sblebdrgusprdbc2fir3.apps.googleusercontent.com',
    iosBundleId: 'com.example.h3devs',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDqy_aZnvcHYqOxes-ZsylOWnCWalBTYS0',
    appId: '1:377007798374:ios:481aac3fb67ab7ef1095a7',
    messagingSenderId: '377007798374',
    projectId: 'cityloads-301009',
    storageBucket: 'cityloads-301009.appspot.com',
    androidClientId: '377007798374-5kllqrokb99b01mp61vtafa3mtsldpac.apps.googleusercontent.com',
    iosClientId: '377007798374-0p3954tjg8gct7gpsoklqu8ih94gotdj.apps.googleusercontent.com',
    iosBundleId: 'com.example.h3devs.RunnerTests',
  );
}
