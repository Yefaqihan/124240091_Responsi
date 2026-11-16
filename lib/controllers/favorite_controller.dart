import 'package:get/get.dart';
import '../models/news.dart';
import '../services/favorite_service.dart';
import 'auth_controller.dart';

/// Controller daftar favorit menggunakan GetX.
/// Karena data favorit disimpan di satu controller terpusat (state management),
/// perubahan favorit otomatis langsung diperbarui di Home Screen,
/// Favorite Screen, dan Detail Screen (ketentuan tambahan 6c).
/// Penyimpanan permanen menggunakan Shared Preferences (soal 4a).
class FavoriteController extends GetxController {
  final RxList<Article> favorites = <Article>[].obs;
  final RxBool isLoading = true.obs;

  final AuthController _auth = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  /// Memuat daftar favorit user yang sedang login dari Shared Preferences.
  Future<void> loadFavorites() async {
    isLoading.value = true;
    final String username = _auth.currentUser.value ?? '';
    favorites.assignAll(await FavoriteService.getFavorites(username));
    isLoading.value = false;
  }

  /// Cek apakah sebuah berita sudah difavoritkan.
  bool isFavorite(int id) {
    return favorites.any((c) => c.id == id);
  }

  /// Menambah/menghapus berita dari favorit.
  /// Return true jika berita baru saja DITAMBAHKAN, false jika DIHAPUS.
  Future<bool> toggleFavorite(Article article) async {
    final bool wasFavorite = isFavorite(article.id);
    if (wasFavorite) {
      favorites.removeWhere((c) => c.id == article.id);
    } else {
      favorites.add(article);
    }
    await _save();
    return !wasFavorite;
  }

  /// Menghapus favorit (dipakai untuk swipe-to-delete di Favorite Screen).
  Future<void> removeFavorite(int id) async {
    favorites.removeWhere((c) => c.id == id);
    await _save();
  }

  /// Simpan daftar favorit terbaru ke Shared Preferences.
  Future<void> _save() async {
    final String username = _auth.currentUser.value ?? '';
    await FavoriteService.saveFavorites(username, favorites.toList());
  }
}
