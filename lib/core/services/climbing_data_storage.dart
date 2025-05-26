import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ClimbingDataStorage {
  static const String _climbingDataKey = 'climbing_data';
  Future<void> saveClimbingData(double totalClimbed, String date) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> climbingDataList = prefs.getStringList(_climbingDataKey) ?? [];

    final data = {
      'totalClimbed': totalClimbed,
      'date': date,
    };

    climbingDataList.add(jsonEncode(data));

    await prefs.setStringList(_climbingDataKey, climbingDataList);

    print('Saved Climbing Data: totalClimbed: $totalClimbed meters, date: $date');
  }

  Future<List<Map<String, dynamic>>> getClimbingData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> climbingDataList = prefs.getStringList(_climbingDataKey) ?? [];

    return climbingDataList
        .map((data) => jsonDecode(data) as Map<String, dynamic>)
        .toList();
  }
}