import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class Config {
  final String companyBrief;
  final String logoPath;
  final String apiBase;
  final int apiPort;

  Config({
    required this.companyBrief,
    required this.logoPath,
    required this.apiBase,
    required this.apiPort,
  });

  factory Config.fromJson(Map<String, dynamic> json) => Config(
    companyBrief: json['companyBrief'],
    logoPath: json['logoPath'],
    apiBase: json['apiBase'],
    apiPort: json['apiPort'] ?? 0,
  );
}

class ConfigLoader {
  static Config? currentConfig;

  static Future<void> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final savedConfig = prefs.getString('config');
    if (savedConfig != null) {
      currentConfig = Config.fromJson(json.decode(savedConfig));
      return;
    }
    final configStr = await rootBundle.loadString('assets/config.json');
    currentConfig = Config.fromJson(json.decode(configStr));
  }

  static Future<void> saveConfig({required String apiBase, required int apiPort}) async {
    final prefs = await SharedPreferences.getInstance();
    if (currentConfig != null) {
      currentConfig = Config(
        companyBrief: currentConfig!.companyBrief,
        logoPath: currentConfig!.logoPath,
        apiBase: apiBase,
        apiPort: apiPort,
      );
      await prefs.setString('config', json.encode({
        'companyBrief': currentConfig!.companyBrief,
        'logoPath': currentConfig!.logoPath,
        'apiBase': apiBase,
        'apiPort': apiPort,
      }));
    }
  }
}
