import 'package:get/get.dart';
import '../models/article.dart';
import '../services/api_service.dart';

/// Controller daftar berita dari API menggunakan GetX.
/// Menangani: fetching, loading state, error handling, dan
/// filter berita berdasarkan sumber publikasi / news_site.
class ArticleController extends GetxController {
  final RxList<Article> articles = <Article>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  // Filter sumber berita yang sedang aktif ('' = tampilkan semua).
  final RxString newsSiteFilter = ''.obs;

  // Daftar sumber berita yang tersedia (diambil dari berita yang dimuat),
  // ditampilkan sebagai pilihan filter (soal 5).
  final RxList<String> newsSites = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  /// Mengambil daftar berita dari API (soal 2: minimal 10 berita).
  Future<void> fetchArticles() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final List<Article> result = await ApiService.fetchArticles(
        newsSite: newsSiteFilter.value.isEmpty ? null : newsSiteFilter.value,
      );
      articles.assignAll(result);
      // Kumpulkan daftar sumber berita unik untuk pilihan filter,
      // hanya diisi saat tidak sedang memfilter.
      if (newsSiteFilter.value.isEmpty) {
        newsSites.value = result.map((a) => a.newsSite).toSet().toList();
      }
    } catch (e) {
      // Error handling ketika API gagal diakses (soal 2: loading indicator
      // ditampilkan saat memuat; jika gagal tampilkan pesan error).
      errorMessage.value =
          'Gagal memuat berita dari API.\nPeriksa koneksi internet Anda lalu coba lagi.';
      articles.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Mengubah filter sumber berita lalu memuat ulang data dari API (soal 5).
  /// Pengguna memilih sumber tertentu, sehingga hanya berita dari sumber
  /// tersebut yang ditampilkan.
  Future<void> setNewsSiteFilter(String site) async {
    newsSiteFilter.value = site;
    await fetchArticles();
  }

  /// Menyegarkan ulang data (dipakai pada error state).
  Future<void> refresh() => fetchArticles();
}
