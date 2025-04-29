// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  // final Connectivity connectivity;

  NetworkInfoImpl();

  @override
  Future<bool> get isConnected async {
    // final result = await connectivity.checkConnectivity();
    // return result != ConnectivityResult.none;
    return true;
  }
}

