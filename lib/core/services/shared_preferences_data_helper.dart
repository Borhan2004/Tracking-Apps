import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesDataHelper {
  static const String _distanceKey = 'totalDistance';
  static const String _dateKey = 'currentDate';

  /// Save distance and date
  static Future<void> saveDailyTracking(double distance, String date) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('${_distanceKey}_$date', distance);
    await prefs.setString('${_dateKey}_lastSaved', date);
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
