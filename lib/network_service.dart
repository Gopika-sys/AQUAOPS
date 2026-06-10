import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  static Future<bool> isConnected() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    // App considers connected if it has Wifi, Mobile, or Ethernet
    return connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.ethernet);
  }
}