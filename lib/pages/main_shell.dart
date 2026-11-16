import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'home_page.dart';
import 'bookmark_page.dart';

/// Shell utama aplikasi: Bottom Navigation Bar untuk berpindah antara
/// halaman Home (daftar berita) dan halaman Bookmark.
///
/// Sesuai soal 2, tombol bookmark juga tetap tersedia di kanan AppBar —
/// keduanya mengarah ke halaman Bookmark yang sama.
/// Halaman ini hanya diakses setelah user berhasil login.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // Indeks 0-1: Home (daftar berita), Bookmark.
  final List<Widget> _tabs = const [
    HomeBody(),
    BookmarkBody(),
  ];

  final AuthController _auth = Get.find<AuthController>();

  void _goToBookmark() => setState(() => _currentIndex = 1);

  /// Logout: hapus session lalu kembali ke halaman login.
  Future<void> _logout() async {
    final bool? confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _auth.logout();
      Get.offAllNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Title AppBar menampilkan username yang sedang login (soal 2).
        title: Obx(() => Text(
              _currentIndex == 0
                  ? (_auth.currentUser.value ?? 'SpaceNews Explorer')
                  : 'Bookmark',
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
        actions: [
          // Tombol pada kanan AppBar menuju halaman Bookmark (soal 2).
          if (_currentIndex == 0)
            IconButton(
              icon: const Icon(Icons.bookmark_border),
              tooltip: 'Bookmark',
              onPressed: _goToBookmark,
            ),
          // Tombol logout (fitur tambahan).
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2B5BA8),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_outlined),
            activeIcon: Icon(Icons.newspaper),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            activeIcon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
        ],
      ),
    );
  }
}
