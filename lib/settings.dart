import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static const String _selectedGroupKey = 'selectedGroup';
  static String selectedGroup = 'group1'; // Значение по умолчанию

  static Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedGroup = prefs.getString(_selectedGroupKey) ?? selectedGroup;
  }

  static Future<void> saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedGroupKey, selectedGroup);
  }
}
