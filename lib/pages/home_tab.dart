import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/news_controller.dart';
import '../controllers/favorite_controller.dart';
import '../models/news.dart';
import 'detail_page.dart';

/// Home Screen (soal 2): daftar karakter dari API (foto, nama, status),
/// tombol favorit, filter berdasarkan status, pencarian nama (bonus),
/// loading state & error handling (soal 6b).
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final NewsController _newsController = Get.put(NewsController());
  final FavoriteController _favoriteController = Get.find<FavoriteController>();

  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // --- Pencarian karakter berdasarkan nama (BONUS 1) ---
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              controller: _searchCtrl,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) => _newsController.search(value),
              decoration: InputDecoration(
                hintText: 'Cari berita berdasarkan nama...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchCtrl.clear();
                          _newsController.search('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF6DA739), width: 2),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          // --- Filter status (soal 2b): All / Alive / Dead / Unknown ---
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Obx(
              () => Wrap(
                spacing: 8,
                children: [
                  _buildFilterChip('All', ''),
                  _buildFilterChip('Alive', 'alive'),
                  _buildFilterChip('Dead', 'dead'),
                  _buildFilterChip('Unknown', 'unknown'),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final controller = _newsController;

              // --- Loading state (soal 6b) ---
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF6DA739)),
                );
              }

              // --- Error handling ketika API gagal diakses (soal 6b) ---
              if (controller.errorMessage.value.isNotEmpty) {
                return _buildErrorView(controller);
              }

              if (controller.news.isEmpty) {
                return const Center(
                  child: Text(
                    'Berita tidak ditemukan',
                    style: TextStyle(color: Colors.black54),
                  ),
                );
              }

              // --- Daftar berita (soal 2a) ---
              return RefreshIndicator(
                color: const Color(0xFF6DA739),
                onRefresh: controller.refresh,
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: controller.news.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final news = controller.news[index];
                    return _buildNewsCard(news);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final bool selected = _newsController.statusFilter.value == value;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => _newsController.setStatusFilter(value),
      selectedColor: const Color(0xFF97CE4C),
      checkmarkColor: Colors.black,
      labelStyle: TextStyle(
        color: selected ? Colors.black : Colors.black54,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: Colors.grey.shade200,
    );
  }

  Widget _buildErrorView(NewsController controller) {
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
                backgroundColor: const Color(0xFF97CE4C),
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard(Article article) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          // Ketika berita dipilih, arahkan ke Detail Screen (soal 2c).
          onTap: () => Get.to(() => DetailPage(article: article)),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              article.imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              // Error handling jika gambar gagal dimuat.
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          // Tombol favorit (soal 2a). Icon berubah sesuai status favorit.
          trailing: Obx(
            () => IconButton(
              icon: Icon(
                _favoriteController.isFavorite(article.imageUrl as int)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: _favoriteController.isFavorite(article.imageUrl as int)
                    ? Colors.red
                    : Colors.grey,
              ),
              onPressed: () async {
                final bool added =
                    await _favoriteController.toggleFavorite(article);
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
        ),
      ),
    );
  }
}
