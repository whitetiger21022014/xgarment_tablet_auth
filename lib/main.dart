import 'package:flutter/material.dart';
import 'screens/launch_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const XGarmentApp());
}

class XGarmentApp extends StatelessWidget {
  const XGarmentApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XGarment Tablet Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LaunchScreen(),
    );
  }
}
