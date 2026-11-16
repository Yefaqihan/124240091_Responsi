# Catatan Implementasi (untuk persiapan responsi)

## Pemetaan Soal → Kode

**1. Login & Register (Shared Preferences + local database)**
- Local database = **Shared Preferences** (`lib/services/auth_service.dart`), key `users` (JSON map: username -> {username,password}). Persisten di Chrome/web karena tersimpan di localStorage browser; penting menjalankan dengan port tetap (lihat bawah).
- Shared Preferences = **session login** (`lib/controllers/auth_controller.dart`), key `session`.
- Logout: hapus session → `Get.offAllNamed('/login')` (hanya di `main_shell.dart`, dengan dialog konfirmasi).

**2. Home Screen**
- Fetch `/character` via `ApiService.fetchCharacters` → `CharacterController`.
- Foto (`Image.network`), nama, status (dengan titik warna hijau/merah/abu).
- Tombol favorit di setiap kartu (icon heart, warna merah jika favorit).
- Filter: FilterChip All/Alive/Dead/Unknown → `/character?status=...` (`setStatusFilter`).
- `onTap` kartu → `Get.to(() => DetailPage(character: ...))`.

**3. Detail Screen**
- Data dilewatkan via constructor (Modul IV passing data), foto pakai Hero animation.
- Info: status, species, gender, origin, location.
- Tombol favorite di AppBar + tombol besar di bawah; keduanya memanggil `toggleFavorite`.
- Snackbar muncul saat tambah/hapus; icon berubah karena `Obx` membaca state FavoriteController.

**4. Favorite Screen**
- Penyimpanan: Shared Preferences key `favorites_<username>` (JSON list dari `Character.toMap()`).
- Swipe to delete: `Dismissible` dengan `DismissDirection.endToStart`.
- Snackbar setelah dihapus; pesan kosong jika list kosong.

**5. Episode Screen**
- Fetch `/episode`, tampilkan `name` + `air_date` (+ badge nomor episode).

**6. Ketentuan tambahan**
- a) `MainShell` dengan `BottomNavigationBar` (Characters/Favorites/Episodes).
- b) Loading = `CircularProgressIndicator`; error = pesan + tombol "Coba Lagi"; timeout 15 detik.
- c) Sinkronisasi: HANYA ADA SATU `FavoriteController` (GetX) yang di-`Get.put` di `main.dart`. Home, Detail, dan Favorites semuanya membaca state yang sama lewat `Obx`, jadi perubahan langsung tampil di semua tab.
- d) `main()` membaca session dari Shared Preferences sebelum `runApp`; `initialRoute` = `/main` hanya jika session ada. `Get.offAllNamed` dipakai saat login/logout agar stack route bersih (tidak bisa "back" ke login).

**BONUS**
- 1) Pencarian nama: TextField di Home → `/character?name=...`; hasil kosong (API 404) ditangani → pesan "Karakter tidak ditemukan".
- 2) UI: tema terang berbasis putih dengan aksen hijau Rick & Morty (#97CE4C), kartu rounded dengan border tipis, status berwarna.


## Catatan run di Chrome
- `flutter run -d chrome --web-port=8080` → gunakan port tetap agar localStorage (data akun & favorit) tidak hilang saat run ulang, karena storage browser terikat pada origin (host:port).

## Poin yang sering ditanya saat responsi
- Kenapa GetX? → Modul VIII: setState tidak bisa sinkron antar halaman (Home vs Favorite); GetX memberi state terpusat + route + dependency injection.
- Kenapa semua data pakai Shared Preferences (bukan Hive)? → Modul VI mempelajari keduanya; Shared Preferences lebih andal di web/Chrome (localStorage vs IndexedDB), dan tetap termasuk "local storage / local database" sesuai soal.
- Kenapa 404 ditangani khusus? → API rickandmortyapi mengembalikan 404 saat filter/search tidak menemukan hasil, bukan error.
- `withOpacity` vs `withValues`: `withOpacity` dipakai agar kompatibel dengan versi Flutter lebih lama di lab.
