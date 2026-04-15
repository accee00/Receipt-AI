import 'package:flutter/material.dart';
import 'package:frontend/core/routes/go_routes.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      key: GoRoutes.navigatorKey,
      title: 'Receipt AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: GoRoutes.router,
    );
  }
}
