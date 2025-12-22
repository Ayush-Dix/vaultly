import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../core/constants/app_constants.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _repository;

  SettingsCubit(this._repository) : super(SettingsInitial());

  Future<void> loadSettings() async {
    try {
      emit(SettingsLoading());
      final monthlyLimit = _repository.getMonthlyLimit(
        defaultValue: AppConstants.defaultMonthlyLimit,
      );
      final isDarkMode = _repository.getDarkMode(defaultValue: false);
      emit(SettingsLoaded(monthlyLimit, isDarkMode: isDarkMode));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> updateMonthlyLimit(double limit) async {
    try {
      await _repository.setMonthlyLimit(limit);
      final isDarkMode = currentIsDarkMode;
      emit(SettingsLoaded(limit, isDarkMode: isDarkMode));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> updateDarkMode(bool isDarkMode) async {
    try {
      await _repository.setDarkMode(isDarkMode);
      final monthlyLimit = currentMonthlyLimit;
      emit(SettingsLoaded(monthlyLimit, isDarkMode: isDarkMode));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  double get currentMonthlyLimit {
    if (state is SettingsLoaded) {
      return (state as SettingsLoaded).monthlyLimit;
    }
    return AppConstants.defaultMonthlyLimit;
  }

  bool get currentIsDarkMode {
    if (state is SettingsLoaded) {
      return (state as SettingsLoaded).isDarkMode;
    }
    return false;
  }
}
