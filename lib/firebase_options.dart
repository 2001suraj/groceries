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
    apiKey: 'AIzaSyA_j5eRgp7D910_tVU3rvTUkNkqdIpMguU',
    appId: '1:163711249679:web:5684cb295636580058a27a',
    messagingSenderId: '163711249679',
    projectId: 'groceries-f9edc',
    authDomain: 'groceries-f9edc.firebaseapp.com',
    storageBucket: 'groceries-f9edc.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDp1-7HcSHBIZNalcSKJHXLf8s-CSgCD-4',
    appId: '1:163711249679:android:e7e42d3f7074952b58a27a',
    messagingSenderId: '163711249679',
    projectId: 'groceries-f9edc',
    storageBucket: 'groceries-f9edc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDu1EIsDPnZkh9iX7Z3CjKygmTQnLbNQ_g',
    appId: '1:163711249679:ios:4dbbe68c7704d4a358a27a',
    messagingSenderId: '163711249679',
    projectId: 'groceries-f9edc',
    storageBucket: 'groceries-f9edc.appspot.com',
    iosBundleId: 'com.example.groceries',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDu1EIsDPnZkh9iX7Z3CjKygmTQnLbNQ_g',
    appId: '1:163711249679:ios:dcbf4b3f98bad30658a27a',
    messagingSenderId: '163711249679',
    projectId: 'groceries-f9edc',
    storageBucket: 'groceries-f9edc.appspot.com',
    iosBundleId: 'com.example.groceries.RunnerTests',
  );
}
