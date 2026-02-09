import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'daily_stats.dart';

class DailyStatsStorage {
  static const _key = 'daily_stats';

  static Future<DailyStats> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) {
      return DailyStats(date: DateTime.now());
    }

    final map = jsonDecode(jsonString);
    final savedStats = DailyStats.fromMap(map);

    final today = DateTime.now();
    final savedDate = savedStats.date;

    if (today.year == savedDate.year &&
        today.month == savedDate.month &&
        today.day == savedDate.day) {
      return savedStats;
    } else {
      return DailyStats(date: DateTime.now());
    }
  }

  static Future<void> save(DailyStats dailyStats) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(dailyStats.toMap());
    await prefs.setString(_key, jsonString);
  }
}
