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
    apiKey: 'AIzaSyAlMGIm9ppGYiLYageqkS-rqTfwpbTkUB4',
    appId: '1:691349494771:web:b0be8e51682b9ca501d086',
    messagingSenderId: '691349494771',
    projectId: 'authtest-1ff83',
    authDomain: 'authtest-1ff83.firebaseapp.com',
    storageBucket: 'authtest-1ff83.appspot.com',
    measurementId: 'G-EPE7X7MHM7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJNi3N7DQNqeJmF3mjnlFHYNxxt57I3XE',
    appId: '1:691349494771:android:6c364d838c41d91a01d086',
    messagingSenderId: '691349494771',
    projectId: 'authtest-1ff83',
    storageBucket: 'authtest-1ff83.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC3ER0lRvACtluozXMCzmVcp2CuKM3nDqs',
    appId: '1:691349494771:ios:7376c619525d382801d086',
    messagingSenderId: '691349494771',
    projectId: 'authtest-1ff83',
    storageBucket: 'authtest-1ff83.appspot.com',
    iosBundleId: 'com.ladagranat.tomorrowApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC3ER0lRvACtluozXMCzmVcp2CuKM3nDqs',
    appId: '1:691349494771:ios:7376c619525d382801d086',
    messagingSenderId: '691349494771',
    projectId: 'authtest-1ff83',
    storageBucket: 'authtest-1ff83.appspot.com',
    iosBundleId: 'com.ladagranat.tomorrowApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAlMGIm9ppGYiLYageqkS-rqTfwpbTkUB4',
    appId: '1:691349494771:web:869eb0e1476f980e01d086',
    messagingSenderId: '691349494771',
    projectId: 'authtest-1ff83',
    authDomain: 'authtest-1ff83.firebaseapp.com',
    storageBucket: 'authtest-1ff83.appspot.com',
    measurementId: 'G-0K4HBNDTGT',
  );
}