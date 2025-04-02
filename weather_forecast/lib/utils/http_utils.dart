import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_forecast/utils/api_keys.dart';
import 'package:weather_forecast/utils/constants.dart';

class HttpUtils {
  // GET Request
  static Future<Map<String, dynamic>> getData(String endpoint, {Map<String, String>? queryParameters}) async {
    try {
      final String apiKey = ApiKeys.weatherApiKey;

      final url = Uri.parse('$endpoint?key=$apiKey${_buildQueryString(queryParameters)}');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(ErrorMessages.failedToLoadData);
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Build query string from map
  static String _buildQueryString(Map<String, String>? queryParameters) {
    if (queryParameters == null || queryParameters.isEmpty) return '';

    final queryString = queryParameters.entries
        .map((entry) => '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}')
        .join('&');
    return '&$queryString';
  }

  // POST Request
  static Future<Map<String, dynamic>> postData(String endpoint, Map<String, dynamic> body) async {
    try {
      final String apiKey = ApiKeys.weatherApiKey;

      final url = Uri.parse('$endpoint?key=$apiKey');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(ErrorMessages.failedToLoadData);
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
