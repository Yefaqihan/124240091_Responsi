import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

/// Controller untuk autentikasi menggunakan GetX (Modul VIII).
/// Session login disimpan di Shared Preferences agar user tetap
/// login meskipun aplikasi ditutup (dengan tetap menyediakan logout).
class AuthController extends GetxController {
  // Reactive state: username user yang sedang login (null = belum login).
  final Rxn<String> currentUser = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    _loadSession();
  }

  /// Memuat session dari Shared Preferences saat aplikasi dibuka.
  Future<void> _loadSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUser.value = prefs.getString('session');
  }

  /// Login ke local database (Shared Preferences). Return pesan error, atau null jika sukses.
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
  /// Return pesan error, atau null jika sukses.
  Future<String?> register(String username, String password, String confirm) async {
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

  /// Logout: hapus session dari Shared Preferences dan kembali ke halaman login.
  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('session');
    currentUser.value = null;
  }
}
