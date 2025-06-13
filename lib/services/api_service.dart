import 'dart:convert';
import 'package:http/http.dart' as http;

String getApiUrl(String base, int port, String path) {
  if (port == 0) return "$base$path";
  return "$base:$port$path";
}

Future<bool> checkApiPing(String apiBase, int apiPort) async {
  try {
    final url = Uri.parse(getApiUrl(apiBase, apiPort, "/ping"));
    final response = await http.get(url).timeout(const Duration(seconds: 3));
    return response.statusCode == 200;
  } catch (_) {
    return false;
  }
}

Future<Map<String, dynamic>?> loginTablet({
  required String apiBase,
  required int apiPort,
  required String deviceId,
  required String qrCode,
  required String pin,
}) async {
  try {
    final url = Uri.parse(getApiUrl(apiBase, apiPort, "/tablet/login"));
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'deviceId': deviceId,
          'qrCode': qrCode,
          'pin': pin,
        }));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  } catch (_) {
    return null;
  }
}
