import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';

/// Bookmark disimpan per akun menggunakan key bookmarks_<username>.
class BookmarkService {
  static String _key(String username) => 'bookmarks_$username';

  static Future<List<Article>> getBookmarks(String username) async {
    if (username.isEmpty) return [];

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_key(username));
    if (raw == null || raw.isEmpty) return [];

    try {
      final dynamic decoded = json.decode(raw);
      if (decoded is! List) return [];

      return decoded
          .whereType<Map>()
          .map((item) => Article.fromJsonMap(
                Map<String, dynamic>.from(item),
              ))
          .toList();
    } on FormatException {
      // Abaikan data bookmark yang rusak, bukan menghapus akun atau session.
      return [];
    } on TypeError {
      return [];
    }
  }

  static Future<void> saveBookmarks(
      String username, List<Article> articles) async {
    if (username.isEmpty) return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key(username),
      json.encode(articles.map((article) => article.toJson()).toList()),
    );
  }
}
