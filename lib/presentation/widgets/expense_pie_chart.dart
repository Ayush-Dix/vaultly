import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';

class ExpensePieChart extends StatefulWidget {
  final Map<String, double> categoryExpenses;

  const ExpensePieChart({super.key, required this.categoryExpenses});

  @override
  State<ExpensePieChart> createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends State<ExpensePieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (widget.categoryExpenses.isEmpty) {
      return Center(
        child: Text(
          'No expense data for this month',
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
      );
    }

    final colors = isDark ? AppColors.darkChartColors : AppColors.chartColors;
    final total = widget.categoryExpenses.values.reduce((a, b) => a + b);

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sections: widget.categoryExpenses.entries.map((entry) {
                final index = widget.categoryExpenses.keys.toList().indexOf(
                  entry.key,
                );
                final isTouched = index == touchedIndex;

                return PieChartSectionData(
                  value: entry.value,
                  title: '',
                  color: colors[index % colors.length],
                  radius: isTouched ? 65 : 60,
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Flexible(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 16,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: widget.categoryExpenses.entries.map((entry) {
                final index = widget.categoryExpenses.keys.toList().indexOf(
                  entry.key,
                );
                final percentage = (entry.value / total * 100);
                return _LegendItem(
                  color: colors[index % colors.length],
                  category: entry.key,
                  amount: entry.value,
                  percentage: percentage,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String category;
  final double amount;
  final double percentage;

  const _LegendItem({
    required this.color,
    required this.category,
    required this.amount,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            '$category: ₹${amount.toStringAsFixed(0)} (${percentage.toStringAsFixed(0)}%)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
