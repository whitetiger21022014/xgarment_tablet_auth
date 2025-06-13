import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../utils/config_loader.dart';
import 'pin_screen.dart';

class QRScreen extends StatefulWidget {
  final AppConfig config;
  final String logoPath;
  final String deviceId;

  const QRScreen(
      {Key? key,
      required this.config,
      required this.logoPath,
      required this.deviceId})
      : super(key: key);

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool scanning = true;
  String? errorMsg;

  void _onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      if (!scanning) return;
      setState(() => scanning = false);
      String code = scanData.code ?? '';
      if (!code.startsWith('barcode-')) {
        setState(() => errorMsg = 'QR không hợp lệ (sai prefix barcode-)');
        controller.resumeCamera();
        setState(() => scanning = true);
        return;
      }
      // Next: nhập PIN
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => PinScreen(
                  config: widget.config,
                  logoPath: widget.logoPath,
                  deviceId: widget.deviceId,
                  qrCode: code)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Image.asset(widget.logoPath, height: 80),
          const SizedBox(height: 16),
          const Text('Quét thẻ QR đăng nhập', style: TextStyle(fontSize: 18)),
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          if (errorMsg != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(errorMsg!,
                  style: const TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }
}
