import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

/// Service untuk komunikasi dengan Spaceflight News API (Modul V: HTTP).
/// Base URL: https://api.spaceflightnewsapi.net/v4/articles
/// Response:
/// {
///   "count": 36904,
///   "next": "...?limit=10&offset=10",
///   "previous": null,
///   "results": [ { ...artikel... } ]
/// }
class ApiService {
  static const String baseUrl = 'https://api.spaceflightnewsapi.net/v4/articles';

  /// Mengambil daftar berita (minimal 10 berita, soal 2).
  /// Bisa diberi filter [newsSite] untuk soal 5 (filter berdasarkan
  /// sumber publikasi) — API mendukung parameter ?news_site=NASA.
  static Future<List<Article>> fetchArticles({String? newsSite}) async {
    final Map<String, String> query = {'limit': '10'};
    if (newsSite != null && newsSite.isNotEmpty) {
      query['news_site'] = newsSite;
    }

    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: query);
    final http.Response response = await http.get(uri).timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw Exception('Koneksi timeout, coba lagi.'),
        );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat berita (kode: ${response.statusCode})');
    }
  }
}
