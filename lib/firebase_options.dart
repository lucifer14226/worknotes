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
    apiKey: 'AIzaSyBJqGlPaCbZQuFD7OUw5cupZnp9FXxv0fw',
    appId: '1:750278780765:web:0f115b2f83433de1f1aab4',
    messagingSenderId: '750278780765',
    projectId: 'worknotes-flutter-project',
    authDomain: 'worknotes-flutter-project.firebaseapp.com',
    storageBucket: 'worknotes-flutter-project.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCL0ewlf0Cj5iGSdXIz7loUKBh3Dim5NGY',
    appId: '1:750278780765:android:03c2eb7c3a5324fbf1aab4',
    messagingSenderId: '750278780765',
    projectId: 'worknotes-flutter-project',
    storageBucket: 'worknotes-flutter-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB4tn0zHoJFS_wi9cVbNrJ8sCX4Z_k3dvM',
    appId: '1:750278780765:ios:42550894b918bc78f1aab4',
    messagingSenderId: '750278780765',
    projectId: 'worknotes-flutter-project',
    storageBucket: 'worknotes-flutter-project.appspot.com',
    iosClientId: '750278780765-qabc0mhgs3mqgihjttpn58t6acdrcq2p.apps.googleusercontent.com',
    iosBundleId: 'com.firstapp.worknotes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB4tn0zHoJFS_wi9cVbNrJ8sCX4Z_k3dvM',
    appId: '1:750278780765:ios:42550894b918bc78f1aab4',
    messagingSenderId: '750278780765',
    projectId: 'worknotes-flutter-project',
    storageBucket: 'worknotes-flutter-project.appspot.com',
    iosClientId: '750278780765-qabc0mhgs3mqgihjttpn58t6acdrcq2p.apps.googleusercontent.com',
    iosBundleId: 'com.firstapp.worknotes',
  );
}
