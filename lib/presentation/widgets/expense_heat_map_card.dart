// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/transaction_model.dart';

class ExpenseHeatMapCard extends StatefulWidget {
  final List<Transaction> transactions;
  final bool isYearFilter;
  final DateTime? selectedDate;

  const ExpenseHeatMapCard({
    super.key,
    required this.transactions,
    required this.isYearFilter,
    this.selectedDate,
  });

  @override
  State<ExpenseHeatMapCard> createState() => _ExpenseHeatMapCardState();
}

class _ExpenseHeatMapCardState extends State<ExpenseHeatMapCard> {
  int? _selectedIndex;
  double? _selectedExpense;

  Map<int, double> _getDailyExpenses() {
    final dailyExpenses = <int, double>{};
    final month = widget.selectedDate ?? DateTime.now();

    for (var transaction in widget.transactions) {
      if (transaction.type == TransactionType.expense &&
          transaction.date.year == month.year &&
          transaction.date.month == month.month) {
        final day = transaction.date.day;
        dailyExpenses[day] = (dailyExpenses[day] ?? 0) + transaction.amount;
      }
    }

    return dailyExpenses;
  }

  Map<int, double> _getMonthlyExpenses() {
    final monthlyExpenses = <int, double>{};
    final year = widget.selectedDate?.year ?? DateTime.now().year;

    for (var transaction in widget.transactions) {
      if (transaction.type == TransactionType.expense &&
          transaction.date.year == year) {
        final month = transaction.date.month;
        monthlyExpenses[month] =
            (monthlyExpenses[month] ?? 0) + transaction.amount;
      }
    }

    return monthlyExpenses;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSlate800 : AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: isDark
                        ? AppColors.lightIndigo
                        : AppColors.primaryIndigo,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.isYearFilter ? 'Monthly Activity' : 'Daily Activity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              if (_selectedExpense != null && _selectedExpense! > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [AppColors.lightIndigo, AppColors.lightPurple]
                          : [AppColors.primaryIndigo, AppColors.accentPurple],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (isDark
                                    ? AppColors.lightIndigo
                                    : AppColors.primaryIndigo)
                                .withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Text(
                    '₹${_selectedExpense!.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          widget.isYearFilter
              ? _buildYearlyHeatMap(isDark)
              : _buildMonthlyHeatMap(isDark),
        ],
      ),
    );
  }

  Widget _buildMonthlyHeatMap(bool isDark) {
    final dailyExpenses = _getDailyExpenses();
    final month = widget.selectedDate ?? DateTime.now();
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final maxExpense = dailyExpenses.values.isEmpty
        ? 1.0
        : dailyExpenses.values.reduce((a, b) => a > b ? a : b);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: daysInMonth,
      itemBuilder: (context, index) {
        final day = index + 1;
        final expense = dailyExpenses[day] ?? 0;
        final intensity = expense > 0 ? (expense / maxExpense) : 0.0;

        return _buildHeatMapTile(
          index: index,
          label: day.toString(),
          intensity: intensity,
          expense: expense,
          isDark: isDark,
        );
      },
    );
  }

  Widget _buildYearlyHeatMap(bool isDark) {
    final monthlyExpenses = _getMonthlyExpenses();
    final maxExpense = monthlyExpenses.values.isEmpty
        ? 1.0
        : monthlyExpenses.values.reduce((a, b) => a > b ? a : b);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final month = index + 1;
        final expense = monthlyExpenses[month] ?? 0;
        final intensity = expense > 0 ? (expense / maxExpense) : 0.0;
        final monthName = DateFormat('MMM').format(DateTime(2024, month));

        return _buildHeatMapTile(
          index: index,
          label: monthName,
          intensity: intensity,
          expense: expense,
          isDark: isDark,
          isMonth: true,
        );
      },
    );
  }

  Widget _buildHeatMapTile({
    required int index,
    required String label,
    required double intensity,
    required double expense,
    required bool isDark,
    bool isMonth = false,
  }) {
    final hasExpense = expense > 0;
    // GitHub-style color intensity (0 = very light, 1 = very dark)
    Color getTileColor() {
      if (!hasExpense) {
        return isDark
            ? AppColors.darkSlate700.withOpacity(0.2)
            : AppColors.borderSlate.withOpacity(0.2);
      }

      // 4 levels of intensity like GitHub
      if (intensity < 0.25) {
        return isDark
            ? AppColors.lightIndigo.withOpacity(0.3)
            : AppColors.primaryIndigo.withOpacity(0.25);
      } else if (intensity < 0.5) {
        return isDark
            ? AppColors.lightIndigo.withOpacity(0.5)
            : AppColors.primaryIndigo.withOpacity(0.45);
      } else if (intensity < 0.75) {
        return isDark
            ? AppColors.lightIndigo.withOpacity(0.7)
            : AppColors.primaryIndigo.withOpacity(0.65);
      } else {
        return isDark ? AppColors.lightIndigo : AppColors.primaryIndigo;
      }
    }

    return GestureDetector(
      onTapDown: (_) {
        if (hasExpense) {
          setState(() {
            _selectedIndex = index;
            _selectedExpense = expense;
          });
        }
      },
      onTapUp: (_) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted && _selectedIndex == index) {
            setState(() {
              _selectedIndex = null;
              _selectedExpense = null;
            });
          }
        });
      },
      onTapCancel: () {
        setState(() {
          _selectedIndex = null;
          _selectedExpense = null;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: getTileColor(),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isMonth ? 12 : 11,
              fontWeight: FontWeight.w600,
              color: hasExpense
                  ? Colors.white
                  : (isDark
                        ? AppColors.darkTextTertiary
                        : AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
