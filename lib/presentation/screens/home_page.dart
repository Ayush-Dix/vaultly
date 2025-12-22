import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/transaction_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_colors.dart';
import '../cubits/transaction/transaction_cubit.dart';
import '../cubits/transaction/transaction_state.dart';
import '../cubits/settings/settings_cubit.dart';
import '../cubits/settings/settings_state.dart';
import '../widgets/add_transaction_dialog.dart';
import '../widgets/edit_transaction_dialog.dart';
import 'transactions_screen.dart';
import 'analytics_screen.dart';
import 'settings_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadSampleDataIfNeeded();
  }

  void _loadSampleDataIfNeeded() {
    final transactionCubit = context.read<TransactionCubit>();
    final state = transactionCubit.state;

    // Load sample data only if there are no transactions
    if (state is TransactionLoaded && state.transactions.isEmpty) {
      transactionCubit.loadSampleData();
    }
  }

  void _checkSpendingLimit() {
    final transactionCubit = context.read<TransactionCubit>();
    final settingsCubit = context.read<SettingsCubit>();
    final monthlyLimit = settingsCubit.currentMonthlyLimit;

    if (transactionCubit.shouldShowWarning(monthlyLimit)) {
      final monthlyExpenses = transactionCubit.getMonthlyExpenses();
      final percentage = (monthlyExpenses / monthlyLimit) * 100;
      _showNotification(
        'Warning!',
        'You\'ve used ${percentage.toStringAsFixed(0)}% of your monthly limit',
      );
    } else if (transactionCubit.shouldShowAlert(monthlyLimit)) {
      _showNotification(
        'Alert!',
        'You\'ve exceeded your monthly spending limit!',
      );
    }
  }

  void _showNotification(String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title $message'),
        backgroundColor: AppColors.warningAmber,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, transactionState) {
        return BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, settingsState) {
            if (transactionState is TransactionLoading ||
                settingsState is SettingsLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (transactionState is TransactionError) {
              return Scaffold(
                body: Center(child: Text('Error: ${transactionState.message}')),
              );
            }

            if (settingsState is SettingsError) {
              return Scaffold(
                body: Center(child: Text('Error: ${settingsState.message}')),
              );
            }

            final transactions = transactionState is TransactionLoaded
                ? transactionState.transactions
                : <Transaction>[];
            final monthlyLimit = settingsState is SettingsLoaded
                ? settingsState.monthlyLimit
                : AppConstants.defaultMonthlyLimit;
            final isDarkMode = settingsState is SettingsLoaded
                ? settingsState.isDarkMode
                : false;

            final List<Widget> pages = [
              TransactionsScreen(
                transactions: transactions,
                onDelete: (id) {
                  context.read<TransactionCubit>().deleteTransaction(id);
                },
                onEdit: (transaction) {
                  showDialog(
                    context: context,
                    builder: (ctx) => EditTransactionDialog(
                      transaction: transaction,
                      onUpdate: (updatedTransaction) {
                        context.read<TransactionCubit>().updateTransaction(
                          updatedTransaction,
                        );
                        _checkSpendingLimit();
                      },
                    ),
                  );
                },
              ),
              AnalyticsScreen(
                transactions: transactions,
                monthlyLimit: monthlyLimit,
              ),
              SettingsScreen(
                monthlyLimit: monthlyLimit,
                isDarkMode: isDarkMode,
                onLimitChanged: (limit) {
                  context.read<SettingsCubit>().updateMonthlyLimit(limit);
                  _checkSpendingLimit();
                },
                onDarkModeChanged: (value) {
                  context.read<SettingsCubit>().updateDarkMode(value);
                },
              ),
            ];

            return Scaffold(
              appBar: AppBar(
                title: const Text(AppConstants.appTitle),
                elevation: 2,
              ),
              body: pages[_selectedIndex],
              bottomNavigationBar: NavigationBar(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.list),
                    label: 'Transactions',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.analytics),
                    label: 'Analytics',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
              ),
              floatingActionButton: _selectedIndex == 0
                  ? FloatingActionButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AddTransactionDialog(
                            onAdd: (transaction) {
                              context.read<TransactionCubit>().addTransaction(
                                transaction,
                              );
                              _checkSpendingLimit();
                            },
                          ),
                        );
                      },
                      child: const Icon(Icons.add),
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}
