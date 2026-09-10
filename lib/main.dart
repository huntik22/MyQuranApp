import 'package:flutter/material.dart';
import 'navigation/main_tab_view.dart';
// import 'navigation/test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coran App',
      debugShowCheckedModeBanner: false,
      home: const MainTabView(),
    );
  }
}
