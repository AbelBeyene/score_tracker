import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SavedGamesRepository {
  static const String _key = 'saved_games_v1';

  Future<List<Map<String, dynamic>>> fetchAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? <String>[];
    return raw
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList(growable: true);
  }

  Future<void> saveGame(Map<String, dynamic> game) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? <String>[];
    current.add(jsonEncode(game));
    await prefs.setStringList(_key, current);
  }
}
