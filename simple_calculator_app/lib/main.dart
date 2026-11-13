import 'package:flutter/material.dart';

// ============================================================
// 1. PROGRAM DIMULAI DARI SINI
// ============================================================

// Fungsi main() adalah titik awal ketika aplikasi dijalankan.
void main() {
  // runApp() menjalankan aplikasi Flutter.
  runApp(const CalculatorApp());
}

// ============================================================
// 2. MEMBUAT APLIKASI UTAMA
// ============================================================

// CalculatorApp adalah widget utama aplikasi.
class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp digunakan sebagai pembungkus utama aplikasi.
    return MaterialApp(
      // Menghilangkan tulisan DEBUG di pojok kanan atas.
      debugShowCheckedModeBanner: false,

      // Judul aplikasi.
      title: 'Simple Calculator',

      // Mengatur tema tampilan aplikasi.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),

      // Menentukan halaman pertama yang ditampilkan.
      // Jadi setelah CalculatorApp dibuka,
      // pengguna akan masuk ke CalculatorScreen.
      home: const CalculatorScreen(),
    );
  }
}

// ============================================================
// 3. MEMBUAT HALAMAN KALKULATOR
// ============================================================

// CalculatorScreen adalah halaman kalkulator.
// StatefulWidget digunakan karena hasil dapat berubah
// ketika tombol operasi ditekan.
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

// ============================================================
// 4. TEMPAT MENYIMPAN DATA DAN LOGIKA KALKULATOR
// ============================================================

// _CalculatorScreenState berisi:
// - controller input
// - variabel hasil
// - fungsi perhitungan
// - tampilan kalkulator
class _CalculatorScreenState extends State<CalculatorScreen> {

  // ----------------------------------------------------------
  // 4.1 CONTROLLER ANGKA PERTAMA
  // ----------------------------------------------------------

  // Controller digunakan untuk mengambil teks
  // yang diketik pengguna pada TextField pertama.
  final TextEditingController angkaPertamaController =
      TextEditingController();

  // ----------------------------------------------------------
  // 4.2 CONTROLLER ANGKA KEDUA
  // ----------------------------------------------------------

  // Controller ini digunakan untuk mengambil teks
  // dari TextField kedua.
  final TextEditingController angkaKeduaController =
      TextEditingController();

  // ----------------------------------------------------------
  // 4.3 VARIABEL UNTUK MENYIMPAN HASIL
  // ----------------------------------------------------------

  // Variabel hasil digunakan untuk menyimpan
  // hasil perhitungan atau pesan kesalahan.
  String hasil = 'Hasil akan muncul di sini';

  // ==========================================================
  // 5. FUNGSI UNTUK MELAKUKAN PERHITUNGAN
  // ==========================================================

