import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAIih62ce2Gy4aOVdK954mEK-pPJSuGTuA',
    appId: '1:927022828051:web:75889ec8550021d52e0de6',
    messagingSenderId: '927022828051',
    projectId: 'fight-5e03d',
    authDomain: 'fight-5e03d.firebaseapp.com',
    storageBucket: 'fight-5e03d.appspot.com',
    measurementId: 'G-5GPL8Z6TB6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA2-aMpJDlynRw9UKS9Bt2qxSYAobA-Cx8',
    appId: '1:927022828051:android:352cc80bd036a9fc2e0de6',
    messagingSenderId: '927022828051',
    projectId: 'fight-5e03d',
    storageBucket: 'fight-5e03d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB0CdGuRTCMWUk_nKh618akybyXHHOxOEM',
    appId: '1:927022828051:ios:ef9234e60b4c60232e0de6',
    messagingSenderId: '927022828051',
    projectId: 'fight-5e03d',
    storageBucket: 'fight-5e03d.appspot.com',
    iosBundleId: 'com.example.fightApp2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB0CdGuRTCMWUk_nKh618akybyXHHOxOEM',
    appId: '1:927022828051:ios:ef9234e60b4c60232e0de6',
    messagingSenderId: '927022828051',
    projectId: 'fight-5e03d',
    storageBucket: 'fight-5e03d.appspot.com',
    iosBundleId: 'com.example.fightApp2',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAIih62ce2Gy4aOVdK954mEK-pPJSuGTuA',
    appId: '1:927022828051:web:1f163d4e4f2bba5d2e0de6',
    messagingSenderId: '927022828051',
    projectId: 'fight-5e03d',
    authDomain: 'fight-5e03d.firebaseapp.com',
    storageBucket: 'fight-5e03d.appspot.com',
    measurementId: 'G-VHZL8MP6T2',
  );
}
