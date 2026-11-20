import 'package:flutter/material.dart';

import '../core/services/app_state.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/currency_formatter.dart';
import '../core/utils/responsive.dart';
import '../data/models/model_produk.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/safe_image.dart';
import 'cart_screen.dart';
import 'detail_product_screen.dart';

/// Halaman Wishlist & Produk Favorit Interaktif
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final favoriteProducts = AppState.instance.favoriteProducts;

        return Scaffold(
          appBar: AppBar(
            leading: const CustomBackButton(),
            title: Text('Wishlist Saya (${favoriteProducts.length})'),
            actions: [
              IconButton(
                icon: Badge(
                  label: Text('${AppState.instance.cartCount}'),
                  isLabelVisible: AppState.instance.cartCount > 0,
                  backgroundColor: AppTheme.dangerColor,
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                tooltip: 'Keranjang',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
            ],
          ),
          body: favoriteProducts.isEmpty
              ? _buildEmptyWishlist(context)
              : ResponsiveContentWrapper(
                  maxWidth: 1100,
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    itemCount: favoriteProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          ResponsiveHelper.getGridCrossAxisCount(context),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 14,
                      childAspectRatio:
                          ResponsiveHelper.getGridCrossAxisCount(context) >= 4
                              ? 0.72
                              : 0.64,
                    ),
                    itemBuilder: (context, index) {
                      final product = favoriteProducts[index];
                      return _buildWishlistCard(context, product, isDark);
                    },
                  ),
                ),
        );
      },
    );
  }

  Widget _buildWishlistCard(
    BuildContext context,
    Product product,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar + Tombol Hapus Favorit
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailProductScreen(product: product),
                        ),
                      );
                    },
                    child: SafeImage(
                      imageUrl: product.image,
                      fit: BoxFit.cover,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.white.withOpacity(0.9),
                    shape: const CircleBorder(),
                    elevation: 2,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        AppState.instance.toggleFavorite(product);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.favorite_rounded,
                          color: AppTheme.dangerColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Detail Produk
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      height: 1.25,
                    ),
                  ),
                  Text(
                    formatRupiah(product.price),
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        AppState.instance.addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${product.name} dimasukkan ke keranjang belanja!',
                            ),
                            backgroundColor: AppTheme.successColor,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        minimumSize: const Size(0, 34),
                      ),
                      icon: const Icon(Icons.add_shopping_cart, size: 14),
                      label: const Text(
                        'Keranjang',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWishlist(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.dangerColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 64,
                color: AppTheme.dangerColor,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Wishlist Masih Kosong',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Simpan barang-barang favorit Anda dengan menekan ikon hati pada produk impian!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.explore_outlined),
              label: const Text('Jelajahi Produk Pilihan'),
            ),
          ],
        ),
      ),
    );
  }
}
