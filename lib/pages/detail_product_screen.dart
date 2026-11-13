import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../core/utils/currency_formatter.dart';
import '../core/utils/responsive.dart';
import '../data/models/model_produk.dart';
import '../widgets/safe_image.dart';

/// Halaman Detail Produk Lengkap & Interaktif
class DetailProductScreen extends StatefulWidget {
  final Product product;

  const DetailProductScreen({super.key, required this.product});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  late bool isFavorite;
  int quantity = 1;
  int selectedVariantIndex = 0;

  final List<String> variants = ['Default', 'Black Edition', 'Silver Metallic'];

  @override
  void initState() {
    super.initState();
    isFavorite = widget.product.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? AppTheme.dangerColor : null,
            ),
            tooltip: 'Favorit',
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFavorite
                        ? 'Produk ditambahkan ke Wishlist'
                        : 'Produk dihapus dari Wishlist',
                  ),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          IconButton(
            icon: const Badge(
              label: Text('3'),
              backgroundColor: AppTheme.dangerColor,
              child: Icon(Icons.shopping_cart_outlined),
            ),
            tooltip: 'Keranjang',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Membuka Keranjang Belanja...'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'share') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Tautan ${product.name} telah disalin!'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              } else if (value == 'report') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Laporan Anda telah dikirim ke tim admin.'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share_outlined, size: 20),
                    SizedBox(width: 10),
                    Text('Bagikan'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.report_outlined, size: 20),
                    SizedBox(width: 10),
                    Text('Laporkan Produk'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ResponsiveContentWrapper(
        maxWidth: 900,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // 1. GAMBAR HERO PRODUK
              // =========================
              Stack(
                children: [
                  SafeImage(
                    imageUrl: product.image,
                    width: double.infinity,
                    height: 340,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        '1 / 4 Foto',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // =========================
              // 2. INFORMASI HARGA & NAMA
              // =========================
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Toko / Badge Official
                    Row(
                      children: [
                        if (product.isOfficial) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: Colors.white,
                                  size: 13,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'OFFICIAL STORE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          product.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Harga & Diskon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatRupiah(product.price),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        if (product.originalPrice != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            formatRupiah(product.originalPrice),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade500,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.dangerColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '-${product.discountPercent}%',
                              style: const TextStyle(
                                color: AppTheme.dangerColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Nama Produk
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Rating & Terjual
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppTheme.accentColor,
                          size: 22,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${product.reviewCount} ulasan)',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '•  ${product.soldCount} Terjual',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 36),

                    // =========================
                    // 3. PILIH VARIAN
                    // =========================
                    const Text(
                      'Pilih Varian',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: List.generate(
                        variants.length,
                        (index) {
                          final isSelected = selectedVariantIndex == index;
                          return ChoiceChip(
                            label: Text(variants[index]),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  selectedVariantIndex = index;
                                });
                              }
                            },
                            selectedColor:
                                AppTheme.primaryColor.withOpacity(0.15),
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : null,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            side: BorderSide(
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : AppTheme.borderLight,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 18),

                    // =========================
                    // 4. JUMLAH PEMBELIAN
                    // =========================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Jumlah Pembelian',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 18),
                                onPressed: quantity > 1
                                    ? () => setState(() => quantity--)
                                    : null,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  '$quantity',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 18),
                                onPressed: () => setState(() => quantity++),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 36),

                    // =========================
                    // 5. DESKRIPSI PRODUK
                    // =========================
                    const Text(
                      'Deskripsi Produk',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                      ),
                    ),

                    const Divider(height: 36),

                    // =========================
                    // 6. ULASAN PEMBELI
                    // =========================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ulasan Pembeli',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Lihat Semua'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    _buildReviewItem(
                      name: 'Andi Saputra',
                      time: '2 hari lalu',
                      rating: 5,
                      comment:
                          'Produk sangat bagus dan sesuai deskripsi! Pengiriman cepat, packing rapi pakai bubble tebal.',
                      avatarColor: Colors.blue,
                    ),
                    _buildReviewItem(
                      name: 'Budi Santoso',
                      time: '1 minggu lalu',
                      rating: 5,
                      comment:
                          'Kualitas material mantap, build quality solid. Rekomendasi buat yang cari gadget berkualitas.',
                      avatarColor: Colors.green,
                    ),
                    _buildReviewItem(
                      name: 'Siti Rahma',
                      time: '2 minggu lalu',
                      rating: 4,
                      comment:
                          'Barang sampai dengan aman. Fungsi berjalan normal semua. Penjual responsif.',
                      avatarColor: Colors.purple,
                    ),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // =========================
      // BOTTOM ACTION BAR
      // =========================
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.surfaceDark : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: ResponsiveContentWrapper(
            maxWidth: 900,
            child: Row(
              children: [
                // Chat Seller
                IconButton.outlined(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Menghubungkan dengan penjual via Chat...'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline_rounded),
                  tooltip: 'Chat Penjual',
                ),

                const SizedBox(width: 10),

                // Tambah Keranjang
                Expanded(
                  flex: 4,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '$quantity x ${product.name} dimasukkan ke keranjang',
                          ),
                          backgroundColor: AppTheme.successColor,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart_rounded),
                    label: const Text('Keranjang'),
                  ),
                ),

                const SizedBox(width: 10),

                // Beli Sekarang
                Expanded(
                  flex: 5,
                  child: ElevatedButton(
                    onPressed: () => _showCheckoutDialog(context, product),
                    child: Text(
                      'Beli Sekarang (${formatRupiah(product.price * quantity)})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Dialog Checkout Ringkas
  void _showCheckoutDialog(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final total = product.price * quantity;
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ringkasan Pesanan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SafeImage(
                    imageUrl: product.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Varian: ${variants[selectedVariantIndex]} | $quantity Barang'),
                trailing: Text(
                  formatRupiah(total),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pesanan berhasil dibuat! Terima kasih.'),
                        backgroundColor: AppTheme.successColor,
                      ),
                    );
                  },
                  child: const Text('Konfirmasi Pembayaran'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Review Item Widget
  Widget _buildReviewItem({
    required String name,
    required String time,
    required int rating,
    required String comment,
    required Color avatarColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: avatarColor.withOpacity(0.15),
                child: Text(
                  name[0],
                  style: TextStyle(
                    color: avatarColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  rating,
                  (index) => const Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: AppTheme.accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment,
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}
