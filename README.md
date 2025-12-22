# 💰 Vaultly - Smart Expense Tracker

<div align="center">

**A beautiful, feature-rich expense tracking application built with Flutter**

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.2+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Tech Stack](#-tech-stack) • [Architecture](#-architecture)

</div>

---

## 📋 Overview

Vaultly is a comprehensive expense tracking solution designed to help you manage your finances with ease. Built with Flutter for cross-platform compatibility, it offers powerful analytics, intuitive visualizations, and a clean user interface that works seamlessly across Android, iOS, Web, and Desktop platforms.

## ✨ Features

### 💳 Transaction Management
- **Complete CRUD Operations** - Add, edit, and delete transactions effortlessly
- **Categorized Tracking** - Predefined categories for both expenses and income
- **Smart Date Handling** - Record transactions with precise date and time

### 📊 Advanced Analytics
- **Multiple Chart Types** - Pie charts, bar charts, and GitHub-style heat maps
- **Time-Based Filtering** - View data by specific date, month, or year
- **Key Insights Dashboard** - Track average daily spending and highest spending days
- **Category Breakdown** - Visualize spending patterns across different categories
- **Activity Heat Map** - GitHub-style visualization showing spending intensity

### 🎨 User Experience
- **Dark Mode Support** - Full theme support with seamless switching
- **Responsive Design** - Optimized for all screen sizes and orientations
- **Intuitive Navigation** - Clean bottom navigation with organized sections
- **Monthly Budget Tracking** - Set spending limits and track progress visually

### 💾 Data & Performance
- **Local-First Storage** - Fast, offline-capable data persistence with Hive
- **Real-Time Updates** - Instant UI updates using BLoC state management
- **No Backend Required** - All data stored locally for privacy and speed


## 🚀 Installation

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK (3.9.2 or higher)
- Android Studio / VS Code with Flutter extensions
- Git

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/vaultly.git
   cd vaultly
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate required files**
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
- Minimum SDK: 21 (Android 5.0)
- Target SDK: 34 (Android 14)

#### iOS
- Minimum iOS version: 12.0
- Xcode 14.0 or higher required

#### Web
```bash
flutter run -d chrome
```

#### Desktop (Windows/macOS/Linux)
```bash
flutter run -d windows  # or macos, linux
```

## 📖 Usage

### Adding Transactions
1. Navigate to the **Transactions** tab
2. Tap the **+** floating action button
3. Fill in transaction details (title, amount, category, date)
4. Choose transaction type (Expense or Income)
5. Save to add to your records

### Filtering Data
- **By Date**: Select a specific day to view transactions
- **By Month**: View all transactions for a selected month
- **By Year**: Analyze yearly spending patterns

### Analytics Dashboard
- View comprehensive statistics on the **Analytics** tab
- Default view shows current month data
- Toggle between expense and income categories in pie charts
- Monitor spending limits with visual progress indicators
- Explore daily/monthly activity heat maps

### Settings
- Toggle dark mode for comfortable viewing
- Set monthly spending limits
- Load sample data for testing

## 🛠️ Tech Stack

### Framework & Language
- **Flutter** - UI framework for cross-platform development
- **Dart** - Programming language

### State Management
- **flutter_bloc (8.1.6)** - Predictable state management using Cubit pattern

### Data & Storage
- **Hive (2.2.3)** - Fast, lightweight NoSQL database
- **hive_flutter** - Flutter integration for Hive

### Visualization
- **fl_chart (0.66.2)** - Beautiful, customizable charts

### Utilities
- **intl (0.18.1)** - Internationalization and date formatting
- **google_fonts (6.1.0)** - Beautiful typography (Poppins)
- **equatable** - Value equality for state management

### Development Tools
- **build_runner** - Code generation
- **hive_generator** - Generate Hive type adapters
- **flutter_launcher_icons** - Custom app icons

## 🏗️ Architecture

Vaultly follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/
│   ├── constants/      # App-wide constants (colors, categories, etc.)
│   └── utils/          # Helper functions and utilities
├── data/
│   ├── models/         # Data models with Hive adapters
│   └── repositories/   # Data access layer (CRUD operations)
└── presentation/
    ├── cubits/         # State management (BLoC pattern)
    ├── screens/        # Main UI screens
    └── widgets/        # Reusable UI components
```

### Key Design Patterns
- **Repository Pattern** - Abstracts data sources
- **BLoC/Cubit Pattern** - Separates business logic from UI
- **Widget Composition** - Modular, reusable components

## 📐 Project Structure

### Core Modules
- **Transaction Management** - Add, edit, delete, and filter transactions
- **Analytics Engine** - Calculate statistics and generate insights
- **Settings Management** - Persist user preferences
- **Theme System** - Dynamic light/dark mode switching

### Widget Library
24+ reusable components including:
- Dialogs (Add/Edit Transaction, Monthly Limit)
- Charts (Pie, Bar, Heat Map)
- Cards (Summary, Insights, Category, Limit)
- Pickers (Date, Month, Year)
- And more...

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Coding Standards
- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Write meaningful commit messages
- Add comments for complex logic
- Ensure no linting errors before committing

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Contributors to all open-source packages used
- Community for inspiration and feedback

<div align="center">

**Made with ❤️ using Flutter**

If you found this project helpful, please consider giving it a ⭐️

</div>
