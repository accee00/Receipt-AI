import 'package:flutter/material.dart';
import 'package:frontend/features/auth/view/presentation/login_screen.dart';
import 'package:frontend/features/auth/view/presentation/signup_screen.dart';
import 'package:frontend/features/auth/view/presentation/splash_screen.dart';
import 'package:frontend/features/home/view/presentation/home_screen.dart';
import 'package:go_router/go_router.dart';

class GoRoutes {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static BuildContext? get context => navigatorKey.currentContext;
  static GoRouter get router => _router;

  static final _router = GoRouter(
    routes: [
      GoRoute(path: "/", builder: (context, state) => const SplashScreen()),
      GoRoute(path: "/login", builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: "/signup",
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(path: "/home", builder: (context, state) => const HomeScreen()),
    ],
  );
}
