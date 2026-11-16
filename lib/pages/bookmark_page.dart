import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bookmark_controller.dart';
import 'detail_page.dart';

/// Halaman Bookmark (soal 4): menampilkan seluruh berita yang telah
/// ditambahkan ke bookmark. Data disimpan di local database (Shared
/// Preferences) agar tetap tersedia ketika aplikasi ditutup.
/// Bookmark dihapus dengan swipe (Dismissible) dan langsung hilang
/// dari daftar. Sebagai tab di MainShell (tanpa Scaffold sendiri).
class BookmarkBody extends StatelessWidget {
  const BookmarkBody({super.key});

  @override
  Widget build(BuildContext context) {
    final BookmarkController controller = Get.find<BookmarkController>();

    return Container(
      color: Colors.white,
      child: Obx(() {
        // Pesan apabila belum ada berita yang di-bookmark.
        if (controller.bookmarks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border,
                    size: 72, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                const Text(
                  'Belum ada berita yang di-bookmark',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tambahkan bookmark dari halaman detail berita',
                  style: TextStyle(color: Colors.black38, fontSize: 13),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: controller.bookmarks.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final article = controller.bookmarks[index];

            // Swipe (horizontal) untuk menghapus bookmark (soal 4).
            return Dismissible(
              key: ValueKey(article.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.delete, color: Colors.white, size: 28),
              ),
              onDismissed: (_) async {
                await controller.removeBookmark(article.id);
                // Konfirmasi bahwa berita hilang dari daftar bookmark.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Bookmark "${article.title}" dihapus'),
                    backgroundColor: Colors.red,
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
                  // Ketuk bookmark -> halaman detail berita tersebut.
                  onTap: () => Get.to(() => DetailPage(article: article)),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      article.imageUrl,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 64,
                        height: 64,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image),
                      ),
                    ),
                  ),
                  title: Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        '${article.newsSite} • ${article.publishedFormatted}',
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.bookmark,
                      color: Color(0xFF2B5BA8)),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
