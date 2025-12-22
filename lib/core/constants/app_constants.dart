class AppConstants {
  // App Information
  static const String appTitle = 'Vaultly';

  // Default Values
  static const double defaultMonthlyLimit = 5000.0;

  // Categories
  static const List<String> expenseCategories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Health',
    'Other',
  ];

  static const List<String> incomeCategories = [
    'Salary',
    'Freelance',
    'Investment',
    'Gift',
    'Other',
  ];

  // Notification Thresholds
  static const double warningThreshold = 80.0;
  static const double alertThreshold = 100.0;
}
