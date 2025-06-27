import 'package:flutter/material.dart';
import 'qr_screen.dart';
import 'pin_screen.dart';
import '../services/api_service.dart';
import 'webview_screen.dart';
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
    final qrData = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => QRScreen(title: 'Quét mã QR đăng nhập')),
    );
    if (qrData == null || qrData.toString().isEmpty) return;
    if (!qrData.toString().startsWith('barcode-')) {
      setState(() => _errorMessage = 'Mã QR không hợp lệ!');
      return;
    }

    final pin = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PinScreen(title: 'Nhập mã PIN')),
    );
    if (pin == null || pin.toString().isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final deviceId = await ApiService.getDeviceId();
      final response = await ApiService.login(
        deviceId: deviceId,
        qrCode: qrData.toString(),
        pinCode: pin.toString(),
      );
      if (response.success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => WebviewScreen(initialUrl: response.dashboardUrl ?? ""),
          ),
        );
      } else {
        setState(() => _errorMessage = response.message ?? 'Xác thực thất bại!');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Lỗi khi xác thực: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onOpenSetting(BuildContext context) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingScreen()));
    // reload config nếu cần
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('XGarment Tablet Auth'),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () => _onOpenSetting(context)),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
