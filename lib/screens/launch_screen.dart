import 'package:flutter/material.dart';
import 'qr_screen.dart'; // Đã chuyển sang dùng mobile_scanner
import 'pin_screen.dart';
import 'api_service.dart'; // File gọi API backend
import 'webview_screen.dart'; // Webview để vào dashboard nếu login thành công
import 'setting_screen.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  void _onScanQR(BuildContext context) async {
    // Push QRScreen, lấy về mã QR (nếu cancel thì trả về null)
    final qrData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QRScreen(
          title: 'Quét mã QR đăng nhập',
        ),
      ),
    );

    // Kiểm tra null hoặc empty
    if (qrData == null || qrData.toString().isEmpty) return;

    // Kiểm tra mã QR hợp lệ (ví dụ: phải bắt đầu bằng 'barcode-')
    if (!qrData.toString().startsWith('barcode-')) {
      setState(() {
        _errorMessage = 'Mã QR không hợp lệ!';
      });
      return;
    }

    // Nhập PIN code
    final pin = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PinScreen(
          title: 'Nhập mã PIN',
        ),
      ),
    );

    if (pin == null || pin.toString().isEmpty) return;

    // Bắt đầu gọi API xác thực
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Gọi API backend (điều chỉnh lại tham số nếu cần)
      final deviceId = await ApiService.getDeviceId();
      final response = await ApiService.login(
        deviceId: deviceId,
        qrCode: qrData.toString(),
        pinCode: pin.toString(),
      );

      if (response.success) {
        // Nếu backend trả về URL dashboard, chuyển qua webview in-app
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => WebviewScreen(
              initialUrl: response.dashboardUrl ?? "",
            ),
          ),
        );
      } else {
        setState(() {
          _errorMessage = response.message ?? 'Xác thực thất bại!';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi xác thực: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onOpenSetting(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SettingScreen()),
    );
    // Sau khi cấu hình xong, có thể reload lại thông tin nếu cần
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('XGarment Tablet Auth'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _onOpenSetting(context),
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo và tên công ty, thêm nếu muốn
                  // Image.asset('assets/companyDefault_logo.png', width: 120),
                  // SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Đăng nhập bằng QR code'),
                    onPressed: () => _onScanQR(context),
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
