import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QRScreen extends StatefulWidget {
  final Function(String qrCode)? onScan;
  final String title;
  const QRScreen({Key? key, this.onScan, this.title = 'Quét mã QR'}) : super(key: key);

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  final MobileScannerController scannerController = MobileScannerController(facing: CameraFacing.back);
  bool _cameraReady = false;
  bool _permissionDenied = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    setState(() {
      _permissionDenied = !status.isGranted;
      _cameraReady = status.isGranted;
    });
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      _isProcessing = true;
      String qrData = barcodes.first.rawValue!;
      if (widget.onScan != null) widget.onScan!(qrData);
      Navigator.of(context).pop(qrData);
    }
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionDenied) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: const Center(
          child: Text("Ứng dụng cần quyền Camera để quét QR!", style: TextStyle(color: Colors.red, fontSize: 18)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _cameraReady
          ? Stack(
              children: [
                MobileScanner(
                  controller: scannerController,
                  onDetect: _onDetect,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlueAccent, width: 4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.flip_camera_ios),
                      label: const Text('Đổi Camera'),
                      onPressed: () => scannerController.switchCamera(),
                    ),
                  ),
                )
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
