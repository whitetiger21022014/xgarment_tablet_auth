import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../utils/config_loader.dart';
import 'qr_screen.dart';

class WebViewScreen extends StatefulWidget {
  final String dashboardUrl;
  final AppConfig config;
  final String logoPath;

  const WebViewScreen(
      {Key? key,
      required this.dashboardUrl,
      required this.config,
      required this.logoPath})
      : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late InAppWebViewController webViewController;

  Future<void> _handleLogout() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (_) => QRScreen(
                config: widget.config,
                logoPath: widget.logoPath,
                deviceId: "deviceId")), // deviceId lấy lại nếu cần
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _handleLogout)
        ],
      ),
