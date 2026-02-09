import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'session.dart';

class SessionStorage {
  static const _key = 'active_session';
  static Future<Session?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;

    final map = jsonDecode(jsonString);
    return Session.fromMap(map);
  }

  static Future<void> save(Session session) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(session.toMap());
    await prefs.setString(_key, jsonString);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
