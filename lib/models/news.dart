/// Model data berita.
/// Menerapkan konsep OOP: class sebagai blueprint object dengan
/// constructor, property, dan factory constructor untuk parsing JSON.
class Article {
  final int id;
  final String imageUrl;
  final String title;
  final String newsSite;
  final String publisedAt;


  Article({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.newsSite,
    required this.publisedAt,
  });

  /// Factory constructor: mengubah JSON dari API menjadi object News.
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      title: json['title'] ?? '',
      newsSite: json['newsSite'] ?? '',
      publisedAt: json['publisedAt'] ?? '',
    );
  }

  /// Untuk menyimpan ke Shared Preferences (favorit) dalam bentuk Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'title': title,
      'newsSite': newsSite,
      'publisedAt': publisedAt,
    };
  }

  /// Membuat kembali object News dari Map yang disimpan di Shared Preferences.
  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      title: map['title'] ?? '',
      newsSite: map['newsSite'] ?? '',
      publisedAt: map['publisedAt'] ?? '',
    );
  }
}