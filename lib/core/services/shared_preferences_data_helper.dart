import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDataHelper {
  static const String _distanceKey = 'totalDistance';
  static const String _climbingKey = 'totalClimbed';
  static const String _floorCountKey = 'floorCount';
  static const String _dateKey = 'currentDate';

  /// Save distance and date
  static Future<void> saveDailyTracking(double distance, String date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('${_distanceKey}_$date', distance);
    await prefs.setString('${_dateKey}_lastSaved', date);
  }

  /// Save distance and date
  static Future<void> saveDailyClimbingTracking(double distance, int floorCount, String date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('${_distanceKey}_$date', distance);
    await prefs.setInt('${_climbingKey}_$date', floorCount);
    await prefs.setString('${_floorCountKey}_$date', date);
  }

/// Get distance by date
  static Future<double?> getClimbedByDate(String date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('${_climbingKey}_$date');
  }

  /// Get the last saved date
  static Future<String?> getLastClimbedSavedDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('${_climbingKey}_lastSaved');
  }


  /// Get distance by date
  static Future<double?> getDistanceByDate(String date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('${_distanceKey}_$date');
  }

  /// Get the last saved date
  static Future<String?> getLastSavedDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('${_dateKey}_lastSaved');
  }

  /// Clear all tracking data (if needed)
  static Future<void> clearAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
