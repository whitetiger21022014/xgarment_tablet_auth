import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';

class ApiResponse {
  final bool success;
  final String? message;
  final String? dashboardUrl;
  ApiResponse({required this.success, this.message, this.dashboardUrl});
}

class ApiService {
  static Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    final info = await deviceInfo.androidInfo;
    return info.id ?? info.androidId ?? "unknown_device";
  }

  static Future<ApiResponse> login({
    required String deviceId,
    required String qrCode,
    required String pinCode,
  }) async {
    // Đọc config từ ConfigLoader
    // (Tuỳ chỉnh lại nếu cần)
    final apiBase = 'https://192.168.10.10';
    final apiPort = 8080;
    final url = apiPort == 0
        ? '$apiBase/tablet/login'
        : '$apiBase:$apiPort/tablet/login';

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        "deviceId": deviceId,
        "qr": qrCode,
        "pin": pinCode,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ApiResponse(
        success: data['success'] == true,
        message: data['message'],
        dashboardUrl: data['dashboardUrl'],
      );
    } else {
      return ApiResponse(
        success: false,
        message: "Lỗi kết nối server (${response.statusCode})",
      );
    }
  }
}
