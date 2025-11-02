import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:http/http.dart' as http;

class InternetChecker {
  final Connectivity _connectivity = Connectivity();

  Future<bool> hasConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result.first != ConnectivityResult.none;
  }

  Future<bool> hasInternetAccess() async {
    // Быстрая проверка типа подключения
    if (!await hasConnection()) {
      return false;
    }

    try {
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
