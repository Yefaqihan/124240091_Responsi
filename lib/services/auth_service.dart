import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Local database untuk menyimpan data user (register & login).
/// Menggunakan Shared Preferences (Modul VI - Local Storage) dengan
/// prinsip key-value: data tersimpan secara persisten meskipun aplikasi
/// ditutup atau di-run ulang, termasuk di web/Chrome karena disimpan
/// di localStorage browser (lebih andal daripada Hive/IndexedDB di web).
/// Key 'users' berisi Map: username -> {username, password}.
class AuthService {
  static const String usersKey = 'users';

  /// Mengambil seluruh data user yang terdaftar.
  static Future<Map<String, dynamic>> _getUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(usersKey);
    if (raw == null) return {};
    return Map<String, dynamic>.from(json.decode(raw) as Map);
  }

  /// Register user baru. Return false jika username sudah dipakai.
  static Future<bool> register(String username, String password) async {
    final Map<String, dynamic> users = await _getUsers();
    if (users.containsKey(username)) {
      return false; // username sudah terdaftar
    }
    users[username] = {'username': username, 'password': password};
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(usersKey, json.encode(users));
    return true;
  }

  /// Login: cek apakah username ada dan password cocok.
  static Future<bool> login(String username, String password) async {
    final Map<String, dynamic> users = await _getUsers();
    final dynamic user = users[username];
    if (user == null) return false;
    return user['password'] == password;
  }
}
