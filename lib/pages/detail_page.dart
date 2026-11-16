import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/bookmark_controller.dart';
import '../models/article.dart';

/// Halaman Detail Berita (soal 3): gambar, judul, sumber berita,
/// tanggal publikasi, penulis, ringkasan + tombol Read Full Article
/// (membuka artikel asli di browser) + tombol bookmark dengan
/// perubahan warna icon dan snackbar hijau/merah.
class DetailPage extends StatelessWidget {
  final Article article;

  const DetailPage({super.key, required this.article});

  /// Membuka artikel asli melalui browser (soal 3).
  Future<void> _openFullArticle() async {
    final Uri url = Uri.parse(article.url);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Gagal membuka',
        'Tautan artikel tidak dapat dibuka.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // BookmarkController di-find di sini agar sinkron dengan Home & Bookmark.
    final BookmarkController bookmarkController =
        Get.find<BookmarkController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Berita',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gambar berita (soal 3).
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                article.imageUrl,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image, size: 64),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Judul berita.
            Text(
              article.title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Sumber berita + tanggal publikasi (soal 3).
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B5BA8).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    article.newsSite,
                    style: const TextStyle(
                      color: Color(0xFF2B5BA8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.calendar_today, size: 13, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  article.publishedFormatted,
                  style: const TextStyle(color: Colors.black45, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Penulis (soal 3).
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    article.authors,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Ringkasan berita (soal 3).
            const Text(
              'Ringkasan',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              article.summary,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            // Tombol Read Full Article -> buka artikel asli di browser (soal 3).
            ElevatedButton.icon(
              onPressed: _openFullArticle,
              icon: const Icon(Icons.open_in_new),
              label: const Text(
                'Read Full Article',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B5BA8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Tombol bookmark (soal 3). Icon berubah warna sesuai status,
            // dengan snackbar hijau saat ditambahkan dan merah saat dihapus.
            Obx(
              () => ElevatedButton.icon(
                onPressed: () async {
                  final bool added =
                      await bookmarkController.toggleBookmark(article);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(added
                          ? 'Berita ditambahkan ke bookmark'
                          : 'Berita dihapus dari bookmark'),
                      // Snackbar hijau saat tambah, merah saat hapus (soal 3).
                      backgroundColor: added ? Colors.green : Colors.red,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: Icon(
                  bookmarkController.isBookmarked(article.id)
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                ),
                label: Text(
                  bookmarkController.isBookmarked(article.id)
                      ? 'Hapus dari Bookmark'
                      : 'Tambahkan ke Bookmark',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: bookmarkController.isBookmarked(article.id)
                      ? Colors.grey.shade300
                      : const Color(0xFF2B5BA8),
                  foregroundColor: bookmarkController.isBookmarked(article.id)
                      ? Colors.black87
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