  // Fungsi hitung() dijalankan ketika salah satu
  // tombol operasi (+, -, ×, ÷) ditekan.
  //
  // Parameter "operasi" digunakan untuk mengetahui
  // tombol operasi mana yang ditekan.
  void hitung(String operasi) {

    // --------------------------------------------------------
    // 5.1 MENGAMBIL INPUT DARI TEXTFIELD
    // --------------------------------------------------------

    // Mengambil teks dari TextField angka pertama.
    // trim() digunakan untuk menghilangkan spasi
    // yang tidak diperlukan.
    String inputPertama =
        angkaPertamaController.text.trim();

    // Mengambil teks dari TextField angka kedua.
    String inputKedua =
        angkaKeduaController.text.trim();

    // --------------------------------------------------------
    // 5.2 MEMERIKSA APAKAH INPUT KOSONG
    // --------------------------------------------------------

    // Jika salah satu atau kedua TextField kosong,
    // maka program tidak melanjutkan perhitungan.
    if (inputPertama.isEmpty || inputKedua.isEmpty) {

      // setState() digunakan untuk mengubah tampilan
      // setelah nilai "hasil" berubah.
      setState(() {
        hasil = 'Masukkan kedua angka!';
      });

      // return digunakan untuk menghentikan fungsi.
      return;
    }

    // --------------------------------------------------------
    // 5.3 MENGUBAH TEKS MENJADI ANGKA
    // --------------------------------------------------------

    // TextField menghasilkan data berupa String.
    // Karena kita ingin melakukan matematika,
    // String harus diubah menjadi double.
    //
    // double.tryParse() aman digunakan karena
    // jika input bukan angka, hasilnya akan menjadi null.
    double? angkaPertama =
        double.tryParse(inputPertama);

    double? angkaKedua =
        double.tryParse(inputKedua);

    // --------------------------------------------------------
    // 5.4 MEMERIKSA APAKAH INPUT BENAR-BENAR ANGKA
    // --------------------------------------------------------

    // Jika salah satu hasil tryParse adalah null,
    // berarti input yang dimasukkan bukan angka.
    if (angkaPertama == null || angkaKedua == null) {

      // Menampilkan pesan kesalahan.
      setState(() {
        hasil = 'Input harus berupa angka!';
      });

      // Menghentikan fungsi agar tidak melakukan perhitungan.
      return;
    }

    // --------------------------------------------------------
    // 5.5 MENYIAPKAN VARIABEL HASIL PERHITUNGAN
    // --------------------------------------------------------

    // Variabel ini nantinya akan berisi
    // hasil dari operasi matematika.
    double hasilPerhitungan;

    // ========================================================
    // 6. MENENTUKAN OPERASI YANG DIPILIH
    // ========================================================

    // switch digunakan untuk menentukan
    // operasi berdasarkan tombol yang ditekan.
    switch (operasi) {

      // ------------------------------------------------------
      // 6.1 PENJUMLAHAN
      // ------------------------------------------------------

      case '+':
        hasilPerhitungan =
            angkaPertama + angkaKedua;
        break;

      // ------------------------------------------------------
      // 6.2 PENGURANGAN
      // ------------------------------------------------------

      case '-':
        hasilPerhitungan =
            angkaPertama - angkaKedua;
        break;

      // ------------------------------------------------------
      // 6.3 PERKALIAN
      // ------------------------------------------------------

      case '×':
        hasilPerhitungan =
            angkaPertama * angkaKedua;
        break;

      // ------------------------------------------------------
      // 6.4 PEMBAGIAN
      // ------------------------------------------------------

      case '÷':

        // Sebelum membagi, kita periksa apakah
        // angka kedua adalah 0.
        if (angkaKedua == 0) {

          // Jika angka kedua 0,
          // tampilkan pesan kesalahan.
          setState(() {
            hasil = 'Tidak dapat membagi dengan nol!';
          });

          // Hentikan fungsi.
          return;
        }

        // Jika angka kedua bukan 0,
        // lakukan operasi pembagian.
        hasilPerhitungan =
            angkaPertama / angkaKedua;

        break;

      // ------------------------------------------------------
      // 6.5 JIKA OPERASI TIDAK DIKENALI
      // ------------------------------------------------------

      default:
        return;
    }

    // ========================================================
    // 7. MENAMPILKAN HASIL PERHITUNGAN
    // ========================================================

    // Setelah perhitungan selesai,
    // nilai hasil diperbarui.
    setState(() {
      hasil = hasilPerhitungan.toString();
    });
  }

  // ==========================================================
  // 8. MEMBERSIHKAN CONTROLLER
  // ==========================================================

  // dispose() dijalankan ketika halaman sudah tidak digunakan.
  @override
  void dispose() {

    // Membersihkan controller angka pertama.
    angkaPertamaController.dispose();

    // Membersihkan controller angka kedua.
    angkaKeduaController.dispose();

    // Memanggil dispose() milik parent.
    super.dispose();
  }

  // ==========================================================
  // 9. MEMBUAT TAMPILAN APLIKASI
  // ==========================================================

