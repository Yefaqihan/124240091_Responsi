import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:space_news_explorer/models/news.dart';
import '../controllers/favorite_controller.dart';
import 'detail_page.dart';

/// Favorite Screen (soal 4): daftar karakter yang difavoritkan.
/// - Data disimpan di Shared Preferences (persist, soal 4a)
/// - Hapus favorit dengan swipe (Dismissible, soal 4b)
/// - Snackbar setelah berhasil dihapus (soal 4c)
/// - Pesan jika daftar kosong (soal 4d)
class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteController controller = Get.find<FavoriteController>();

    return Container(
      color: Colors.white,
      child: Obx(() {
        // Pesan apabila daftar favorite masih kosong (soal 4d).
        if (controller.favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 72, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                const Text(
                  'Belum ada karakter favorit',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tambahkan favorit dari tab Article',
                  style: TextStyle(color: Colors.black38, fontSize: 13),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: controller.favorites.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final article = controller.favorites[index];

            // Swipe (horizontal) untuk menghapus favorit (soal 4b).
            return Dismissible(
              key: ValueKey(article.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.delete, color: Colors.white, size: 28),
              ),
              onDismissed: (_) async {
                await controller.removeFavorite(article.id);
                // Snackbar setelah karakter berhasil dihapus (soal 4c).
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('${article.title} dihapus dari favorit'),
                    backgroundColor: Colors.redAccent,
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  onTap: () => Get.to(
                    () => DetailPage(article: article),
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      article.imageUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 56,
                        height: 56,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.person),
                      ),
                    ),
                  ),
                  title: Text(
                    article.title,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '${article.newsSite} • ${article.publisedAt}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  trailing: const Icon(Icons.favorite, color: Colors.red),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
