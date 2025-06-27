import 'dart:io';
import 'package:flutter/material.dart';
import 'config_loader.dart';

class LogoHelper {
  static ImageProvider getLogo() {
    final config = ConfigLoader.currentConfig;
    if (config == null) {
      return const AssetImage('assets/companyDefault_logo.png');
    }
    final assetPath = 'assets/${config.companyBrief}_logo.png';
    // Bạn có thể kiểm tra file tồn tại ở asset nếu muốn
    return AssetImage(assetPath);
  }
}
