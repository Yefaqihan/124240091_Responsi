/// Model berita dari Spaceflight News API (Modul III/V).
/// Contoh JSON satu artikel:
/// {
///   "id": 40854,
///   "title": "APOD: 2026 November 16 ...",
///   "authors": [{"name": "NASA", "socials": null}],
///   "url": "https://science.nasa.gov/...",
///   "image_url": "https://assets...",
///   "news_site": "NASA",
///   "summary": "...",
///   "published_at": "2026-11-16T05:05:00Z"
/// }
class Article {
  final int id;
  final String title;
  final String authors;     // gabungan nama penulis
  final String url;         // link artikel asli (dibuka lewat browser)
  final String imageUrl;
  final String newsSite;    // sumber berita
  final String summary;     // ringkasan berita
  final String publishedAt; // tanggal publikasi

  Article({
    required this.id,
    required this.title,
    required this.authors,
    required this.url,
    required this.imageUrl,
    required this.newsSite,
    required this.summary,
    required this.publishedAt,
  });

  /// Konversi JSON dari API menjadi object Article.
  factory Article.fromJson(Map<String, dynamic> json) {
    final List authors = json['authors'] ?? [];
    return Article(
      id: json['id'],
      title: json['title'] ?? '',
      authors: authors.isEmpty
          ? 'Unknown'
          : authors.map((a) => a['name'] ?? '').join(', '),
      url: json['url'] ?? '',
      imageUrl: json['image_url'] ?? '',
      newsSite: json['news_site'] ?? '',
      summary: json['summary'] ?? '',
      publishedAt: json['published_at'] ?? '',
    );
  }

  /// Konversi object Article menjadi Map (untuk menyimpan bookmark
  /// ke local database dalam bentuk JSON string).
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'authors': authors,
        'url': url,
        'image_url': imageUrl,
        'news_site': newsSite,
        'summary': summary,
        'published_at': publishedAt,
      };

  /// Membaca kembali Article dari Map yang tersimpan di local database.
  factory Article.fromJsonMap(Map<String, dynamic> map) => Article(
        id: map['id'],
        title: map['title'] ?? '',
        authors: map['authors'] ?? '',
        url: map['url'] ?? '',
        imageUrl: map['image_url'] ?? '',
        newsSite: map['news_site'] ?? '',
        summary: map['summary'] ?? '',
        publishedAt: map['published_at'] ?? '',
      );

  /// Format tanggal publikasi agar mudah dibaca: 16 Nov 2026.
  String get publishedFormatted {
    try {
      final DateTime date = DateTime.parse(publishedAt).toLocal();
      const List<String> months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return publishedAt;
    }
  }
}
