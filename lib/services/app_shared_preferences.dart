import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  AppSharedPreferences._internal();

  static final AppSharedPreferences _appSharedPreferences =
      AppSharedPreferences._internal();

  static AppSharedPreferences getInstance() {
    return _appSharedPreferences;
  }

  final String _kDailyGoalSteps = 'dailyGoalSteps';

  /// Method that returns the daily goal steps in counter page.
  ///
  /// Returns the user-set value, if not then fallback to `3500`.
  Future<int> getDailyGoalSteps() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kDailyGoalSteps) ?? 3500;
  }

  /// Method that saves the daily goal steps set in Daily Goal page.
  Future<bool> setDailyGoalSteps(int dailyGoal) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.setInt(
      _kDailyGoalSteps,
      dailyGoal,
    );
  }
}
