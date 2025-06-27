import 'package:flutter/material.dart';
import '../utils/config_loader.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final TextEditingController _apiBaseController = TextEditingController();
  final TextEditingController _apiPortController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load config hiện tại
    final config = ConfigLoader.currentConfig;
    _apiBaseController.text = config?.apiBase ?? '';
    _apiPortController.text = config?.apiPort?.toString() ?? '';
  }

  void _saveConfig() async {
    final apiBase = _apiBaseController.text.trim();
    final apiPort = int.tryParse(_apiPortController.text.trim()) ?? 0;
    // Bạn nên thêm phần xác thực mã quản trị trước khi cho phép lưu cấu hình ở đây
    await ConfigLoader.saveConfig(apiBase: apiBase, apiPort: apiPort);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã lưu cấu hình')));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt kết nối API')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _apiBaseController,
              decoration: const InputDecoration(labelText: "API Base URL"),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _apiPortController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "API Port (0 nếu mặc định HTTPS 443)"),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveConfig,
              child: const Text("Lưu"),
            )
          ],
        ),
      ),
    );
  }
}
