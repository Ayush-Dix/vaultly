// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_constants.dart';
import 'core/constants/app_colors.dart';
import 'data/models/transaction_model.dart';
import 'data/repositories/transaction_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'presentation/cubits/transaction/transaction_cubit.dart';
import 'presentation/cubits/settings/settings_cubit.dart';
import 'presentation/cubits/settings/settings_state.dart';
import 'presentation/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive Adapters
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TransactionTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(TransactionAdapter());
  }

  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatefulWidget {
  const ExpenseTrackerApp({super.key});

  @override
  State<ExpenseTrackerApp> createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  late TransactionRepository transactionRepository;
  late SettingsRepository settingsRepository;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeRepositories();
  }

  Future<void> _initializeRepositories() async {
    transactionRepository = TransactionRepository();
    await transactionRepository.init();

    settingsRepository = SettingsRepository();
    await settingsRepository.init();

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: transactionRepository),
        RepositoryProvider.value(value: settingsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                TransactionCubit(transactionRepository)..loadTransactions(),
          ),
          BlocProvider(
            create: (context) =>
                SettingsCubit(settingsRepository)..loadSettings(),
          ),
        ],
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, settingsState) {
            final isDarkMode = settingsState is SettingsLoaded
                ? settingsState.isDarkMode
                : false;

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: AppConstants.appTitle,
              theme: _buildLightTheme(context),
              darkTheme: _buildDarkTheme(context),
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              home: const HomePage(),
            );
          },
        ),
      ),
    );
  }

  ThemeData _buildLightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryIndigo,
        primary: AppColors.primaryIndigo,
        secondary: AppColors.accentPurple,
        tertiary: AppColors.accentCyan,
        surface: AppColors.surfaceWhite,
        background: AppColors.backgroundLight,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryIndigo,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentPurple,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceWhite,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.borderSlate.withOpacity(0.2)),
        ),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
          .apply(
            bodyColor: AppColors.textPrimary,
            displayColor: AppColors.textPrimary,
          ),
    );
  }

  ThemeData _buildDarkTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.lightIndigo,
        brightness: Brightness.dark,
        primary: AppColors.lightIndigo,
        secondary: AppColors.lightPurple,
        tertiary: AppColors.lightCyan,
        surface: AppColors.darkSlate800,
        background: AppColors.darkSlate900,
      ),
      scaffoldBackgroundColor: AppColors.darkSlate900,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSlate800,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.lightPurple,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSlate800,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.darkSlate700.withOpacity(0.5)),
        ),
      ),
      dividerColor: AppColors.darkSlate700,
      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
          .apply(
            bodyColor: AppColors.darkTextPrimary,
            displayColor: AppColors.darkTextPrimary,
          ),
    );
  }
}
