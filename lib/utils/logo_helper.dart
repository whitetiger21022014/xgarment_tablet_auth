import 'package:flutter/services.dart';

Future<String> getLogoPath(String companyBrief, String defaultPath) async {
  String customLogoPath = 'assets/${companyBrief}_logo.png';
  try {
    await rootBundle.load(customLogoPath);
    return customLogoPath;
  } catch (_) {
    return defaultPath;
  }
}
