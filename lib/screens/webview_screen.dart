import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebviewScreen extends StatefulWidget {
  final String initialUrl;
  const WebviewScreen({Key? key, required this.initialUrl}) : super(key: key);

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _webViewController?.reload();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(widget.initialUrl)),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                javaScriptEnabled: true,
                useShouldOverrideUrlLoading: true,
              ),
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
                _error = null;
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                _isLoading = false;
              });
            },
            onLoadError: (controller, url, code, message) {
              setState(() {
                _isLoading = false;
                _error = "Lỗi khi tải trang: $message";
              });
            },
            onLoadHttpError: (controller, url, statusCode, description) {
              setState(() {
                _isLoading = false;
                _error = "Lỗi HTTP $statusCode: $description";
              });
            },
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
          if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Lỗi khi tải trang web!\n$_error',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text("Thử lại"),
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                          _error = null;
                        });
                        _webViewController?.reload();
                      },
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
