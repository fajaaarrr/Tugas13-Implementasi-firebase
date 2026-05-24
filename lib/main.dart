import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled/halaman_firebase_maps.dart';
import 'firebase_options.dart'; // File otomatis dari hasil 'flutterfire configure'

void main() async {
  // Wajib ditambahkan agar proses async inisialisasi berjalan lancar
  WidgetsFlutterBinding.ensureInitialized();

  // Menginisialisasi Firebase sebelum app berjalan
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HalamanFirebaseMaps(), // Mengarahkan ke halaman tugas Firebase kita
    );
  }
}
