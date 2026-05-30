class AiInsightsRouteArgs {
  const AiInsightsRouteArgs({required this.month, required this.year});

  final int month;
  final int year;
}

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const onboard = '/onboard';
  static const home = '/home';
  static const addExpense = '/add-expense';
  static const addManualExpense = '/add-manual-expense';
  static const scanningReceipt = '/scanning-receipt';
  static const scanConfirmation = '/scan-confirmation';
  static const aiInsights = '/ai-insights';
  static const expenseDetail = '/expense-detail';
}
