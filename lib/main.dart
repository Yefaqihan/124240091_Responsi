import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'controllers/bookmark_controller.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/main_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pulihkan session terlebih dahulu agar BookmarkController tidak sempat
  // membaca bookmark dengan username kosong.
  final AuthController authController = Get.put(AuthController());
  await authController.restoreSession();

  // Controller bookmark baru dibuat setelah session berhasil dipulihkan.
  final BookmarkController bookmarkController = Get.put(BookmarkController());
  final bool loggedIn = authController.currentUser.value != null;

  // Pastikan bookmark akun aktif selesai dimuat sebelum halaman utama tampil.
  if (loggedIn) {
    await bookmarkController.loadBookmarks();
  }

  runApp(MyApp(loggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;

  const MyApp({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SpaceNews Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2B5BA8),
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 2,
        ),
      ),
      // Session yang tersimpan menentukan halaman pertama saat aplikasi dibuka.
      initialRoute: loggedIn ? '/main' : '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/register', page: () => const RegisterPage()),
        GetPage(name: '/main', page: () => const MainShell()),
      ],
    );
  }
}
