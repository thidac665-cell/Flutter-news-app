import 'dart:io';
import 'dart:async';
import 'dart:io' show InternetAddress;
import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> getInternetStatus() async {
  // Windows desktop fix
  if (Platform.isWindows) {
    return true;
  }

  final connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.none) {
    return false;
  }

  // Real internet check (Android / iOS)
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}
