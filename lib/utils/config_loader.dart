import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  final String companyBrief;
  final String logoPath;
  final String apiBase;
  final int apiPort;

  AppConfig({
    required this.companyBrief,
    required this.logoPath,
    required this.apiBase,
    required this.apiPort,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      companyBrief: json['companyBrief'] ?? 'default',
      logoPath: json['logoPath'] ?? 'assets/companyDefault_logo.png',
      apiBase: json['apiBase'],
      apiPort: json['apiPort'],
    );
  }
}

Future<AppConfig> loadConfig() async {
  String data = await rootBundle.loadString('assets/config.json');
  Map<String, dynamic> jsonResult = json.decode(data);
  final prefs = await SharedPreferences.getInstance();
  final customApiBase = prefs.getString("apiBase");
  final customApiPort = prefs.getInt("apiPort");
  return AppConfig(
    companyBrief: jsonResult['companyBrief'] ?? 'default',
    logoPath: jsonResult['logoPath'] ?? 'assets/companyDefault_logo.png',
    apiBase: customApiBase ?? jsonResult['apiBase'],
    apiPort: customApiPort ?? jsonResult['apiPort'],
  );
}
