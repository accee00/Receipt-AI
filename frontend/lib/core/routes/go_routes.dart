import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/features/auth/view/presentation/login_screen.dart';
import 'package:frontend/features/auth/view/presentation/signup_screen.dart';
import 'package:frontend/features/auth/view/presentation/splash_screen.dart';
import 'package:frontend/features/home/view/presentation/home_screen.dart';
import 'package:frontend/features/receipt/model/scan_result_model.dart';
import 'package:frontend/features/receipt/view/presentation/add_manual_expense_screen.dart';
import 'package:frontend/features/receipt/view/presentation/scan_confirmation_screen.dart';
import 'package:frontend/features/receipt/view/presentation/scanning_receipt_screen.dart';
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
      GoRoute(
        path: "/scanning-receipt",
        builder: (context, state) {
          final file = state.extra as File;
          return ScanningReceiptScreen(file: file);
        },
      ),
      GoRoute(
        path: "/scan-confirmation",
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return ScanConfirmationScreen(
            extractedData: extras['extractedData'] as ScanResultModel,
            imageUrl: extras['imageUrl'] as String,
          );
        },
      ),
      GoRoute(
        path: "/add-manual-expense",
        builder: (context, state) => const AddManualExpenseScreen(),
      ),
    ],
  );
}
