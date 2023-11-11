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
    apiKey: 'AIzaSyCieqqLojuuzAWLoLtIT69syTp2jxjQ9rM',
    appId: '1:656529199031:web:f6215f3694a90c6346e232',
    messagingSenderId: '656529199031',
    projectId: 'elevar-9f8b3',
    authDomain: 'elevar-9f8b3.firebaseapp.com',
    storageBucket: 'elevar-9f8b3.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCYURen2KyS4ylJQG7bP83ipbKkQ7X3wAg',
    appId: '1:656529199031:android:1aeeac758699564b46e232',
    messagingSenderId: '656529199031',
    projectId: 'elevar-9f8b3',
    storageBucket: 'elevar-9f8b3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCU6bY29KVfCzWZEVyfYkP0OLHlKtKklTc',
    appId: '1:656529199031:ios:ae83611cbd8cfbd846e232',
    messagingSenderId: '656529199031',
    projectId: 'elevar-9f8b3',
    storageBucket: 'elevar-9f8b3.appspot.com',
    iosBundleId: 'com.example.elevarFitnessTracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCU6bY29KVfCzWZEVyfYkP0OLHlKtKklTc',
    appId: '1:656529199031:ios:c140a795648c4e5e46e232',
    messagingSenderId: '656529199031',
    projectId: 'elevar-9f8b3',
    storageBucket: 'elevar-9f8b3.appspot.com',
    iosBundleId: 'com.example.elevarFitnessTracker.RunnerTests',
  );
}