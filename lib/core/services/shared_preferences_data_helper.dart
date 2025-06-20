import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDataHelper {
  static const String _distanceKey = 'totalDistance';
  static const String _climbingKey = 'totalClimbed';
  static const String _floorCountKey = 'floorCount';
  static const String _dateKey = 'currentDate';

  static SharedPreferences? _prefs;

  static Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> clearPreviousDistanceData() async {
    await _initPrefs();
    final keys = _prefs!.getKeys();
    for (String key in keys) {
      if (key.startsWith('${_distanceKey}_')) {
        await _prefs!.remove(key);
      }
    }
  }

  static Future<void> clearLegacyClimbingData() async {
    await _initPrefs();
    final keys = _prefs!.getKeys();
    for (String key in keys) {
      if (key.startsWith('${_climbingKey}_') || key.startsWith('${_floorCountKey}_')) {
        await _prefs!.remove(key);
      }
    }
  }

  static Future<void> clearOldClimbingData({int daysToKeep = 7}) async {
    await _initPrefs();
    final keys = _prefs!.getKeys();
    final now = DateTime.now();
    final cutoffDate = now.subtract(Duration(days: daysToKeep));

    for (String key in keys) {
      if (key.startsWith('${_climbingKey}_') || key.startsWith('${_distanceKey}_') || key.startsWith('${_floorCountKey}_')) {
        final dateStr = key.replaceFirst(RegExp(r'^(totalClimbed|totalDistance|floorCount)_'), '');
        try {
          final date = DateFormat("d MMMM, y").parse(dateStr);
          if (date.isBefore(cutoffDate)) {
            await _prefs!.remove(key);
            if (kDebugMode) {
              print('Removed old data for $dateStr');
            }
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error parsing date $dateStr: $e');
          }
        }
      }
    }
  }

  static Future<void> saveDailyTracking(double distance, String date) async {
    await _initPrefs();
    await _prefs!.setDouble('${_distanceKey}_$date', distance);
    await _prefs!.setString('${_dateKey}_lastSaved', date);
  }

  static Future<void> saveDailyClimbingTracking(
    double climbed,
    String date,
  ) async {
    await _initPrefs();
    await _prefs!.setDouble('${_climbingKey}_$date', climbed);
    await _prefs!.setString('${_dateKey}_lastSaved', date);
  }

  static Future<void> saveDailyOngoingTracking(
    double distance,
    String date,
  ) async {
    await _initPrefs();
    await _prefs!.setDouble('${_distanceKey}_$date', distance);
    await _prefs!.setString('${_dateKey}_lastSaved', date);
  }

  static Future<double?> getClimbedByDate(String date) async {
    await _initPrefs();
    final value = _prefs!.get('${_climbingKey}_$date');
    if (value is double) {
      return value;
    } else if (value is int) {
      final doubleValue = value.toDouble();
      await _prefs!.setDouble('${_climbingKey}_$date', doubleValue);
      return doubleValue;
    }
    return null;
  }

  static Future<int?> getFloorCountByDate(String date) async {
    await _initPrefs();
    final value = _prefs!. get('${_floorCountKey}_$date');
    if (value is int) {
      return value;
    } else if (value is String) {
      await _prefs!.remove('${_floorCountKey}_$date');
      return null;
    }
    return null;
  }

  static Future<String?> getLastClimbedSavedDate() async {
    await _initPrefs();
    return _prefs!.getString('${_climbingKey}_lastSaved');
  }

  static Future<double?> getDistanceByDate(String date) async {
    await _initPrefs();
    return _prefs!.getDouble('${_distanceKey}_$date');
  }

  static Future<String?> getLastSavedDate() async {
    await _initPrefs();
    return _prefs!.getString('${_dateKey}_lastSaved');
  }

  static Future<Map<String, dynamic>> getLastSavedDistance() async {
    await _initPrefs();
    final lastSavedDate = await getLastSavedDate();
    if (lastSavedDate == null) {
      final keys = _prefs!.getKeys();
      String? latestDate;
      DateTime? latestDateTime;
      for (String key in keys) {
        if (key.startsWith('${_distanceKey}_')) {
          final dateStr = key.replaceFirst('${_distanceKey}_', '');
          try {
            final date = DateFormat("d, MMMM, y").parse(dateStr);
            if (latestDateTime == null || date.isAfter(latestDateTime)) {
              latestDateTime = date;
              latestDate = dateStr;
            }
          } catch (e) {
            continue;
          }
        }
      }
      if (latestDate != null) {
        final distance = await getDistanceByDate(latestDate) ?? 0.0;
        return {'distance': distance, 'date': latestDate};
      }
      return {'distance': 0.0, 'date': ''};
    }
    final distance = await getDistanceByDate(lastSavedDate) ?? 0.0;
    return {'distance': distance, 'date': lastSavedDate};
  }

  static Future<void> clearAllData() async {
    await _initPrefs();
    await _prefs!.clear();
  }

  static String formatDate(DateTime date) {
    return DateFormat("d MMMM, y").format(date);
  }

  static Future<void> printSavedTrackingData() async {
    await _initPrefs();
    final keys = _prefs!.getKeys();

    final today = formatDate(DateTime.now());
    final yesterday = formatDate(DateTime.now().subtract(const Duration(days: 1)));

    print('=== Saved Tracking Data ===');
    for (String key in keys) {
      if (key.startsWith('${_distanceKey}_')) {
        final date = key.replaceFirst('${_distanceKey}_', '');

        // Filter: only today or yesterday
        if (date != today && date != yesterday) continue;

        final distance = await getDistanceByDate(date);
        final climbed = await getClimbedByDate(date);
        final floors = await getFloorCountByDate(date);

        print('Date: $date, Distance: ${distance?.toStringAsFixed(2) ?? '0.00'} meters, '
              'Climbed: ${climbed?.toStringAsFixed(2) ?? '0.00'} meters, Floors: ${floors ?? 0}');
      }
    }

    final lastSavedDate = await getLastSavedDate();
    print('Last Saved Date: ${lastSavedDate ?? 'None'}');
    print('==========================');
  }
}