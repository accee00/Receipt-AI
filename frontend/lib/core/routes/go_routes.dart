import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/core/routes/app_routes.dart';
import 'package:frontend/features/auth/view/presentation/login_screen.dart';
import 'package:frontend/features/auth/view/presentation/onboard_screen.dart';
import 'package:frontend/features/auth/view/presentation/signup_screen.dart';
import 'package:frontend/features/auth/view/presentation/splash_screen.dart';
import 'package:frontend/features/home/view/presentation/home_screen.dart';
import 'package:frontend/features/receipt/model/scan_result_model.dart';
import 'package:frontend/features/receipt/model/expense_model.dart';
import 'package:frontend/features/receipt/view/presentation/add_expense_selection_screen.dart';
import 'package:frontend/features/receipt/view/presentation/add_manual_expense_screen.dart';
import 'package:frontend/features/receipt/view/presentation/ai_insights_screen.dart';
import 'package:frontend/features/receipt/view/presentation/scan_confirmation_screen.dart';
import 'package:frontend/features/receipt/view/presentation/scanning_receipt_screen.dart';
import 'package:frontend/features/receipt/view/presentation/expense_detail_screen.dart';
import 'package:go_router/go_router.dart';

class GoRoutes {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static BuildContext? get context => navigatorKey.currentContext;

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboard,
        builder: (context, state) => const OnboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.addExpense,
        builder: (context, state) => const AddExpenseSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.addManualExpense,
        builder: (context, state) => const AddManualExpenseScreen(),
      ),
      GoRoute(
        path: AppRoutes.scanningReceipt,
        builder: (context, state) {
          final file = state.extra as File;
          return ScanningReceiptScreen(file: file);
        },
      ),
      GoRoute(
        path: AppRoutes.scanConfirmation,
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>;
          return ScanConfirmationScreen(
            extractedData: extras['extractedData'] as ScanResultModel,
            imageUrl: extras['imageUrl'] as String,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.aiInsights,
        builder: (context, state) {
          final args = state.extra! as AiInsightsRouteArgs;
          return AiInsightsScreen(month: args.month, year: args.year);
        },
      ),
      GoRoute(
        path: AppRoutes.expenseDetail,
        builder: (context, state) {
          final expense = state.extra as ExpenseModel;
          return ExpenseDetailScreen(expense: expense);
        },
      ),
    ],
  );
}
