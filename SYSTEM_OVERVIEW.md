# Vaultly - Expense Tracker System Overview

## Project Information
- **App Name**: Vaultly
- **Platform**: Flutter (Cross-platform - Android, iOS, Web, Desktop)
- **Currency**: Indian Rupee (₹)
- **Number Format**: Whole numbers (no decimals)

## Project Structure

```
lib/
  main.dart
  core/
    constants/
      app_constants.dart
      app_colors.dart
    utils/
      date_formatter.dart
      transaction_helper.dart
  data/
    models/
      transaction_model.dart
      transaction_model.g.dart
    repositories/
      transaction_repository.dart
      settings_repository.dart
    sample_data.dart
  presentation/
    cubits/
      transaction/
        transaction_cubit.dart
        transaction_state.dart
      settings/
        settings_cubit.dart
        settings_state.dart
    screens/
      home_page.dart
      transactions_screen.dart
      analytics_screen.dart
      settings_screen.dart
    widgets/
      (Dialogs, Charts, Cards, Pickers - see detailed list below)
```

## Main Components

### 1. **main.dart**
- App entry point. Initializes Hive, repositories, and launches the app.
- Sets up Bloc providers for state management.
- App name: "Vaultly"

### 2. **core/**
- **constants/**: 
  - `app_constants.dart`: App title, default values, categories, notification thresholds
  - `app_colors.dart`: Complete color palette for light/dark themes
- **utils/**: 
  - `date_formatter.dart`: Date formatting utilities
  - `transaction_helper.dart`: Transaction calculations (all-time, monthly, yearly aggregations)

### 3. **data/**
- **models/**: 
  - `transaction_model.dart`: Transaction entity with Hive adapters
  - Fields: id, title, amount, date, category, type (expense/income)
- **repositories/**: 
  - `transaction_repository.dart`: CRUD operations for transactions
  - `settings_repository.dart`: Manages monthly limit and dark mode settings
  - Both use Hive for local persistence
- **sample_data.dart**: Optional sample transactions for demo

### 4. **presentation/**

#### Screens:
- **home_page.dart**: 
  - Bottom navigation with 3 tabs: Transactions, Analytics, Settings
  - Spending limit notifications
  - Sample data loader
  
- **transactions_screen.dart**: 
  - Transaction list grouped by date
  - Advanced filtering (by date, month, or year)
  - Add/Edit/Delete functionality
  - FilterMode enum: none, date, month, year
  
- **analytics_screen.dart**: 
  - Defaults to current month view
  - Time period filters: All Time, Month, Year
  - Multiple data visualizations
  - GitHub-style activity heat map
  
- **settings_screen.dart**: 
  - Dark mode toggle with persistence
  - Monthly spending limit configuration

#### Widgets (Modular Components):

**Dialogs:**
- `add_transaction_dialog.dart`: Form to add new transactions
- `edit_transaction_dialog.dart`: Form to edit existing transactions
- `monthly_limit_dialog.dart`: Set monthly spending limit

**Charts & Visualizations:**
- `expense_pie_chart.dart`: Category breakdown (expenses/income toggle)
- `monthly_overview_bar_chart.dart`: Monthly expenses vs income bars
- `expense_heat_map_card.dart`: GitHub-style calendar heat map
  - Daily view for month filter (7 columns)
  - Monthly view for year filter (4 columns)
  - Tap to show expense amount in header
  - Intensity-based coloring (4 levels)

**Cards:**
- `summary_card.dart`: Individual metric card (reusable)
- `summary_cards_row.dart`: Row of 3 cards (Expenses, Income, Net)
- `key_insights_card.dart`: Average & max spending insights
- `spending_limit_card.dart`: Progress bar for monthly limit
- `category_chart_card.dart`: Wrapper for pie chart with toggle
- `monthly_overview_card.dart`: Wrapper for bar chart

**Pickers & Filters:**
- `date_filter_picker.dart`: Modal with date/month/year filter options
- `year_month_picker.dart`: Reusable month selector grid
- `year_picker.dart`: Reusable year selector grid
- `month_filter_button.dart`: Gradient button showing current filter

**Other:**
- `transaction_item.dart`: Single transaction list item with swipe actions

## Data Flow & State Management
- Uses **flutter_bloc** for state (Cubit pattern):
  - `TransactionCubit`: Loads, adds, edits, deletes, and filters transactions
  - `SettingsCubit`: Manages dark mode and monthly limit
- Data is persisted with **Hive** (NoSQL, local storage)
- UI reacts to state changes via BlocBuilder
- Real-time updates with Hive streams

## Theming
- Full support for light and dark mode
- Theme-aware components throughout
- Colors defined in `app_colors.dart`:
  - **Light Mode**: Indigo, Purple, Cyan, Emerald, Red, Amber
  - **Dark Mode**: Slate 900/800/700 backgrounds, lighter accent colors
- Toggled via settings screen with Hive persistence
- Smooth transitions between themes

## Filtering & Analytics

### Transaction Filtering (3 modes):
1. **By Date**: Specific calendar date
2. **By Month**: All transactions in a month/year
3. **By Year**: All transactions in a year

### Analytics Dashboard:
- **Time Period Selection**: All Time, Current Month (default), or Year
- **Summary Cards**: Total expenses, income, net amount
- **Key Insights**: 
  - Average daily spending
  - Highest spending day
- **Spending Limit**: Visual progress bar with percentage
- **Category Breakdown**: Toggleable pie chart (expenses vs income)
- **Activity Heat Map**: GitHub-style calendar showing spending intensity
- **Monthly Overview**: Bar chart comparing expenses and income

### Helper Methods (TransactionHelper):
- All-time calculations: `calculateAllTimeExpenses/Income`, `getAllTimeCategoryExpenses/Income`
- Monthly calculations: `calculateExpensesForMonth`, `getCategoryExpensesForMonth`
- Yearly calculations: `calculateExpensesForYear`, `getCategoryExpensesForYear`
- Insights: `calculateAverageDailyExpense`, `getMaxSpendingDay`
- Grouping: `groupTransactionsByDate`

## Key Features
1. ✅ **Complete CRUD Operations** - Add, Edit, Delete transactions
2. ✅ **Advanced Filtering** - By specific date, month, or year
3. ✅ **Dark Mode** - Full theme support with persistence
4. ✅ **Analytics Dashboard** - Multiple charts and insights
5. ✅ **Activity Heat Map** - GitHub-style visualization
6. ✅ **Spending Limits** - Set and track monthly budgets
7. ✅ **Category Management** - Predefined categories for expenses and income
8. ✅ **Local Persistence** - All data saved with Hive
9. ✅ **Currency Support** - Indian Rupee (₹) with whole number display
10. ✅ **Responsive UI** - Works on all screen sizes

## Extensibility
- Modular widget structure for easy feature addition
- All business logic separated from UI (Clean Architecture)
- Reusable components (pickers, cards, charts)
- New categories can be added in `app_constants.dart`
- New chart types can be added as separate widget files
- Easy to extend filtering logic with new FilterMode options

## Technical Stack
- **Framework**: Flutter 3.9.2+
- **State Management**: flutter_bloc ^8.1.6 (Cubit pattern)
- **Local Storage**: Hive ^2.2.3 + hive_flutter ^1.1.0
- **Charts**: fl_chart ^0.66.2
- **Fonts**: google_fonts ^6.1.0 (Poppins)
- **Utilities**: intl ^0.18.1, equatable
- **Code Generation**: build_runner, hive_generator

---

**This overview covers the complete structure, all major components, and recent enhancements of the Vaultly expense tracker project.**
