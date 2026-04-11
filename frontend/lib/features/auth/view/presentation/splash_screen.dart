import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/auth/viewmodel/auth_view_model.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen(authViewModelProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            context.go("/home");
          } else {
            context.go("/login");
          }
        },
      );
    });
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
