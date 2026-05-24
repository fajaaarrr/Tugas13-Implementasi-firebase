import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HalamanFirebaseMaps extends StatefulWidget {
  const HalamanFirebaseMaps({super.key});

  @override
  State<HalamanFirebaseMaps> createState() => _HalamanFirebaseMapsState();
}

class _HalamanFirebaseMapsState extends State<HalamanFirebaseMaps> {
  // Inisialisasi referensi ke path database 'lokasi_user' [cite: 58]
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('lokasi_user');

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();

  List<Map<String, dynamic>> _listLokasi = [];

  @override
  void initState() {
    super.initState();
    _bacaDataRealtime(); // Jalankan fungsi baca data secara real-time saat startup [cite: 66]
  }

  // Fungsi untuk Menulis/Menyimpan Data ke Firebase (Slide 7) [cite: 57, 59]
  void _simpanLokasi() async {
    if (_namaController.text.isEmpty ||
        _latController.text.isEmpty ||
        _lngController.text.isEmpty) {
      return;
    }

    // Struktur JSON data baru yang akan dikirim [cite: 30, 60]
    var dataBaru = {
      'nama_tempat': _namaController.text,
      'latitude': double.tryParse(_latController.text) ?? 0.0,
      'longitude': double.tryParse(_lngController.text) ?? 0.0,
    };

    // Menggunakan push().set() agar menghasilkan node ID unik otomatis (Slide 6 & 7) [cite: 46, 64]
    await _dbRef.push().set(dataBaru);

    _namaController.clear();
    _latController.clear();
    _lngController.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lokasi berhasil dikirim ke Firebase!')),
    );
  }

  // Fungsi untuk Membaca Data Real-time (Slide 4 & 7) [cite: 26, 65]
  void _bacaDataRealtime() {
    _dbRef.onValue.listen((event) {
      final dataMentah =
          event.snapshot.value
              as Map?; // Mengonversi snapshot menjadi Map [cite: 67]
      List<Map<String, dynamic>> listSementara = [];

      if (dataMentah != null) {
        dataMentah.forEach((key, value) {
          // Iterasi setiap data child di Firebase [cite: 69]
          Map<String, dynamic> item = Map<String, dynamic>.from(value as Map);
          item['key'] = key; // Menyimpan ID unik key-nya [cite: 46]
          listSementara.add(item); // Memasukkan ke list local [cite: 70]
        });
      }

      setState(() {
        _listLokasi = listSementara;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas Firebase - Maps Basis'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama Tempat'),
            ),
            TextField(
              controller: _latController,
              decoration: const InputDecoration(labelText: 'Latitude'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _lngController,
              decoration: const InputDecoration(labelText: 'Longitude'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _simpanLokasi,
              child: const Text('Simpan Koordinat ke Cloud'),
            ),
            const Divider(height: 40, thickness: 2),
            const Text(
              'Data Koordinat Real-time:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _listLokasi.isEmpty
                  ? const Center(child: Text('Belum ada data di Firebase.'))
                  : ListView.builder(
                      itemCount: _listLokasi.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                            title: Text(
                              _listLokasi[index]['nama_tempat'] ?? '',
                            ),
                            subtitle: Text(
                              'Lat: ${_listLokasi[index]['latitude']} | Lng: ${_listLokasi[index]['longitude']}',
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
