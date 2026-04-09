import 'package:flutter/material.dart';
import 'package:frontend/core/theme.dart';
import 'package:frontend/features/auth/view/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recept AI',
      theme: AppTheme.dark,
      home: const LoginScreen(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recept AI')),
      body: const Center(child: Text('Recept AI')),
    );
  }
}
