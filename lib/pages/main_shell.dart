import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'home_tab.dart';
import 'favorites_tab.dart';

/// Halaman utama dengan Bottom Navigation Bar (soal 6a)
/// untuk berpindah antara Home Screen, Favorite Screen, dan Episode Screen.
/// Halaman ini hanya diakses setelah user berhasil login (soal 6d).
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // Indeks 0-2: Home (Characters), Favorites, Episodes.
  final List<Widget> _tabs = const [
    HomeTab(),
    FavoritesTab(),
  ];

  final AuthController _auth = Get.find<AuthController>();

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
        title: Text(
          _currentIndex == 0
              ? 'Rick & Morty'
              : _currentIndex == 1
                  ? 'Favorites'
                  : 'Episodes',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Tombol logout untuk kembali ke halaman login (soal 1).
          Obx(() => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Center(
                  child: Text(
                    _auth.currentUser.value ?? '',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
              )),
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
        selectedItemColor: const Color(0xFF6DA739),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            activeIcon: Icon(Icons.people_alt),
            label: 'Characters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
