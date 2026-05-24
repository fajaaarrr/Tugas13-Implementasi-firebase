# Tugas 13: Implementasi Firebase Realtime Database - Maps Basis

Proyek Flutter ini dibuat untuk mendemonstrasikan integrasi aplikasi Flutter dengan **Firebase Realtime Database** untuk menyimpan, membaca, dan menampilkan data koordinat lokasi secara *real-time*.


*   **Nama:** Muhammad fajar Shodiq
*   **NIM:** 1202230045
*   **Mata Kuliah:** Aplikasi Perangkat Bergerak



 Fitur Aplikasi

1.  **Inisialisasi Firebase Otomatis:** Menggunakan `DefaultFirebaseOptions` hasil konfigurasi platform untuk inisialisasi yang aman pada Web, Android, maupun iOS.
2.  **Menyimpan Koordinat ke Cloud:** Mengirimkan data nama tempat, latitude, dan longitude secara terstruktur ke Firebase Realtime Database dengan ID unik otomatis menggunakan metode `.push().set()`.
3.  **Sinkronisasi Real-Time (Live Update):** Mendengarkan perubahan data di cloud secara instan menggunakan `.onValue.listen()` dan memperbarui daftar koordinat di layar tanpa perlu memuat ulang halaman.
4.  **UI Modern & Responsif:** Antarmuka bersih yang menggunakan Material Design, lengkap dengan visualisasi kartu (*Card*) data lokasi.

---

 Penjelasan Struktur Kode & Logika

### 1. Inisialisasi Firebase (`lib/main.dart`)
Sebelum aplikasi diluncurkan (`runApp`), Flutter memastikan seluruh *binding* telah siap dan menginisialisasi Firebase menggunakan konfigurasi platform yang sesuai.
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
```

### 2. Menyimpan Data ke Database (`lib/halaman_firebase_maps.dart`)
Metode `_simpanLokasi()` membaca input dari pengguna, menyusunnya ke dalam format JSON/Map, lalu mengirimkannya ke Firebase.
```dart
void _simpanLokasi() async {
  if (_namaController.text.isEmpty || _latController.text.isEmpty || _lngController.text.isEmpty) {
    return;
  }

  // Menyusun struktur data baru
  var dataBaru = {
    'nama_tempat': _namaController.text,
    'latitude': double.tryParse(_latController.text) ?? 0.0,
    'longitude': double.tryParse(_lngController.text) ?? 0.0,
  };

  // push() membuat ID unik otomatis (misalnya -Ot0B369ztcAT...) agar data tidak menimpa data sebelumnya
  await _dbRef.push().set(dataBaru);

  // Membersihkan form input
  _namaController.clear();
  _latController.clear();
  _lngController.clear();
}
```

### 3. Membaca Data Secara Real-Time (`lib/halaman_firebase_maps.dart`)
Metode `_bacaDataRealtime()` mendengarkan aliran data (*stream*) dari path `lokasi_user` secara terus-menerus. Setiap ada penambahan atau perubahan data di Firebase Cloud, UI akan otomatis diperbarui secara instan.
```dart
void _bacaDataRealtime() {
  _dbRef.onValue.listen((event) {
    final dataMentah = event.snapshot.value as Map?;
    List<Map<String, dynamic>> listSementara = [];

    if (dataMentah != null) {
      dataMentah.forEach((key, value) {
        Map<String, dynamic> item = Map<String, dynamic>.from(value as Map);
        item['key'] = key; // Menyimpan ID kunci unik dari cloud
        listSementara.add(item);
      });
    }

    setState(() {
      _listLokasi = listSementara;
    });
  });
}
```

---

 Hasil Screenshot & Bukti Implementasi

Tampilan Antarmuka Aplikasi (Flutter UI)
Menampilkan form input koordinat serta daftar koordinat lokasi yang berhasil ditarik secara langsung dari Firebase Realtime Database.

<img width="608" height="985" alt="Screenshot 2026-05-24 155330" src="https://github.com/user-attachments/assets/40a83e39-c1aa-44d1-9d9f-ed71fa96c5c1" />


*Gambar di atas menunjukkan aplikasi berhasil dijalankan dan menampilkan koordinat "hotel" (Lat: 75.6 | Lng: 12.3).*

---

Tampilan Data di Firebase Realtime Database Console
Bukti data tersimpan secara terstruktur di dalam Cloud Firebase pada node `lokasi_user` lengkap dengan kunci ID unik otomatis (`-Ot0B369...`).

<img width="1919" height="1025" alt="Screenshot 2026-05-24 155452" src="https://github.com/user-attachments/assets/781d9eea-210b-40c6-8511-a070065eb0f0" />


*Gambar di atas membuktikan data tersinkronisasi sempurna di server cloud Firebase dengan struktur yang tepat.*

---

 Panduan Menjalankan Proyek Secara Lokal

1. Clone repositori ini ke komputer Anda:
   ```bash
   git clone https://github.com/fajaaarrr/Tugas13-Implementasi-firebase.git
   ```
2. Jalankan perintah `flutter pub get` untuk mengunduh seluruh dependensi paket Firebase yang dibutuhkan.
3. Hubungkan perangkat emulator Android/iOS Anda atau pilih browser.
4. Jalankan aplikasi:
   ```bash
   flutter run
   ```
