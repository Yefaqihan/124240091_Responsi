import 'package:get/get.dart';
import '../models/news.dart';
import '../services/api_service.dart';

/// Controller data karakter dari API menggunakan GetX.
/// Menangani: fetching, loading state, error handling, filter status,
/// dan pencarian berdasarkan nama (bonus).
class NewsController extends GetxController {
  final RxList<Article> news = <Article>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  // Filter status: null/'' = semua, atau 'alive' / 'dead' / 'unknown'
  final RxString statusFilter = ''.obs;

  // Keyword pencarian (bonus)
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  /// Mengambil daftar berita dari API sesuai filter & pencarian aktif.
  Future<void> fetchNews() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final List<Article> result = await ApiService.fetchNews(
        status: statusFilter.value.isEmpty ? null : statusFilter.value,
        name: searchQuery.value.isEmpty ? null : searchQuery.value,
      );
      news.assignAll(result);
    } catch (e) {
      // Error handling ketika API gagal diakses (tanpa internet, server down, dll.)
      errorMessage.value =
          'Gagal memuat data dari API.\nPeriksa koneksi internet Anda lalu coba lagi.';
      news.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Mengubah filter status lalu memuat ulang data dari API.
  Future<void> setStatusFilter(String status) async {
    statusFilter.value = status;
    await fetchNews();
  }

  /// Pencarian berita berdasarkan judul (bonus). Didebounce sederhana
  /// agar tidak request terus-menerus saat user sedang mengetik.
  Future<void> search(String query) async {
    searchQuery.value = query;
    await fetchNews();
  }

  /// Menyegarkan ulang data (dipakai pada error state).
  Future<void> refresh() => fetchNews();
}
