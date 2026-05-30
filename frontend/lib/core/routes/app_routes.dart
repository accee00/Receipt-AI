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

  static String aiInsightsWith({required int month, required int year}) =>
      '$aiInsights?month=$month&year=$year';
}
