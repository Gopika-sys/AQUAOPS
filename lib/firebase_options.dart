import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web not configured');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const FirebaseOptions(
          apiKey: 'AIzaSyCallednSSgMKmJq_OVctesAe36xTPlpyc',
          appId: '1:875211010439:android:c9e4c3787b01db9247a322',
          messagingSenderId: '875211010439',
          projectId: 'aquaops-ddb98',
          storageBucket: 'aquaops-ddb98.firebasestorage.app',
        );
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }
}