import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import '../models/news.dart';

/// Detail Screen (soal 3): foto, nama, status, spesies, gender, origin,
/// location + tombol favorite dengan Snackbar dan icon yang berubah.
class DetailPage extends StatefulWidget {
  final Article article;

  const DetailPage({super.key, required this.article});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final FavoriteController _favoriteController = Get.find<FavoriteController>();

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(article.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          // Icon favorite berubah sesuai status favorit karakter (soal 3d).
          Obx(
            () => IconButton(
              icon: Icon(
                _favoriteController.isFavorite(article.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: _favoriteController.isFavorite(article.id)
                    ? Colors.red
                    : Colors.black45,
              ),
              onPressed: () async {
                final bool added =
                    await _favoriteController.toggleFavorite(article);
                // Snackbar ketika karakter ditambahkan/dihapus dari favorit (soal 3c).
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(added
                        ? '${article.title} ditambahkan ke favorit'
                        : '${article.title} dihapus dari favorit'),
                    backgroundColor: added ? Colors.green : Colors.redAccent,
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Foto karakter (soal 3a).
            Center(
              child: Hero(
                tag: 'news-${article.imageUrl}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    article.imageUrl,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 220,
                      width: 220,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.person, size: 80),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                article.title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Info detail karakter: status, spesies, gender, origin, location.
            _buildInfoCard('Title', article.title, Icons.favorite_outline),
            _buildInfoCard('News Site', article.newsSite, Icons.pets),
            _buildInfoCard('Published At', article.publisedAt, Icons.transgender),
            const SizedBox(height: 16),
            // Tombol favorite (soal 3b).
            Obx(
              () => ElevatedButton.icon(
                onPressed: () async {
                  final bool added =
                      await _favoriteController.toggleFavorite(article);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(added
                          ? '${article.title} ditambahkan ke favorit'
                          : '${article.title} dihapus dari favorit'),
                      backgroundColor:
                          added ? Colors.green : Colors.redAccent,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: Icon(
                  _favoriteController.isFavorite(article.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
                label: Text(
                  _favoriteController.isFavorite(article.id)
                      ? 'Hapus dari Favorit'
                      : 'Tambahkan ke Favorit',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _favoriteController.isFavorite(article.id)
                      ? Colors.redAccent
                      : const Color(0xFF97CE4C),
                  foregroundColor: Colors.white,
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

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6DA739), size: 22),
            const SizedBox(width: 12),
            SizedBox(
              width: 90,
              child: Text(
                label,
                style: const TextStyle(color: Colors.black45, fontSize: 14),
              ),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
