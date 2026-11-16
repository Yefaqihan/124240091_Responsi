import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

/// Controller autentikasi menggunakan GetX.
/// Session login disimpan di Shared Preferences agar tetap ada saat aplikasi
/// dibuka kembali pada origin Chrome yang sama.
class AuthController extends GetxController {
  final Rxn<String> currentUser = Rxn<String>();

  /// Dipanggil dan ditunggu oleh main() sebelum aplikasi ditampilkan.
  /// Ini menghindari kondisi halaman utama terbuka sebelum session terbaca.
  Future<void> restoreSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedSession = prefs.getString('session');
    currentUser.value =
        savedSession != null && savedSession.trim().isNotEmpty
            ? savedSession
            : null;
  }

  /// Login ke local database. Return pesan error, atau null jika sukses.
  Future<String?> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      return 'Username dan password tidak boleh kosong';
    }

    final bool ok = await AuthService.login(username, password);
    if (!ok) {
      return 'Username atau password salah';
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('session', username);
    currentUser.value = username;
    return null;
  }

  /// Register user baru ke local database (Shared Preferences).
  Future<String?> register(
      String username, String password, String confirm) async {
    if (username.isEmpty || password.isEmpty || confirm.isEmpty) {
      return 'Semua field harus diisi';
    }
    if (password != confirm) {
      return 'Konfirmasi password tidak sama';
    }
    if (password.length < 6) {
      return 'Password minimal 6 karakter';
    }

    final bool ok = await AuthService.register(username, password);
    if (!ok) {
      return 'Username sudah terdaftar, gunakan yang lain';
    }
    return null;
  }

  /// Logout hanya menghapus session. Data akun dan bookmark tidak dihapus.
  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('session');
    currentUser.value = null;
  }
}
