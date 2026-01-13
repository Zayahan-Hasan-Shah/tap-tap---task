import 'package:flutter/material.dart';

class AppColors {
  static bool _isDark = false;
  
  static void setDarkMode(bool isDark) => _isDark = isDark;

  // Primary colors
  static Color get primary => _isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E3A5F);
  static Color get primaryLight => _isDark ? const Color(0xFF93C5FD) : const Color(0xFF2E5077);
  static Color get primaryDark => _isDark ? const Color(0xFF3B82F6) : const Color(0xFF0F2744);

  // Accent colors
  static Color get accent => const Color(0xFF3498DB);
  static Color get accentLight => const Color(0xFF5DADE2);

  // Background colors
  static Color get background => _isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
  static Color get surface => _isDark ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF);
  static Color get cardBackground => _isDark ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF);

  // Sidebar
  static Color get sidebarBackground => _isDark ? const Color(0xFF0F172A) : const Color(0xFF1E3A5F);
  static Color get sidebarItemHover => _isDark ? const Color(0xFF1E293B) : const Color(0xFF2E5077);
  static Color get sidebarItemActive => const Color(0xFF3498DB);

  // Text colors
  static Color get textPrimary => _isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1A202C);
  static Color get textSecondary => _isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  static Color get textLight => const Color(0xFFFFFFFF);
  static Color get textMuted => _isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Border colors
  static Color get border => _isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  static Color get divider => _isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

  // Table colors
  static Color get tableHeader => _isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
  static Color get tableRowHover => _isDark ? const Color(0xFF334155) : const Color(0xFFF8FAFC);
  static Color get tableRowAlt => _isDark ? const Color(0xFF1E293B) : const Color(0xFFFAFBFC);
}

class AppTheme {
  static ThemeData get lightTheme {
    AppColors.setDarkMode(false);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color(0xFF1E3A5F),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF1E3A5F),
        primaryContainer: Color(0xFF2E5077),
        secondary: Color(0xFF3498DB),
        secondaryContainer: Color(0xFF5DADE2),
        surface: Color(0xFFFFFFFF),
        error: Color(0xFFEF4444),
        onPrimary: Color(0xFFFFFFFF),
        onSecondary: Color(0xFFFFFFFF),
        onSurface: Color(0xFF1A202C),
        onError: Color(0xFFFFFFFF),
      ),
      appBarTheme:  AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textLight,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: AppColors.cardBackground,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side:  BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:  BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:  BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:  BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle:  TextStyle(color: AppColors.textSecondary),
        hintStyle:  TextStyle(color: AppColors.textMuted),
      ),
      dividerTheme:  DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
      iconTheme:  IconThemeData(
        color: AppColors.textSecondary,
        size: 24,
      ),
      dataTableTheme: DataTableThemeData(
        headingRowColor: WidgetStateProperty.all(AppColors.tableHeader),
        dataRowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return AppColors.tableRowHover;
          }
          return AppColors.surface;
        }),
        headingTextStyle:  TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          fontSize: 14,
        ),
        dataTextStyle:  TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        backgroundColor: AppColors.surface,
        titleTextStyle:  TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      floatingActionButtonTheme:  FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textLight,
        elevation: 4,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.textLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    AppColors.setDarkMode(true);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF60A5FA),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF60A5FA),
        primaryContainer: Color(0xFF3B82F6),
        secondary: Color(0xFF3498DB),
        secondaryContainer: Color(0xFF5DADE2),
        surface: Color(0xFF1E293B),
        error: Color(0xFFEF4444),
        onPrimary: Color(0xFF0F172A),
        onSecondary: Color(0xFF0F172A),
        onSurface: Color(0xFFF1F5F9),
        onError: Color(0xFFFFFFFF),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF1E293B),
        foregroundColor: Color(0xFFF1F5F9),
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF1F5F9),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: const Color(0xFF1E293B),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3498DB),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF60A5FA), width: 2),
        ),
        labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
        hintStyle: const TextStyle(color: Color(0xFF64748B)),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF334155),
        thickness: 1,
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFF94A3B8),
        size: 24,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        backgroundColor: const Color(0xFF1E293B),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF1F5F9),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF3498DB),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E293B),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF334155)),
          ),
        ),
      ),
    );
  }
}
