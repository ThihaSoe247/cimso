// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBz5kaSp9Z4BfrYPlpj84pP1shpXDAm8WY',
    appId: '1:925103976600:web:9a5f836c2732df5a0c60ed',
    messagingSenderId: '925103976600',
    projectId: 'membership-cimso',
    authDomain: 'membership-cimso.firebaseapp.com',
    storageBucket: 'membership-cimso.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDS-Y_Y_pxb9DwHnVvBu4BGJO27pItJOM0',
    appId: '1:925103976600:android:1b0346cd31f786bf0c60ed',
    messagingSenderId: '925103976600',
    projectId: 'membership-cimso',
    storageBucket: 'membership-cimso.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDwUZg8L-0nMTVL7lybGem9HjqkmQguJkQ',
    appId: '1:925103976600:ios:d5eb5ad6220fc6560c60ed',
    messagingSenderId: '925103976600',
    projectId: 'membership-cimso',
    storageBucket: 'membership-cimso.firebasestorage.app',
    iosBundleId: 'com.example.cimsoHeckathon',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDwUZg8L-0nMTVL7lybGem9HjqkmQguJkQ',
    appId: '1:925103976600:ios:d5eb5ad6220fc6560c60ed',
    messagingSenderId: '925103976600',
    projectId: 'membership-cimso',
    storageBucket: 'membership-cimso.firebasestorage.app',
    iosBundleId: 'com.example.cimsoHeckathon',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBz5kaSp9Z4BfrYPlpj84pP1shpXDAm8WY',
    appId: '1:925103976600:web:b71f6e0ce2a41e510c60ed',
    messagingSenderId: '925103976600',
    projectId: 'membership-cimso',
    authDomain: 'membership-cimso.firebaseapp.com',
    storageBucket: 'membership-cimso.firebasestorage.app',
  );
}
