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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // TODO: Replace with your actual Firebase Web configuration options
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBUXgG1S8gv8uRAIfO0fjIxnEfzBgmxvxY',
    appId: 'YOUR-WEB-APP-ID',
    messagingSenderId: 'YOUR-SENDER-ID',
    projectId: 'YOUR-PROJECT-ID',
    authDomain: 'YOUR-PROJECT-ID.firebaseapp.com',
    databaseURL:
        'https://apb-tugas-766a4-default-rtdb.asia-southeast1.firebasedatabase.app/',
    storageBucket: 'YOUR-PROJECT-ID.appspot.com',
  );

  // TODO: Replace with your actual Firebase Android configuration options
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUXgG1S8gv8uRAIfO0fjIxnEfzBgmxvxY',
    appId: 'YOUR-ANDROID-APP-ID',
    messagingSenderId: '',
    projectId: '',
    databaseURL: 'https://your-project-id-default-rtdb.firebaseio.com',
    storageBucket: 'YOUR-PROJECT-ID.appspot.com',
  );

  // TODO: Replace with your actual Firebase iOS configuration options
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR-IOS-API-KEY',
    appId: 'YOUR-IOS-APP-ID',
    messagingSenderId: 'YOUR-SENDER-ID',
    projectId: 'YOUR-PROJECT-ID',
    databaseURL: 'https://your-project-id-default-rtdb.firebaseio.com',
    storageBucket: 'YOUR-PROJECT-ID.appspot.com',
    iosBundleId: 'com.example.untitled',
  );
}
