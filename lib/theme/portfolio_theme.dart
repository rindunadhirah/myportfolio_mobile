import 'package:material_ui/material_ui.dart';

/// Colors shared with the Django portfolio website.
abstract final class PortfolioPalette {
  static const navy = Color(0xFF071426);
  static const navySoft = Color(0xFF10233B);
  static const white = Color(0xFFFFFFFF);
  static const brown = Color(0xFF956247);
  static const brownDark = Color(0xFF684231);
  static const nudeCream = Color(0xFFEAD8C7);
}

/// Builds one consistent visual theme for every portfolio screen.
ThemeData buildPortfolioTheme() {
  final colorScheme = ColorScheme.fromSeed(seedColor: PortfolioPalette.navy)
      .copyWith(
        primary: PortfolioPalette.navy,
        onPrimary: PortfolioPalette.white,
        secondary: PortfolioPalette.brown,
        onSecondary: PortfolioPalette.white,
        tertiary: PortfolioPalette.nudeCream,
        onTertiary: PortfolioPalette.navy,
        surface: PortfolioPalette.white,
        onSurface: PortfolioPalette.navy,
      );

  final baseTheme = ThemeData(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: PortfolioPalette.white,
    useMaterial3: true,
  );

  return baseTheme.copyWith(
    textTheme: baseTheme.textTheme.apply(
      bodyColor: PortfolioPalette.navy,
      displayColor: PortfolioPalette.navy,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: PortfolioPalette.navy,
      foregroundColor: PortfolioPalette.white,
      elevation: 0,
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: PortfolioPalette.white),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: PortfolioPalette.nudeCream.withValues(alpha: 0.24),
      labelStyle: const TextStyle(color: PortfolioPalette.navySoft),
      hintStyle: TextStyle(
        color: PortfolioPalette.navySoft.withValues(alpha: 0.58),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: PortfolioPalette.brown.withValues(alpha: 0.45),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: PortfolioPalette.brown, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: PortfolioPalette.brown,
        foregroundColor: PortfolioPalette.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: PortfolioPalette.navySoft,
      contentTextStyle: TextStyle(color: PortfolioPalette.white),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
