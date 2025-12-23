import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences? _prefs;

  ThemeCubit({SharedPreferences? prefs})
    : _prefs = prefs,
      super(ThemeMode.system) {
    _loadTheme();
  }

  void toggleTheme(bool isDark) async {
    final mode = isDark ? ThemeMode.dark : ThemeMode.light;
    emit(mode);
    if (_prefs != null) {
      await _prefs.setBool('is_dark_mode', isDark);
    } else {
      // Fallback if prefs failed to load initially
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_dark_mode', isDark);
    }
  }

  Future<void> _loadTheme() async {
    if (_prefs != null) {
      final isDark = _prefs.getBool('is_dark_mode');
      if (isDark != null) {
        emit(isDark ? ThemeMode.dark : ThemeMode.light);
      }
    } else {
      // Lazy load attempts skipped to prevent startup hang
      // Default to system
    }
  }
}