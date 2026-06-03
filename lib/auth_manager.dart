import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static Future<bool> saveUser(String name, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', name);
      await prefs.setString('pass', password);
      return true;
    } catch (e) {
      return false; // Prevents crash if storage fails
    }
  }

  static Future<Map<String, String?>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name'),
      'pass': prefs.getString('pass'),
    };
  }
}