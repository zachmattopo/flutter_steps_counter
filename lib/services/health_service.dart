import 'dart:io';

import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthService {
  HealthFactory health = HealthFactory();

  /// On Android, health data is labeled as `dangerous` protection level,
  /// the Android permission system will not grant it automatically and
  /// it requires the user's action.
  ///
  /// Returns `true` if has special permission granted, `false` otherwise.
  ///
  /// On iOS, this is not needed and will return `true` by default.
  Future<bool> checkSpecialPermission() async {
    if (Platform.isAndroid) {
      // Special handling for Android only
      final permissionStatus = Permission.activityRecognition.request();

      if (await permissionStatus.isDenied ||
          await permissionStatus.isPermanentlyDenied) {
        // Permission denied, return false
        return false;
      } else {
        // Permission granted, return true
        return true;
      }
    } else {
      // Platform is iOS, special permission is not needed
      return true;
    }
  }

  /// Checks for health access permission required on both platforms
  /// (iOS and Android). If don't have access, this will request for it.
  ///
  /// Returns `true` if granted access, `false` otherwise.
  Future<bool> checkHealthAccessPermission() async {
    // List of data types that we want to get
    final types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ];

    // Check if we have permissions to access health data
    final hasPermissions = await HealthFactory.hasPermissions(
      types,
    );

    if (hasPermissions == null || !hasPermissions) {
      // Not permitted to get data, request permission
      final granted = await health.requestAuthorization(
        types,
      );

      if (!granted) {
        // Permission denied, return false
        return false;
      } else {
        // Permission is now granted by user, return true
        return true;
      }
    } else {
      // Permission is already granted previously, return true
      return true;
    }
  }

  /// Fetches the health data from HealthKit (iOS) and Google Fit (Android).
  /// Will check for permission to access
  ///
  /// Returns the data in the following `Map` format:
  /// ```dart
  /// {
  ///   'totalSteps': 300,
  ///   'totalCalories': 25,
  /// }
  /// ```
  ///
  /// NOTE: Please run [checkSpecialPermission] and
  /// [checkHealthAccessPermission] before running this method.
  Future<Map<String, int>> getHealthData() async {
    // List of data types that we want to get
    final types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ];

    // Get steps & calories for today (i.e. since midnight) from the plugin
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    final healthDataList = await health.getHealthDataFromTypes(
      midnight,
      now,
      types,
    );

    // Count the steps and calories in the returned list
    var totalStepsDouble = 0.0;
    var totalCaloriesDouble = 0.0;

    for (final dataPoint in healthDataList) {
      if (dataPoint.type == HealthDataType.STEPS) {
        // Count as steps
        totalStepsDouble += double.tryParse(dataPoint.value.toString()) ?? 0.0;
      } else if (dataPoint.type == HealthDataType.ACTIVE_ENERGY_BURNED) {
        // Count as calories
        totalCaloriesDouble +=
            double.tryParse(dataPoint.value.toString()) ?? 0.0;
      }
    }

    // Return the steps and calories in a `Map`
    final dataMap = {
      'totalSteps': totalStepsDouble.round(),
      'totalCalories': totalCaloriesDouble.round(),
    };

    return dataMap;
  }
}
