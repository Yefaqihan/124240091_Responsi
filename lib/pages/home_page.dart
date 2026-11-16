import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/article_controller.dart';
import '../models/article.dart';
import 'detail_page.dart';

/// Halaman Home (soal 2): daftar minimal 10 berita dari API.
/// Setiap item menampilkan gambar, judul, sumber berita (news_site),
/// dan tanggal publikasi. AppBar (username yang login + tombol bookmark)
/// berada di MainShell.
/// Dilengkapi loading indicator saat data dimuat (soal 2)
/// dan filter berdasarkan sumber berita (soal 5).
class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final ArticleController articleController = Get.put(ArticleController());

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // --- Filter sumber berita / news_site (soal 5) ---
          // Ditaruh di bawah AppBar, dapat digulir horizontal.
          SizedBox(
            height: 56,
            child: Obx(
              () => ListView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                children: [
                  _buildFilterChip(articleController, 'All', ''),
                  ...articleController.newsSites.map(
                      (site) => _buildFilterChip(articleController, site, site)),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final controller = articleController;

              // Loading indicator ketika data sedang dimuat (soal 2).
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF2B5BA8)),
                );
              }

              // Error handling ketika API gagal diakses.
              if (controller.errorMessage.value.isNotEmpty) {
                return _buildErrorView(controller);
              }

              if (controller.articles.isEmpty) {
                return const Center(
                  child: Text(
                    'Berita tidak ditemukan',
                    style: TextStyle(color: Colors.black54),
                  ),
                );
              }

              // Daftar berita (soal 2).
              return RefreshIndicator(
                color: const Color(0xFF2B5BA8),
                onRefresh: controller.refresh,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                  itemCount: controller.articles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final article = controller.articles[index];
                    return _buildArticleCard(context, article);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      ArticleController controller, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Obx(() {
        final bool selected = controller.newsSiteFilter.value == value;
        return FilterChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => controller.setNewsSiteFilter(value),
          selectedColor: const Color(0xFF2B5BA8),
          checkmarkColor: Colors.white,
          labelStyle: TextStyle(
            color: selected ? Colors.white : Colors.black54,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
          backgroundColor: Colors.grey.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: selected ? const Color(0xFF2B5BA8) : Colors.grey.shade300,
            ),
          ),
          showCheckmark: value.isEmpty ? false : true,
        );
      }),
    );
  }

  Widget _buildErrorView(ArticleController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: controller.refresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B5BA8),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, Article article) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        // Ketika berita dipilih, arahkan ke halaman Detail (soal 3).
        onTap: () => Get.to(() => DetailPage(article: article)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar berita.
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  article.imageUrl,
                  width: 96,
                  height: 84,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 96,
                    height: 84,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Info berita: judul, sumber, tanggal.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Sumber berita (news_site).
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B5BA8).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        article.newsSite,
                        style: const TextStyle(
                          color: Color(0xFF2B5BA8),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Tanggal publikasi.
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 11, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          article.publishedFormatted,
                          style: const TextStyle(
                              color: Colors.black45, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
