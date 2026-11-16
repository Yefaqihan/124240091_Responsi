import 'package:get/get.dart';
import '../models/article.dart';
import '../services/bookmark_service.dart';
import 'auth_controller.dart';

/// Controller daftar bookmark menggunakan GetX.
/// Bookmark disimpan terpisah berdasarkan username.
class BookmarkController extends GetxController {
  final RxList<Article> bookmarks = <Article>[].obs;
  final AuthController _auth = Get.find<AuthController>();

  /// Memuat bookmark milik akun aktif. Tidak pernah membaca key kosong.
  Future<void> loadBookmarks() async {
    final String? username = _auth.currentUser.value;
    if (username == null || username.isEmpty) {
      bookmarks.clear();
      return;
    }

    final List<Article> saved =
        await BookmarkService.getBookmarks(username);
    bookmarks.assignAll(saved);
  }

  bool isBookmarked(int id) {
    return bookmarks.any((article) => article.id == id);
  }

  /// Menambah/menghapus bookmark. Return true jika ditambahkan.
  Future<bool> toggleBookmark(Article article) async {
    final String? username = _auth.currentUser.value;
    if (username == null || username.isEmpty) return false;

    final bool wasBookmarked = isBookmarked(article.id);
    if (wasBookmarked) {
      bookmarks.removeWhere((saved) => saved.id == article.id);
    } else {
      bookmarks.add(article);
    }

    await BookmarkService.saveBookmarks(username, bookmarks.toList());
    return !wasBookmarked;
  }

  /// Menghapus satu bookmark dan langsung menyimpan perubahan.
  Future<void> removeBookmark(int id) async {
    final String? username = _auth.currentUser.value;
    if (username == null || username.isEmpty) return;

    bookmarks.removeWhere((article) => article.id == id);
    await BookmarkService.saveBookmarks(username, bookmarks.toList());
  }
}
