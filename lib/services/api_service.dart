import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news.dart';

/// Service untuk komunikasi dengan Rick and Morty API (Modul V: HTTP Request).
/// Semua request menggunakan method GET.
class ApiService {
  static const String baseUrl = 'https://api.spaceflightnewsapi.net/v4/articles';

  /// Mengambil list berita. Bisa diberi filter status (alive/dead/unknown)
  /// dan pencarian berdasarkan nama (bonus).
  /// Endpoint: /article  |  /article?status=alive  |  /article?name=morty
  static Future<List<Article>> fetchNews({
    String? status,
    String? name,
  }) async {
    // Menyusun query parameter untuk filter & search.
    final Map<String, String> query = {};
    if (status != null && status.toLowerCase() != 'all') {
      query['status'] = status.toLowerCase();
    }
    if (name != null && name.trim().isNotEmpty) {
      query['name'] = name.trim();
    }

    final Uri uri = Uri.parse('$baseUrl/news').replace(queryParameters: query);
    final http.Response response = await http.get(uri).timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw Exception('Koneksi timeout, coba lagi.'),
        );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List results = data['results'];
      // Jika hasil pencarian tidak ada, API tetap 200 dengan results kosong.
      return results.map((json) => Article.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      // 404 dari API berarti berita tidak ditemukan (filter/search tanpa hasil).
      return [];
    } else {
      throw Exception('Gagal memuat berita (kode: ${response.statusCode})');
    }
  }

  /// Mengambil detail satu berita berdasarkan id.
  /// Endpoint: /article/{id}
  static Future<Article> fetchNewsDetail(int id) async {
    final http.Response response = await http
        .get(Uri.parse('$baseUrl/news/$id'))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      return Article.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal memuat detail berita (kode: ${response.statusCode})');
    }
  }
}