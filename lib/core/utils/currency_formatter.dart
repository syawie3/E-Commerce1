/// Format nominal angka menjadi format mata uang Rupiah Indonesia yang rapi.
/// Contoh: 250000 -> "Rp 250.000"
String formatRupiah(num? amount) {
  if (amount == null) return 'Rp 0';
  final int value = amount.round();
  final String str = value.toString();
  final buffer = StringBuffer();

  int count = 0;
  for (int i = str.length - 1; i >= 0; i--) {
    buffer.write(str[i]);
    count++;
    if (count % 3 == 0 && i != 0) {
      buffer.write('.');
    }
  }

  return 'Rp ${buffer.toString().split('').reversed.join('')}';
}

/// Format angka ribuan ringkas (Contoh: 1500 -> "1.5k")
String formatCompactNumber(int number) {
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}k';
  }
  return number.toString();
}

