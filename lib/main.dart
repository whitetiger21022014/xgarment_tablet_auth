import 'package:flutter/material.dart';
import 'screens/launch_screen.dart';

void main() {
  runApp(const XGarmentApp());
}

class XGarmentApp extends StatelessWidget {
  const XGarmentApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XGarment Tablet Auth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LaunchScreen(),
    );
  }
}
