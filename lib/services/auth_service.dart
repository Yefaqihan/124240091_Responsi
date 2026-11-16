import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Penyimpanan lokal akun (username -> data akun) menggunakan SharedPreferences.
class AuthService {
  static const String usersKey = 'users';

  static Future<Map<String, dynamic>> _getUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(usersKey);
    if (raw == null || raw.isEmpty) return {};

    try {
      final dynamic decoded = json.decode(raw);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } on FormatException {
      // Data lokal yang tidak valid tidak boleh membuat aplikasi crash.
    }
    return {};
  }

  static Future<bool> register(String username, String password) async {
    final Map<String, dynamic> users = await _getUsers();
    if (users.containsKey(username)) return false;

    users[username] = {'username': username, 'password': password};
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool saved = await prefs.setString(usersKey, json.encode(users));
    return saved;
  }

  static Future<bool> login(String username, String password) async {
    final Map<String, dynamic> users = await _getUsers();
    final dynamic user = users[username];
    if (user is! Map) return false;
    return user['password'] == password;
  }
}
