import 'package:flutter/material.dart';

void main() {
  runApp(const HeedarTVApp());
}

class HeedarTVApp extends StatelessWidget {
  const HeedarTVApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HEEDAR TV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        primaryColor: Colors.greenAccent,
        colorScheme: const ColorScheme.dark(
          primary: Colors.greenAccent,
          secondary: Colors.greenAccent,
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HEEDAR TV - Ready', style: TextStyle(color: Colors.greenAccent)),
        backgroundColor: const Color(0xFF0F0F0F),
      ),
      body: const Center(
        child: Text(
          'التطبيق جاهز لربط السيرفر بنجاح',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
