import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/config_loader.dart';

class SettingScreen extends StatefulWidget {
  final VoidCallback? onConfigChanged;
  const SettingScreen({Key? key, this.onConfigChanged}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final TextEditingController _apiBaseController = TextEditingController();
  final TextEditingController _apiPortController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  bool verified = false;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    _loadCurrentConfig();
  }

  Future<void> _loadCurrentConfig() async {
    final config = await loadConfig();
    _apiBaseController.text = config.apiBase;
    _apiPortController.text = config.apiPort.toString();
  }

  void _verifyPin() {
    if (_pinController.text == "11118888") {
      setState(() {
        verified = true;
        errorMsg = null;
      });
    } else {
      setState(() {
        errorMsg = "Mã xác thực không đúng!";
      });
    }
  }

  Future<void> _saveConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final apiBase = _apiBaseController.text.trim();
    final apiPort = int.tryParse(_apiPortController.text) ?? 0;

    if (apiBase.isEmpty) {
      setState(() {
        errorMsg = "apiBase không được bỏ trống!";
      });
      return;
    }
    await prefs.setString("apiBase", apiBase);
    await prefs.setInt("apiPort", apiPort);
    if (widget.onConfigChanged != null) widget.onConfigChanged!();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cấu hình kết nối API')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: !verified
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Nhập mã truy cập để đổi cấu hình:",
                        style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _pinController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Mã truy cập',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 8,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                        onPressed: _verifyPin, child: const Text("Xác nhận")),
                    if (errorMsg != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(errorMsg!,
                            style: const TextStyle(color: Colors.red)),
                      ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _apiBaseController,
                      decoration: const InputDecoration(
                        labelText: 'API Base (vd: https://192.168.10.10)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _apiPortController,
                      decoration: const InputDecoration(
                        labelText: 'API Port (0 = bỏ qua)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: _saveConfig, child: const Text("Lưu")),
                  ],
                ),
        ),
      ),
    );
  }
}
