import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../../../core/constants/app_constants.dart';
import 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository _repository;

  TransactionCubit(this._repository) : super(TransactionInitial());

  Future<void> loadTransactions() async {
    try {
      emit(TransactionLoading());
      final transactions = _repository.getAllTransactions();
      emit(TransactionLoaded(transactions));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      await _repository.addTransaction(transaction);
      await loadTransactions();
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _repository.deleteTransaction(id);
      await loadTransactions();
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    try {
      await _repository.updateTransaction(transaction);
      await loadTransactions();
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> loadSampleData() async {
    try {
      final now = DateTime.now();
      final sampleTransactions = [
        Transaction(
          id: '1',
          title: 'Grocery Shopping',
          amount: 150.0,
          date: now,
          category: 'Food',
          type: TransactionType.expense,
        ),
        Transaction(
          id: '2',
          title: 'Salary',
          amount: 3000.0,
          date: now.subtract(const Duration(days: 1)),
          category: 'Salary',
          type: TransactionType.income,
        ),
        Transaction(
          id: '3',
          title: 'Uber Ride',
          amount: 25.0,
          date: now.subtract(const Duration(days: 2)),
          category: 'Transport',
          type: TransactionType.expense,
        ),
      ];

      for (var transaction in sampleTransactions) {
        await _repository.addTransaction(transaction);
      }
      await loadTransactions();
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  double getMonthlyExpenses() {
    if (state is TransactionLoaded) {
      final transactions = (state as TransactionLoaded).transactions;
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
    return 0.0;
  }

  double getMonthlyIncome() {
    if (state is TransactionLoaded) {
      final transactions = (state as TransactionLoaded).transactions;
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
    return 0.0;
  }

  bool shouldShowWarning(double monthlyLimit) {
    final expenses = getMonthlyExpenses();
    final percentage = (expenses / monthlyLimit) * 100;
    return percentage >= AppConstants.warningThreshold &&
        percentage < AppConstants.alertThreshold;
  }

  bool shouldShowAlert(double monthlyLimit) {
    final expenses = getMonthlyExpenses();
    final percentage = (expenses / monthlyLimit) * 100;
    return percentage >= AppConstants.alertThreshold;
  }
}
