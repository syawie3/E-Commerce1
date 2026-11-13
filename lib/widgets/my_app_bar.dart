import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// App bar kustom modern dengan search field, notifikasi badge, dan cart.
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onCartPressed;
  final VoidCallback? onChatPressed;
  final int cartCount;

  const MyAppBar({
    super.key,
    this.onSearchChanged,
    this.onCartPressed,
    this.onChatPressed,
    this.cartCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 72,
      backgroundColor: isDark ? AppTheme.surfaceDark : Colors.white,
      elevation: 0,
      titleSpacing: 16,
      title: Row(
        children: [
          // Logo / Brand Icon mini
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.shopping_bag_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Search Input Bar
          Expanded(
            child: SizedBox(
              height: 44,
              child: TextField(
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Cari headphone, sepatu, buku...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade400,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: AppTheme.primaryColor,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF0F172A)
                      : const Color(0xFFF1F5F9),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Chat Icon Button
          IconButton(
            onPressed: onChatPressed ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Membuka Pusat Pesan & Chat Toko...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            tooltip: 'Pesan',
          ),

          // Cart Icon Button dengan Badge
          IconButton(
            onPressed: onCartPressed ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Keranjang belanja Anda memiliki $cartCount barang',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
            icon: Badge(
              label: Text('$cartCount'),
              isLabelVisible: cartCount > 0,
              backgroundColor: AppTheme.dangerColor,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            tooltip: 'Keranjang',
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}
