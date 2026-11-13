import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../core/utils/responsive.dart';

/// Halaman Kalkulator Modern & Bebas Error
class KalkulatorScreen extends StatefulWidget {
  const KalkulatorScreen({super.key});

  @override
  State<KalkulatorScreen> createState() => _KalkulatorScreenState();
}

class _KalkulatorScreenState extends State<KalkulatorScreen> {
  final TextEditingController angkaPertamaController = TextEditingController();
  final TextEditingController angkaKeduaController = TextEditingController();

  String hasil = '0';
  String operatorDipilih = '+';
  String? errorMessage;

  void hitung(String operasi) {
    setState(() {
      operatorDipilih = operasi;
      errorMessage = null;

      final input1 = angkaPertamaController.text.trim();
      final input2 = angkaKeduaController.text.trim();

      if (input1.isEmpty || input2.isEmpty) {
        errorMessage = 'Mohon masukkan kedua angka terlebih dahulu';
        return;
      }

      final angka1 = double.tryParse(input1);
      final angka2 = double.tryParse(input2);

      if (angka1 == null || angka2 == null) {
        errorMessage = 'Format angka tidak valid';
        return;
      }

      double hasilOperasi = 0;

      switch (operasi) {
        case '+':
          hasilOperasi = angka1 + angka2;
          break;
        case '-':
          hasilOperasi = angka1 - angka2;
          break;
        case 'x':
          hasilOperasi = angka1 * angka2;
          break;
        case ':':
          if (angka2 == 0) {
            errorMessage = 'Tidak bisa dibagi dengan angka 0';
            return;
          }
          hasilOperasi = angka1 / angka2;
          break;
        default:
          errorMessage = 'Operasi tidak dikenali';
          return;
      }

      // Format hasil: jika bilangan bulat, hilangkan .0
      if (hasilOperasi == hasilOperasi.roundToDouble()) {
        hasil = hasilOperasi.toInt().toString();
      } else {
        hasil = hasilOperasi.toStringAsFixed(2);
      }
    });
  }

  void reset() {
    setState(() {
      angkaPertamaController.clear();
      angkaKeduaController.clear();
      hasil = '0';
      errorMessage = null;
    });
  }

  @override
  void dispose() {
    angkaPertamaController.dispose();
    angkaKeduaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator Cepat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reset',
            onPressed: reset,
          ),
        ],
      ),
      body: ResponsiveContentWrapper(
        maxWidth: 550,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display Hasil
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'HASIL PERHITUNGAN',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      hasil,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              if (errorMessage != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.dangerColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppTheme.dangerColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppTheme.dangerColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: AppTheme.dangerColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Input Angka 1
              TextField(
                controller: angkaPertamaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Angka Pertama',
                  hintText: 'Masukkan nilai pertama (cth: 150)',
                  prefixIcon: const Icon(Icons.looks_one_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Input Angka 2
              TextField(
                controller: angkaKeduaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Angka Kedua',
                  hintText: 'Masukkan nilai kedua (cth: 50)',
                  prefixIcon: const Icon(Icons.looks_two_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Pilih Operasi Matematika:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Tombol-tombol Operasi
              Row(
                children: [
                  _buildOperatorButton('+', 'Tambah', Icons.add),
                  const SizedBox(width: 10),
                  _buildOperatorButton('-', 'Kurang', Icons.remove),
                  const SizedBox(width: 10),
                  _buildOperatorButton('x', 'Kali', Icons.close),
                  const SizedBox(width: 10),
                  _buildOperatorButton(':', 'Bagi', Icons.percent),
                ],
              ),

              const SizedBox(height: 24),

              // Tombol Bersihkan
              OutlinedButton.icon(
                onPressed: reset,
                icon: const Icon(Icons.clear_all),
                label: const Text('Bersihkan Layar'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOperatorButton(String op, String label, IconData icon) {
    final isSelected = operatorDipilih == op;
    return Expanded(
      child: ElevatedButton(
        onPressed: () => hitung(op),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppTheme.primaryColor : null,
          foregroundColor: isSelected ? Colors.white : null,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: isSelected ? 4 : 0,
        ),
        child: Text(
          op,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
