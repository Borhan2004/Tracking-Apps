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

  static Future<void> saveDailyTracking(double distance, String date) async {
    await _initPrefs();
    await clearPreviousDistanceData();
    await _prefs!.setDouble('${_distanceKey}_$date', distance);
    await _prefs!.setString('${_dateKey}_lastSaved', date);
  }

  static Future<void> saveDailyClimbingTracking(
    double distance,
    int floorCount,
    String date,
  ) async {
    await _initPrefs();
    await _prefs!.setDouble('${_distanceKey}_$date', distance);
    await _prefs!.setInt('${_climbingKey}_$date', floorCount);
    await _prefs!.setString('${_floorCountKey}_$date', date);
  }

  static Future<double?> getClimbedByDate(String date) async {
    await _initPrefs();
    return _prefs!.getDouble('${_climbingKey}_$date');
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
      return {'distance': 0.0, 'date': ''};
    }
    final distance = await getDistanceByDate(lastSavedDate) ?? 0.0;
    return {'distance': distance, 'date': lastSavedDate};
  }

  static Future<void> clearAllData() async {
    await _initPrefs();
    await _prefs!.clear();
  }

  static Future<void> printSavedTrackingData() async {
    await _initPrefs();
    final keys = _prefs!.getKeys();

    print('=== Saved Tracking Data ===');
    for (String key in keys) {
      if (key.startsWith('${_distanceKey}_')) {
        final date = key.replaceFirst('${_distanceKey}_', '');
        final distance = _prefs!.getDouble(key);
        print('Date: $date, Distance: ${distance?.toStringAsFixed(2)} meters');
      }
    }
    final lastSavedDate = await getLastSavedDate();
    print('Last Saved Date: $lastSavedDate');
    print('==========================');
  }
}
