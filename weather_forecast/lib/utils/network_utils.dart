import 'package:connectivity_plus/connectivity_plus.dart';  // Cần cài thư viện connectivity

class NetworkUtils {
  // Kiểm tra xem thiết bị có kết nối Internet hay không
  static Future<bool> isOnline() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Kiểm tra xem có kết nối Wi-Fi hay không
  static Future<bool> isConnectedToWiFi() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.wifi;
  }

  // Kiểm tra xem có kết nối di động hay không
  static Future<bool> isConnectedToMobile() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.mobile;
  }
}
