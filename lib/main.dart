import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/auth_controller.dart';
import 'controllers/favorite_controller.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/main_shell.dart';

void main() async {
  // Memastikan binding Flutter siap sebelum menggunakan plugin
  // (Shared Preferences butuh ini).
  WidgetsFlutterBinding.ensureInitialized();

  // Baca session login dari Shared Preferences.
  // Halaman utama hanya bisa diakses setelah user berhasil login (soal 6d):
  // jika ada session, langsung ke MainShell, jika tidak ke halaman Login.
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? session = prefs.getString('session');

  // Registrasi controller GetX (Modul VIII - dependency management).
  Get.put(AuthController());
  Get.put(FavoriteController());

  runApp(MyApp(loggedIn: session != null && session.isNotEmpty));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;

  const MyApp({super.key, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rick & Morty Character Explorer',
      debugShowCheckedModeBanner: false,
      // Tema dasar putih dengan aksen hijau Rick & Morty.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF97CE4C),
          brightness: Brightness.light,
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
      // Route management dengan GetX (Modul VIII).
      initialRoute: loggedIn ? '/main' : '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/register', page: () => const RegisterPage()),
        GetPage(name: '/main', page: () => const MainShell()),
      ],
    );
  }
}
