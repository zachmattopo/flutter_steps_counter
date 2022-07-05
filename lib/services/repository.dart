import 'package:flutter_steps_counter/services/app_shared_preferences.dart';
import 'package:flutter_steps_counter/services/health_service.dart';

class Repository {
  Repository._internal();

  static final Repository _repository = Repository._internal();

  static Repository get() {
    return _repository;
  }

  final HealthService _healthService = HealthService();

  Future<bool> checkSpecialPermission() =>
      _healthService.checkSpecialPermission();

  Future<bool> checkHealthAccessPermission() =>
      _healthService.checkHealthAccessPermission();

  Future<Map<String, int>> getHealthData() => _healthService.getHealthData();

  Future<bool> setDailyGoalSteps(int steps) =>
      AppSharedPreferences.getInstance().setDailyGoalSteps(steps);

  Future<int> getDailyGoalSteps() =>
      AppSharedPreferences.getInstance().getDailyGoalSteps();
}
