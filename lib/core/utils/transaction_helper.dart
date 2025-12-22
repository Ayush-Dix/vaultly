import '../../data/models/transaction_model.dart';

class TransactionHelper {
  static Map<DateTime, List<Transaction>> groupTransactionsByDate(
    List<Transaction> transactions,
  ) {
    final Map<DateTime, List<Transaction>> grouped = {};

    for (var transaction in transactions) {
      final dateOnly = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );

      if (!grouped.containsKey(dateOnly)) {
        grouped[dateOnly] = [];
      }
      grouped[dateOnly]!.add(transaction);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    return Map.fromEntries(
      sortedKeys.map((key) => MapEntry(key, grouped[key]!)),
    );
  }

  static double calculateMonthlyExpenses(List<Transaction> transactions) {
    final now = DateTime.now();
    return transactions
        .where(
          (t) =>
              t.type == TransactionType.expense &&
              t.date.year == now.year &&
              t.date.month == now.month,
        )
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static double calculateMonthlyIncome(List<Transaction> transactions) {
    final now = DateTime.now();
    return transactions
        .where(
          (t) =>
              t.type == TransactionType.income &&
              t.date.year == now.year &&
              t.date.month == now.month,
        )
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static Map<String, double> getCategoryExpenses(
    List<Transaction> transactions,
  ) {
    final categoryExpenses = <String, double>{};
    final now = DateTime.now();

    for (var t in transactions) {
      if (t.type == TransactionType.expense &&
          t.date.year == now.year &&
          t.date.month == now.month) {
        categoryExpenses[t.category] =
            (categoryExpenses[t.category] ?? 0) + t.amount;
      }
    }

    return categoryExpenses;
  }

  static double calculateExpensesForMonth(
    List<Transaction> transactions,
    DateTime month,
  ) {
    return transactions
        .where(
          (t) =>
              t.type == TransactionType.expense &&
              t.date.year == month.year &&
              t.date.month == month.month,
        )
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static double calculateIncomeForMonth(
    List<Transaction> transactions,
    DateTime month,
  ) {
    return transactions
        .where(
          (t) =>
              t.type == TransactionType.income &&
              t.date.year == month.year &&
              t.date.month == month.month,
        )
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static Map<String, double> getCategoryExpensesForMonth(
    List<Transaction> transactions,
    DateTime month,
  ) {
    final categoryExpenses = <String, double>{};

    for (var t in transactions) {
      if (t.type == TransactionType.expense &&
          t.date.year == month.year &&
          t.date.month == month.month) {
        categoryExpenses[t.category] =
            (categoryExpenses[t.category] ?? 0) + t.amount;
      }
    }

    return categoryExpenses;
  }

  static double calculateAllTimeExpenses(List<Transaction> transactions) {
    return transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static double calculateAllTimeIncome(List<Transaction> transactions) {
    return transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static Map<String, double> getAllTimeCategoryExpenses(
    List<Transaction> transactions,
  ) {
    final categoryExpenses = <String, double>{};

    for (var t in transactions) {
      if (t.type == TransactionType.expense) {
        categoryExpenses[t.category] =
            (categoryExpenses[t.category] ?? 0) + t.amount;
      }
    }

    return categoryExpenses;
  }

  static Map<String, double> getAllTimeCategoryIncome(
    List<Transaction> transactions,
  ) {
    final categoryIncome = <String, double>{};

    for (var t in transactions) {
      if (t.type == TransactionType.income) {
        categoryIncome[t.category] =
            (categoryIncome[t.category] ?? 0) + t.amount;
      }
    }

    return categoryIncome;
  }

  static Map<String, double> getCategoryIncomeForMonth(
    List<Transaction> transactions,
    DateTime month,
  ) {
    final categoryIncome = <String, double>{};

    for (var t in transactions) {
      if (t.type == TransactionType.income &&
          t.date.year == month.year &&
          t.date.month == month.month) {
        categoryIncome[t.category] =
            (categoryIncome[t.category] ?? 0) + t.amount;
      }
    }

    return categoryIncome;
  }

  static double calculateAverageDailyExpense(
    List<Transaction> expenseTransactions,
    bool isAllTime,
    DateTime? selectedMonth,
  ) {
    if (expenseTransactions.isEmpty) return 0.0;

    final totalExpenses = expenseTransactions.fold(
      0.0,
      (sum, t) => sum + t.amount,
    );

    if (isAllTime) {
      // Calculate days between first and last transaction
      final dates = expenseTransactions.map((t) => t.date).toList()..sort();
      final firstDate = dates.first;
      final lastDate = dates.last;
      final daysDifference = lastDate.difference(firstDate).inDays + 1;
      return totalExpenses / daysDifference;
    } else {
      // Calculate for specific month
      final daysInMonth = DateTime(
        selectedMonth!.year,
        selectedMonth.month + 1,
        0,
      ).day;
      return totalExpenses / daysInMonth;
    }
  }

  static Map<String, dynamic>? getMaxSpendingDay(
    List<Transaction> expenseTransactions,
  ) {
    if (expenseTransactions.isEmpty) return null;

    // Group by date
    final dailyExpenses = <DateTime, double>{};
    for (var transaction in expenseTransactions) {
      final dateOnly = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );
      dailyExpenses[dateOnly] =
          (dailyExpenses[dateOnly] ?? 0) + transaction.amount;
    }

    // Find max
    DateTime? maxDate;
    double maxAmount = 0.0;
    dailyExpenses.forEach((date, amount) {
      if (amount > maxAmount) {
        maxAmount = amount;
        maxDate = date;
      }
    });

    return maxDate != null ? {'date': maxDate, 'amount': maxAmount} : null;
  }

  // Year filtering methods
  static double calculateExpensesForYear(
    List<Transaction> transactions,
    int year,
  ) {
    return transactions
        .where((t) => t.type == TransactionType.expense && t.date.year == year)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static double calculateIncomeForYear(
    List<Transaction> transactions,
    int year,
  ) {
    return transactions
        .where((t) => t.type == TransactionType.income && t.date.year == year)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static Map<String, double> getCategoryExpensesForYear(
    List<Transaction> transactions,
    int year,
  ) {
    final categoryExpenses = <String, double>{};

    for (var t in transactions) {
      if (t.type == TransactionType.expense && t.date.year == year) {
        categoryExpenses[t.category] =
            (categoryExpenses[t.category] ?? 0) + t.amount;
      }
    }

    return categoryExpenses;
  }

  static Map<String, double> getCategoryIncomeForYear(
    List<Transaction> transactions,
    int year,
  ) {
    final categoryIncome = <String, double>{};

    for (var t in transactions) {
      if (t.type == TransactionType.income && t.date.year == year) {
        categoryIncome[t.category] =
            (categoryIncome[t.category] ?? 0) + t.amount;
      }
    }

    return categoryIncome;
  }
}
