import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class TrackingDataStorage {
  // Save the distance for a given date
  static Future<void> saveDailyTracking(double distance, String date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('distance_$date', distance);
      await prefs.setString('last_saved_date', date); // Store last saved date
      debugPrint('Saved distance: $distance meters for date: $date');
    } catch (e) {
      debugPrint('Error saving distance for $date: $e');
      throw Exception('Failed to save distance for $date: $e');
    }
  }

  // Retrieve the distance for a given date
  static Future<double> getDailyTracking(String date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final distance = prefs.getDouble('distance_$date') ?? 0.0;
      debugPrint('Retrieved distance: $distance meters for date: $date');
      return distance;
    } catch (e) {
      debugPrint('Error retrieving distance for $date: $e');
      throw Exception('Failed to retrieve distance for $date: $e');
    }
  }

  // Retrieve the most recent saved distance and its date
  static Future<Map<String, dynamic>> getLastSavedDistance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastDate = prefs.getString('last_saved_date') ?? '';
      if (lastDate.isEmpty) {
        debugPrint('No last saved date found');
        return {'distance': 0.0, 'date': ''};
      }
      final distance = prefs.getDouble('distance_$lastDate') ?? 0.0;
      debugPrint(
        'Retrieved last saved distance: $distance meters for date: $lastDate',
      );
      return {'distance': distance, 'date': lastDate};
    } catch (e) {
      debugPrint('Error retrieving last saved distance: $e');
      return {'distance': 0.0, 'date': ''};
    }
  }
}
