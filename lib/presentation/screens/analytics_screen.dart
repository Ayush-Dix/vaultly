// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../data/models/transaction_model.dart';
import '../../core/utils/transaction_helper.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/summary_cards_row.dart';
import '../widgets/spending_limit_card.dart';
import '../widgets/key_insights_card.dart';
import '../widgets/category_chart_card.dart';
import '../widgets/monthly_overview_card.dart';
import '../widgets/month_filter_button.dart';
import '../widgets/year_month_picker.dart';
import '../widgets/year_picker.dart' as custom;
import '../widgets/expense_heat_map_card.dart';

class AnalyticsScreen extends StatefulWidget {
  final List<Transaction> transactions;
  final double monthlyLimit;

  const AnalyticsScreen({
    super.key,
    required this.transactions,
    required this.monthlyLimit,
  });

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  DateTime? _selectedMonth;
  bool _showExpenseChart = true;
  bool _isYearFilter = false; // Track if filtering by year

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now(); // Default to current month
    _isYearFilter = false;
  }

  void _showMonthPicker() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSlate800 : AppColors.surfaceWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkTextTertiary.withOpacity(0.5)
                    : AppColors.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Filter Analytics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.all_inclusive,
                color: isDark ? AppColors.lightIndigo : AppColors.primaryIndigo,
              ),
              title: Text(
                'All Time',
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              trailing: _selectedMonth == null
                  ? Icon(
                      Icons.check_circle,
                      color: isDark
                          ? AppColors.lightIndigo
                          : AppColors.primaryIndigo,
                    )
                  : null,
              onTap: () {
                setState(() {
                  _selectedMonth = null;
                  _isYearFilter = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.calendar_month,
                color: isDark ? AppColors.lightPurple : AppColors.accentPurple,
              ),
              title: Text(
                'Filter by Month',
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                final picked = await _selectMonth(context);
                if (picked != null) {
                  setState(() {
                    _selectedMonth = picked;
                    _isYearFilter = false;
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(
                Icons.calendar_today_outlined,
                color: isDark ? AppColors.lightCyan : AppColors.accentCyan,
              ),
              title: Text(
                'Filter by Year',
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                final picked = await _selectYear(context);
                if (picked != null) {
                  setState(() {
                    _selectedMonth = picked;
                    _isYearFilter = true;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _selectMonth(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    DateTime? pickedMonth;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSlate800
            : AppColors.surfaceWhite,
        title: Text(
          'Select Month',
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        content: SizedBox(
          width: 300,
          height: 300,
          child: YearMonthPicker(
            initialDate: _selectedMonth ?? DateTime.now(),
            onDateSelected: (date) {
              pickedMonth = date;
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );

    return pickedMonth;
  }

  Future<DateTime?> _selectYear(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    DateTime? pickedYear;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark
            ? AppColors.darkSlate800
            : AppColors.surfaceWhite,
        title: Text(
          'Select Year',
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        content: SizedBox(
          width: 300,
          height: 300,
          child: custom.YearPicker(
            initialYear: _selectedMonth?.year ?? DateTime.now().year,
            onYearSelected: (year) {
              pickedYear = DateTime(year);
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );

    return pickedYear;
  }

  @override
  Widget build(BuildContext context) {
    final bool isAllTime = _selectedMonth == null;

    final monthlyExpenses = isAllTime
        ? TransactionHelper.calculateAllTimeExpenses(widget.transactions)
        : _isYearFilter
        ? TransactionHelper.calculateExpensesForYear(
            widget.transactions,
            _selectedMonth!.year,
          )
        : TransactionHelper.calculateExpensesForMonth(
            widget.transactions,
            _selectedMonth!,
          );
    final monthlyIncome = isAllTime
        ? TransactionHelper.calculateAllTimeIncome(widget.transactions)
        : _isYearFilter
        ? TransactionHelper.calculateIncomeForYear(
            widget.transactions,
            _selectedMonth!.year,
          )
        : TransactionHelper.calculateIncomeForMonth(
            widget.transactions,
            _selectedMonth!,
          );
    final categoryExpenses = isAllTime
        ? TransactionHelper.getAllTimeCategoryExpenses(widget.transactions)
        : _isYearFilter
        ? TransactionHelper.getCategoryExpensesForYear(
            widget.transactions,
            _selectedMonth!.year,
          )
        : TransactionHelper.getCategoryExpensesForMonth(
            widget.transactions,
            _selectedMonth!,
          );
    final categoryIncome = isAllTime
        ? TransactionHelper.getAllTimeCategoryIncome(widget.transactions)
        : _isYearFilter
        ? TransactionHelper.getCategoryIncomeForYear(
            widget.transactions,
            _selectedMonth!.year,
          )
        : TransactionHelper.getCategoryIncomeForMonth(
            widget.transactions,
            _selectedMonth!,
          );

    final relevantTransactions = isAllTime
        ? widget.transactions
              .where((t) => t.type == TransactionType.expense)
              .toList()
        : _isYearFilter
        ? widget.transactions
              .where(
                (t) =>
                    t.type == TransactionType.expense &&
                    t.date.year == _selectedMonth!.year,
              )
              .toList()
        : widget.transactions
              .where(
                (t) =>
                    t.type == TransactionType.expense &&
                    t.date.year == _selectedMonth!.year &&
                    t.date.month == _selectedMonth!.month,
              )
              .toList();

    final avgPerDay = TransactionHelper.calculateAverageDailyExpense(
      relevantTransactions,
      isAllTime,
      _selectedMonth,
    );

    final maxSpendingDay = TransactionHelper.getMaxSpendingDay(
      relevantTransactions,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month Picker
          MonthFilterButton(
            isAllTime: isAllTime,
            selectedMonth: _selectedMonth,
            onTap: _showMonthPicker,
            isYearFilter: _isYearFilter,
          ),
          const SizedBox(height: 24),
          SummaryCardsRow(
            monthlyExpenses: monthlyExpenses,
            monthlyIncome: monthlyIncome,
          ),
          const SizedBox(height: 16),
          KeyInsightsCard(avgPerDay: avgPerDay, maxSpendingDay: maxSpendingDay),
          const SizedBox(height: 24),
          SpendingLimitCard(
            monthlyExpenses: monthlyExpenses,
            monthlyLimit: widget.monthlyLimit,
          ),
          const SizedBox(height: 24),
          CategoryChartCard(
            showExpenseChart: _showExpenseChart,
            categoryExpenses: categoryExpenses,
            categoryIncome: categoryIncome,
            onToggle: (value) {
              setState(() {
                _showExpenseChart = value;
              });
            },
          ),
          const SizedBox(height: 24),
          if (!isAllTime)
            Column(
              children: [
                ExpenseHeatMapCard(
                  transactions: widget.transactions,
                  isYearFilter: _isYearFilter,
                  selectedDate: _selectedMonth,
                ),
                const SizedBox(height: 24),
              ],
            ),
          MonthlyOverviewCard(
            monthlyExpenses: monthlyExpenses,
            monthlyIncome: monthlyIncome,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
