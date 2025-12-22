import 'package:flutter/material.dart';

class AppColors {
  // Light Mode Colors
  // Primary Colors
  static const Color primaryIndigo = Color(0xFF6366F1);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentCyan = Color(0xFF06B6D4);

  // Functional Colors
  static const Color incomeGreen = Color(0xFF10B981);
  static const Color expenseRed = Color(0xFFEF4444);
  static const Color warningAmber = Color(0xFFF59E0B);

  // Chart Colors (Light Mode)
  static const List<Color> chartColors = [
    Color(0xFF6366F1), // Indigo
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFFF59E0B), // Amber
    Color(0xFF06B6D4), // Cyan
    Color(0xFF10B981), // Emerald
    Color(0xFFF97316), // Orange
  ];

  // Background & Surfaces (Light Mode)
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color borderSlate = Color(0xFFE2E8F0);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);

  // Income/Expense backgrounds (lighter versions)
  static const Color incomeBackground = Color(0xFFD1FAE5);
  static const Color expenseBackground = Color(0xFFFEE2E2);

  // Dark Mode Colors
  // Background Layers
  static const Color darkSlate900 = Color(0xFF0F172A);
  static const Color darkSlate800 = Color(0xFF1E293B);
  static const Color darkSlate700 = Color(0xFF334155);

  // Accent Colors (Lighter for dark mode)
  static const Color lightIndigo = Color(0xFF818CF8);
  static const Color lightPurple = Color(0xFFA78BFA);
  static const Color lightCyan = Color(0xFF22D3EE);

  // Functional Colors (Dark Mode)
  static const Color darkEmerald = Color(0xFF34D399);
  static const Color darkRose = Color(0xFFFB7185);
  static const Color darkAmber = Color(0xFFFBBF24);

  // Text Colors (Dark Mode)
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);
  static const Color darkTextTertiary = Color(0xFF94A3B8);

  // Chart Colors (Dark Mode)
  static const List<Color> darkChartColors = [
    Color(0xFF818CF8), // Light Indigo
    Color(0xFFA78BFA), // Light Purple
    Color(0xFFF472B6), // Light Pink
    Color(0xFFFBBF24), // Amber
    Color(0xFF22D3EE), // Cyan
    Color(0xFF34D399), // Emerald
    Color(0xFFFB923C), // Orange
  ];

  // Dark tinted backgrounds for category cards
  static const Color darkIncomeBackground = Color(0xFF1A3A32);
  static const Color darkExpenseBackground = Color(0xFF3A1A1F);

  // Gradient for cards
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryIndigo, accentPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkPrimaryGradient = LinearGradient(
    colors: [lightIndigo, lightPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
