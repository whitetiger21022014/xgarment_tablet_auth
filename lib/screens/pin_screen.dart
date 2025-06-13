import 'package:flutter/material.dart';
import '../utils/config_loader.dart';
import '../services/api_service.dart';
import 'webview_screen.dart';
import 'qr_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class PinScreen extends StatefulWidget {
  final AppConfig config;
  final String logoPath;
  final String deviceId;
  final String qrCode;

  const PinScreen(
      {Key? key,
      required this.config,
      required this.logoPath,
      required this.deviceId,
      required this.qrCode})
      : super(key: key);

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final TextEditingController pinController = TextEditingController();
  bool loading = false;

  void login() async {
    String pin = pinController.text.trim();
    if (pin.isEmpty || pin.length < 4) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.WARNING,
        title: 'PIN không hợp lệ!',
        desc: 'Nhập PIN từ 4 ký tự.',
        btnOkOnPress: () {},
      ).show();
      return;
    }
    setState(() => loading = true);
    final resp = await loginTablet(
        apiBase: widget.config.apiBase,
        apiPort: widget.config.apiPort,
        deviceId: widget.deviceId,
        qrCode: widget.qrCode,
        pin: pin);
    setState(() => loading = false);

    if (resp == null || resp['success'] != true) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        title: 'Đăng nhập thất bại',
        desc: resp?['message'] ?? 'Lỗi đăng nhập. Thử lại!',
        btnOkOnPress: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => QRScreen(
                        config: widget.config,
                        logoPath: widget.logoPath,
                        deviceId: widget.deviceId,
                      )));
        },
      ).show();
    } else {
      // Lấy dashboard URL nếu backend trả về
      String? dashUrl = resp['dashboardUrl'] ??
          '${widget.config.apiBase}${widget.config.apiPort > 0 ? ':${widget.config.apiPort}' : ''}/tablet/dash';
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => WebViewScreen(
                    dashboardUrl: dashUrl,
                    config: widget.config,
                    logoPath: widget.logoPath,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhập PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(widget.logoPath, height: 80),
              const SizedBox(height: 24),
              TextField(
                controller: pinController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Nhập PIN',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock)),
                keyboardType: TextInputType.number,
                maxLength: 8,
              ),
              const SizedBox(height: 16),
              loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: login,
                      child: const Text('Đăng nhập'),
                    ),
              const SizedBox(height: 16),
              TextButton(
                child: const Text('Quay lại quét QR'),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => QRScreen(
                                config: widget.config,
                                logoPath: widget.logoPath,
                                deviceId: widget.deviceId,
                              )));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
