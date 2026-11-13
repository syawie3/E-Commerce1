import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../core/utils/responsive.dart';
import '../data/dummy/dummy_produk.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/product_card.dart';

/// Halaman Mall / Official Stores Resmi
class MallScreen extends StatefulWidget {
  const MallScreen({super.key});

  @override
  State<MallScreen> createState() => _MallScreenState();
}

class _MallScreenState extends State<MallScreen> {
  final List<Map<String, dynamic>> officialBrands = [
    {'name': 'Sony', 'icon': Icons.headphones_rounded, 'discount': 'Diskon 40%'},
    {'name': 'Nike', 'icon': Icons.sports_tennis_rounded, 'discount': 'Diskon 30%'},
    {'name': 'Apple', 'icon': Icons.phone_iphone_rounded, 'discount': 'Cashback 1M'},
    {'name': 'Asus ROG', 'icon': Icons.sports_esports_rounded, 'discount': 'Voucher 500k'},
    {'name': 'Samsung', 'icon': Icons.tv_rounded, 'discount': 'Diskon 35%'},
    {'name': 'Uniqlo', 'icon': Icons.checkroom_rounded, 'discount': 'Beli 2 Diskon 20%'},
  ];

  String selectedBrand = 'Semua';

  @override
  Widget build(BuildContext context) {
    final officialProducts =
        products.where((p) => p.isOfficial).toList();

    return Scaffold(
      appBar: const MyAppBar(),
      body: ResponsiveContentWrapper(
        maxWidth: 1200,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // 1. MALL HERO BANNER
              // =========================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'OFFICIAL MALL',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Jaminan 100% Produk Original',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Garansi uang kembali 2x lipat jika barang tidak asli • 7 Hari Pengembalian Gratis',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      flex: 3,
                      child: Icon(
                        Icons.verified_user_rounded,
                        size: 64,
                        color: AppTheme.accentColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // =========================
              // 2. BRAND TERVERIFIKASI
              // =========================
              const Text(
                'Brand Terverifikasi Pilihan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: officialBrands.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final brand = officialBrands[index];
                    return Container(
                      width: 110,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.borderLight),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            brand['icon'] as IconData,
                            size: 32,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            brand['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            brand['discount'] as String,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppTheme.dangerColor,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // =========================
              // 3. PRODUK OFFICIAL STORE
              // =========================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Koleksi Eksklusif Mall',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${officialProducts.length} Produk',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: officialProducts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      ResponsiveHelper.getGridCrossAxisCount(context),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 14,
                  childAspectRatio:
                      ResponsiveHelper.getGridCrossAxisCount(context) >= 4
                          ? 0.75
                          : 0.67,
                ),
                itemBuilder: (context, index) {
                  return ProductCard(product: officialProducts[index]);
                },
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

