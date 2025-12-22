import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  static const String _boxName = 'transactions';
  late Box<Transaction> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Transaction>(_boxName);
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  List<Transaction> getAllTransactions() {
    return _box.values.toList();
  }

  Transaction? getTransactionById(String id) {
    return _box.get(id);
  }

  Future<void> deleteAllTransactions() async {
    await _box.clear();
  }

  Stream<List<Transaction>> watchTransactions() {
    return _box.watch().map((_) => _box.values.toList());
  }
}