  @override
  Widget build(BuildContext context) {

    // Scaffold adalah struktur dasar halaman Flutter.
    // Di dalamnya kita dapat membuat AppBar dan Body.
    return Scaffold(

      // ======================================================
      // 9.1 BAGIAN ATAS APLIKASI
      // ======================================================

      // AppBar adalah bagian atas aplikasi.
      appBar: AppBar(

        // Judul yang ditampilkan di bagian atas.
        title: const Text('Simple Calculator'),

        // Membuat judul berada di tengah.
        centerTitle: true,
      ),

      // ======================================================
      // 9.2 BAGIAN ISI APLIKASI
      // ======================================================

      body: Padding(

        // Memberikan jarak 20 pixel
        // antara isi dengan tepi layar.
        padding: const EdgeInsets.all(20),

        // Column digunakan untuk menyusun widget
        // secara vertikal dari atas ke bawah.
        child: Column(

          // Membuat seluruh isi berada di tengah.
          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            // ==================================================
            // 10. TEXTFIELD ANGKA PERTAMA
            // ==================================================

            TextField(

              // Menghubungkan TextField dengan controller.
              // Dengan ini kita bisa mengambil input pengguna.
              controller: angkaPertamaController,

              // Menampilkan keyboard angka.
              keyboardType: TextInputType.number,

              // Mengatur tampilan TextField.
              decoration: const InputDecoration(

                // Nama field.
                labelText: 'Angka Pertama',

                // Tulisan bantuan sebelum pengguna mengetik.
                hintText: 'Masukkan angka pertama',

                // Membuat garis kotak pada TextField.
                border: OutlineInputBorder(),
              ),
            ),

            // Memberikan jarak 15 pixel
            // antara TextField pertama dan kedua.
            const SizedBox(height: 15),

            // ==================================================
            // 11. TEXTFIELD ANGKA KEDUA
            // ==================================================

            TextField(

              // Menggunakan controller angka kedua.
              controller: angkaKeduaController,

              // Menampilkan keyboard angka.
              keyboardType: TextInputType.number,

              // Mengatur tampilan TextField.
              decoration: const InputDecoration(
                labelText: 'Angka Kedua',
                hintText: 'Masukkan angka kedua',
                border: OutlineInputBorder(),
              ),
            ),

            // Jarak sebelum tombol operasi.
            const SizedBox(height: 25),

            // ==================================================
            // 12. BARIS TOMBOL OPERASI
            // ==================================================

            // Row digunakan untuk membuat tombol
            // tersusun secara horizontal.
            Row(

              // Membuat jarak antar tombol lebih merata.
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,

              children: [

                // ------------------------------------------------
                // TOMBOL TAMBAH
                // ------------------------------------------------

                ElevatedButton(

                  // Ketika tombol ditekan,
                  // jalankan fungsi hitung dengan operasi "+".
                  onPressed: () => hitung('+'),

                  // Tulisan pada tombol.
                  child: const Text(
                    '+',
                    style: TextStyle(fontSize: 24),
                  ),
                ),

                // ------------------------------------------------
                // TOMBOL KURANG
                // ------------------------------------------------

                ElevatedButton(
                  onPressed: () => hitung('-'),
                  child: const Text(
                    '−',
                    style: TextStyle(fontSize: 24),
                  ),
                ),

                // ------------------------------------------------
                // TOMBOL KALI
                // ------------------------------------------------

                ElevatedButton(
                  onPressed: () => hitung('×'),
                  child: const Text(
                    '×',
                    style: TextStyle(fontSize: 24),
                  ),
                ),

                // ------------------------------------------------
                // TOMBOL BAGI
                // ------------------------------------------------

                ElevatedButton(
                  onPressed: () => hitung('÷'),
                  child: const Text(
                    '÷',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),

            // Memberikan jarak sebelum bagian hasil.
            const SizedBox(height: 30),

            // ==================================================
            // 13. JUDUL HASIL
            // ==================================================

            const Text(
              'Hasil:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Jarak antara tulisan "Hasil:"
            // dengan hasil perhitungan.
            const SizedBox(height: 10),

            // ==================================================
            // 14. MENAMPILKAN HASIL
            // ==================================================

            Text(

              // Menampilkan isi dari variabel hasil.
              hasil,

              // Membuat teks berada di tengah.
              textAlign: TextAlign.center,

              // Mengatur ukuran dan ketebalan tulisan.
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}