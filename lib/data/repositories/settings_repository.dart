import 'package:hive_flutter/hive_flutter.dart';

class SettingsRepository {
  static const String _boxName = 'settings';
  static const String _monthlyLimitKey = 'monthly_limit';
  static const String _darkModeKey = 'dark_mode';
  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  Future<void> setMonthlyLimit(double limit) async {
    await _box.put(_monthlyLimitKey, limit);
  }

  double getMonthlyLimit({double defaultValue = 5000.0}) {
    return _box.get(_monthlyLimitKey, defaultValue: defaultValue);
  }

  Stream<double> watchMonthlyLimit({double defaultValue = 5000.0}) {
    return _box
        .watch(key: _monthlyLimitKey)
        .map((event) => event.value ?? defaultValue);
  }

  Future<void> setDarkMode(bool isDarkMode) async {
    await _box.put(_darkModeKey, isDarkMode);
  }

  bool getDarkMode({bool defaultValue = false}) {
    return _box.get(_darkModeKey, defaultValue: defaultValue);
  }

  Stream<bool> watchDarkMode({bool defaultValue = false}) {
    return _box
        .watch(key: _darkModeKey)
        .map((event) => event.value ?? defaultValue);
  }
}
