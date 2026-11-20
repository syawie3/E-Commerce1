import 'package:flutter/material.dart';

import '../core/services/app_state.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/currency_formatter.dart';
import '../core/utils/responsive.dart';
import '../data/dummy/dummy_produk.dart';
import '../data/models/model_cart.dart';
import '../data/models/model_produk.dart';
import '../widgets/animated_pulse_heart.dart';
import '../widgets/product_card.dart';
import '../widgets/safe_image.dart';
import 'cart_screen.dart';
import 'chat_screen.dart';
import 'checkout_screen.dart';

/// Halaman Detail Produk Lengkap & Modern Seperti Aplikasi Belanja Pada Umumnya
/// dengan Tombol Kembali Mengambang di Sudut Atas Kiri.
class DetailProductScreen extends StatefulWidget {
  final Product? product;

  const DetailProductScreen({super.key, this.product});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  int quantity = 1;
  int selectedVariantIndex = 0;
  int selectedPhotoIndex = 0;
  bool isCartAnimating = false;

  final List<String> variants = ['Default', 'Black Edition', 'Silver Metallic'];

  @override
  Widget build(BuildContext context) {
    // Ambil data produk yang dikirimkan, atau default ke produk pertama jika null
    final currentProduct = widget.product ??
        (products.isNotEmpty
            ? products.first
            : Product(
                id: 'prod-default',
                name: 'Wireless Headphone Premium',
                image:
                    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&auto=format&fit=crop&q=80',
                price: 349000,
              ));

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Galeri foto produk (multiview foto untuk dipilih pembeli)
    final List<String> photoGallery = currentProduct.gallery.isNotEmpty
        ? currentProduct.gallery
        : [
            currentProduct.image,
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&auto=format&fit=crop&q=80',
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&auto=format&fit=crop&q=80',
            'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&auto=format&fit=crop&q=80',
          ];

    // Daftar rekomendasi produk lainnya dari katalog toko
    final relatedProducts =
        products.where((p) => p.id != currentProduct.id).take(6).toList();

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final cartCount = AppState.instance.cartCount;

        return Scaffold(
          body: ResponsiveContentWrapper(
            maxWidth: 900,
            child: Stack(
              children: [
                // ==========================================
                // 1. KONTEN DETAIL PRODUK (SCROLLABLE DARI ATAS)
                // ==========================================
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- GAMBAR UTAMA PRODUK ---
                      Stack(
                        children: [
                          SafeImage(
                            imageUrl: photoGallery[
                                selectedPhotoIndex % photoGallery.length],
                            width: double.infinity,
                            height: 380,
                            fit: BoxFit.cover,
                          ),

                          // Indikator Posisi Foto di Kanan Bawah
                          Positioned(
                            bottom: 14,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.65),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '${selectedPhotoIndex + 1} / ${photoGallery.length} Foto',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // --- DERETAN THUMBNAIL FOTO PRODUK ---
                      Container(
                        height: 70,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        color: isDark ? AppTheme.surfaceDark : Colors.white,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: photoGallery.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final isSelected = selectedPhotoIndex == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedPhotoIndex = index;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme.primaryColor
                                        : AppTheme.borderLight,
                                    width: isSelected ? 2.5 : 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: SafeImage(
                                    imageUrl: photoGallery[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const Divider(height: 1),

                      // --- INFORMASI HARGA, NAMA & RATING PRODUK ---
                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Toko / Badge Official Store & Status Stok
                            Row(
                              children: [
                                if (currentProduct.isOfficial) ...[
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
                                  currentProduct.location,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.successColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Stok Tersedia (45 unit)',
                                    style: TextStyle(
                                      color: AppTheme.successColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                  formatRupiah(currentProduct.price),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                if (currentProduct.originalPrice != null) ...[
                                  const SizedBox(width: 10),
                                  Text(
                                    formatRupiah(currentProduct.originalPrice),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade500,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          AppTheme.dangerColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '-${currentProduct.discountPercent}%',
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

                            // Nama Lengkap Produk
                            Text(
                              currentProduct.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Rating Bintang & Terjual
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: AppTheme.accentColor,
                                  size: 22,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  currentProduct.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '(${currentProduct.reviewCount} ulasan)',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '•  ${currentProduct.soldCount} Terjual',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const Divider(height: 36),

                            // --- PILIH VARIAN PRODUK ---
                            const Text(
                              'Pilih Varian Produk',
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
                                  final isSelected =
                                      selectedVariantIndex == index;
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
                                    selectedColor: AppTheme.primaryColor
                                        .withOpacity(0.15),
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

                            // --- JUMLAH PEMBELIAN ---
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
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon:
                                            const Icon(Icons.remove, size: 18),
                                        onPressed: quantity > 1
                                            ? () => setState(() => quantity--)
                                            : null,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
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
                                        onPressed: () =>
                                            setState(() => quantity++),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const Divider(height: 36),

                            // --- TABEL SPESIFIKASI PRODUK ---
                            const Text(
                              'Spesifikasi Produk',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppTheme.surfaceDark
                                    : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppTheme.borderLight),
                              ),
                              child: Column(
                                children: [
                                  _buildSpecRow(
                                      'Kategori', currentProduct.category),
                                  const Divider(height: 16),
                                  _buildSpecRow(
                                      'Merek / Brand', 'Original Official'),
                                  const Divider(height: 16),
                                  _buildSpecRow(
                                      'Kondisi', 'Baru (100% Segel Asli)'),
                                  const Divider(height: 16),
                                  _buildSpecRow(
                                      'Garansi', '1 Tahun Garansi Resmi'),
                                  const Divider(height: 16),
                                  _buildSpecRow('Dikirim Dari',
                                      currentProduct.location),
                                  const Divider(height: 16),
                                  _buildSpecRow('Berat Produk', '450 Gram'),
                                ],
                              ),
                            ),

                            const Divider(height: 36),

                            // --- DESKRIPSI PRODUK ---
                            const Text(
                              'Deskripsi Produk',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              currentProduct.description,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.6,
                                color: isDark
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade800,
                              ),
                            ),

                            const Divider(height: 36),

                            // --- ULASAN PEMBELI ---
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
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
                                  'Kualitas material mantap, build quality solid. Rekomendasi buat yang cari barang berkualitas.',
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

                            const Divider(height: 40),

                            // --- PRODUK TERKAIT & REKOMENDASI TOKO ---
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Produk Terkait & Rekomendasi',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${relatedProducts.length} Produk',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: relatedProducts.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    ResponsiveHelper.getGridCrossAxisCount(
                                        context),
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 14,
                                childAspectRatio:
                                    ResponsiveHelper.getGridCrossAxisCount(
                                                context) >=
                                            4
                                        ? 0.75
                                        : 0.67,
                              ),
                              itemBuilder: (context, index) {
                                return ProductCard(
                                    product: relatedProducts[index]);
                              },
                            ),

                            const SizedBox(height: 120),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ==========================================
                // 2. FLOATING TOP BAR (SEPERTI APLIKASI BELANJA UMUMNYA)
                //    DENGAN TOMBOL BALIK DI ATAS KIRI
                // ==========================================
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          // --- TOMBOL BALIK DI SUDUT ATAS KIRI ---
                          _buildFloatingCircleButton(
                            icon: Icons.arrow_back_ios_new_rounded,
                            tooltip: 'Kembali',
                            onTap: () => Navigator.maybePop(context),
                          ),

                          const Spacer(),

                          // --- TOMBOL BAGIKAN DI ATAS KANAN ---
                          _buildFloatingCircleButton(
                            icon: Icons.share_outlined,
                            tooltip: 'Bagikan',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Tautan ${currentProduct.name} telah disalin!',
                                  ),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),

                          const SizedBox(width: 10),

                          // --- TOMBOL FAVORIT / WISHLIST DI ATAS KANAN ---
                          AnimatedPulseHeart(
                            product: currentProduct,
                            size: 20,
                          ),

                          const SizedBox(width: 10),

                          // --- TOMBOL KERANJANG DI ATAS KANAN (DENGAN BADGE) ---
                          _buildFloatingCartButton(context, cartCount),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ==========================================
          // BOTTOM ACTION BAR (STICKY KERANJANG & CHECKOUT)
          // ==========================================
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.chat_bubble_outline_rounded),
                      tooltip: 'Chat Penjual',
                    ),

                    const SizedBox(width: 10),

                    // Tambah Keranjang dengan Animasi Micro-interaction
                    Expanded(
                      flex: 4,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 200),
                        scale: isCartAnimating ? 0.94 : 1.0,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() => isCartAnimating = true);
                            Future.delayed(
                                const Duration(milliseconds: 200), () {
                              if (mounted) {
                                setState(() => isCartAnimating = false);
                              }
                            });

                            AppState.instance.addToCart(
                              currentProduct,
                              quantity: quantity,
                              variant: variants[selectedVariantIndex],
                            );

                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        '$quantity x ${currentProduct.name} dimasukkan ke keranjang!',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: AppTheme.successColor,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                action: SnackBarAction(
                                  label: 'Lihat',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CartScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_shopping_cart_rounded),
                          label: const Text('Keranjang'),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Beli Sekarang -> Langsung Checkout
                    Expanded(
                      flex: 5,
                      child: ElevatedButton(
                        onPressed: () {
                          final directItem = CartItem(
                            id: 'direct_${DateTime.now().millisecondsSinceEpoch}',
                            product: currentProduct,
                            quantity: quantity,
                            variant: variants[selectedVariantIndex],
                            isSelected: true,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutScreen(
                                cartItems: [directItem],
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Beli Sekarang (${formatRupiah(currentProduct.price * quantity)})',
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
      },
    );
  }

  /// Tombol Bulat Mengambang Estetik di Atas Foto (Shopee / Tokopedia Style)
  Widget _buildFloatingCircleButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white.withOpacity(0.92),
        shape: const CircleBorder(),
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.2),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Icon(
              icon,
              color: Colors.black87,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  /// Tombol Keranjang Bulat Mengambang dengan Badge Hitungan Real-time
  Widget _buildFloatingCartButton(BuildContext context, int cartCount) {
    return Tooltip(
      message: 'Keranjang Belanja',
      child: Material(
        color: Colors.white.withOpacity(0.92),
        shape: const CircleBorder(),
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.2),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Badge(
              label: Text('$cartCount'),
              isLabelVisible: cartCount > 0,
              backgroundColor: AppTheme.dangerColor,
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.black87,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Widget Ulasan Pembeli
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
