// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'expense_pie_chart.dart';

class CategoryChartCard extends StatelessWidget {
  final bool showExpenseChart;
  final Map<String, double> categoryExpenses;
  final Map<String, double> categoryIncome;
  final Function(bool) onToggle;

  const CategoryChartCard({
    super.key,
    required this.showExpenseChart,
    required this.categoryExpenses,
    required this.categoryIncome,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSlate800 : AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : AppColors.primaryIndigo.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: showExpenseChart
                            ? (isDark
                                ? AppColors.lightIndigo.withOpacity(0.15)
                                : AppColors.primaryIndigo.withOpacity(0.1))
                            : (isDark
                                ? AppColors.darkEmerald.withOpacity(0.15)
                                : AppColors.incomeGreen.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.pie_chart,
                        color: showExpenseChart
                            ? (isDark ? AppColors.lightIndigo : AppColors.primaryIndigo)
                            : (isDark ? AppColors.darkEmerald : AppColors.incomeGreen),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        showExpenseChart
                            ? 'Expenses by Category'
                            : 'Income by Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SegmentedButton<bool>(
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: showExpenseChart
                      ? AppColors.expenseRed.withOpacity(0.1)
                      : AppColors.incomeGreen.withOpacity(0.1),
                  selectedForegroundColor: showExpenseChart
                      ? AppColors.expenseRed
                      : AppColors.incomeGreen,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                segments: const [
                  ButtonSegment<bool>(
                    value: true,
                    icon: Icon(Icons.trending_down, size: 16),
                  ),
                  ButtonSegment<bool>(
                    value: false,
                    icon: Icon(Icons.trending_up, size: 16),
                  ),
                ],
                selected: {showExpenseChart},
                onSelectionChanged: (Set<bool> selection) {
                  onToggle(selection.first);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 350),
            child: ExpensePieChart(
              categoryExpenses: showExpenseChart
                  ? categoryExpenses
                  : categoryIncome,
            ),
          ),
        ],
      ),
    );
  }
}
