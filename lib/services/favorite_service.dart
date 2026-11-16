import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news.dart';

/// Menyimpan daftar favorit menggunakan Shared Preferences (Modul VI)
/// agar data tidak hilang ketika aplikasi ditutup.
/// Key dibuat per-user: 'favorites_<username>'.
class FavoriteService {
  static String _key(String username) => 'favorites_$username';

  /// Mengambil semua berita favorit milik user.
  static Future<List<Article>> getFavorites(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_key(username));
    if (raw == null) return [];
    final List decoded = json.decode(raw) as List;
    return decoded
        .map((item) => Article.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }

  /// Menyimpan seluruh daftar favorit user (dipanggil setiap ada perubahan).
  static Future<void> saveFavorites(
      String username, List<Article> favorites) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String raw = json.encode(
      favorites.map((c) => c.toMap()).toList(),
    );
    await prefs.setString(_key(username), raw);
  }
}
