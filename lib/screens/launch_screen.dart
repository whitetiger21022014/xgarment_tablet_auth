import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../utils/config_loader.dart';
import '../utils/logo_helper.dart';
import '../services/api_service.dart';
import 'qr_screen.dart';
import 'setting_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  AppConfig? config;
  String logoPath = "assets/companyDefault_logo.png";
  String? deviceId;
  bool loading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    startCheck();
  }

  Future<void> startCheck() async {
    setState(() {
      loading = true;
      errorMsg = null;
    });

    try {
      // 1. Load config
      config = await loadConfig();

      // 2. Get logo path
      logoPath = await getLogoPath(
          config!.companyBrief, config!.logoPath);

      // 3. Check camera (back)
      // Do package qr_code_scanner tự kiểm tra, bỏ qua bước này để tránh lỗi nếu không có camera back

      // 4. Permission camera
      var status = await Permission.camera.request();
      if (!status.isGranted) {
        setState(() {
          loading = false;
          errorMsg = 'Chưa cho phép quyền truy cập camera!';
        });
        return;
      }

      // 5. Get deviceId (androidId)
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      deviceId = androidInfo.id ?? androidInfo.androidId;

      // 6. Check API connect
      bool apiOk = await checkApiPing(config!.apiBase, config!.apiPort);
      if (!apiOk) {
        setState(() {
          loading = false;
          errorMsg = 'Không kết nối được API!';
        });
        return;
      }

      // => All OK, next
      if (mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => QRScreen(
                    config: config!,
                    logoPath: logoPath,
                    deviceId: deviceId!)));
      }
    } catch (e) {
      setState(() {
        loading = false;
        errorMsg = 'Lỗi hệ thống: ${e.toString()}';
      });
    }
  }

  void gotoSetting() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingScreen(
          onConfigChanged: () async {
            await startCheck();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('XGarment Tablet Login'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: gotoSetting,
            ),
          ],
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : errorMsg != null
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(logoPath, height: 100),
                      const SizedBox(height: 24),
                      Text(errorMsg!, style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          startCheck();
                        },
                        child: const Text('Thử lại'),
                      )
                    ],
                  ))
                : Container());
  }
}
