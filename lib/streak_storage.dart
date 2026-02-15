import 'package:shared_preferences/shared_preferences.dart';
import 'daily_stats.dart';

class StreakStorage {
  static const _key = 'scroll_streak';

  static Future<int> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key) ?? 0;
  }

  static Future<void> save(int streak) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, streak);
  }

  static Future<int> checkAndUpdate(DailyStats stats) async {
    int streak = await load();
    if (stats.scrollCount > stats.dmCount) {
      streak = streak + 1;
    } else {
      streak = 0;
    }
    await save(streak);
    return streak;
  }
}
