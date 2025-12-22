import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/monthly_limit_dialog.dart';

class SettingsScreen extends StatelessWidget {
  final double monthlyLimit;
  final bool isDarkMode;
  final Function(double) onLimitChanged;
  final Function(bool) onDarkModeChanged;

  const SettingsScreen({
    super.key,
    required this.monthlyLimit,
    required this.isDarkMode,
    required this.onLimitChanged,
    required this.onDarkModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: isDarkMode
                      ? AppColors.lightIndigo
                      : AppColors.primaryIndigo,
                ),
                title: const Text('Dark Mode'),
                subtitle: Text(isDarkMode ? 'Enabled' : 'Disabled'),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: onDarkModeChanged,
                  activeThumbColor: isDarkMode
                      ? AppColors.lightIndigo
                      : AppColors.primaryIndigo,
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Monthly Spending Limit'),
                subtitle: Text('₹${monthlyLimit.toStringAsFixed(0)}'),
                trailing: const Icon(Icons.edit),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => MonthlyLimitDialog(
                      currentLimit: monthlyLimit,
                      onSave: onLimitChanged,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

