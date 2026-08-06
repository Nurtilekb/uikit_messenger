import 'package:connectivity_plus/connectivity_plus.dart';

final connectivity = Connectivity();
Future<void> checkConnection() async {
  final result = await connectivity.checkConnectivity();

  if (result.contains(ConnectivityResult.none)) {
    print('No internet connection');
  } else {
    print('Connected');
  }
}
