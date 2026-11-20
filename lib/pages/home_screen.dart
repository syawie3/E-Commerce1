import 'package:flutter/material.dart';

import '../core/services/app_state.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/currency_formatter.dart';
import '../core/utils/responsive.dart';
import '../data/dummy/dummy_kategori.dart';
import '../data/dummy/dummy_produk.dart';
import '../data/models/model_kategori.dart';
import '../data/models/model_produk.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/product_card.dart';
import '../widgets/safe_image.dart';

/// Halaman Beranda Utama E-Commerce dengan Pencarian, Filter & Sorting Interaktif
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategoryId = 'all';
  String searchQuery = '';
  int activeBannerIndex = 0;
  String currentSort = 'default'; // default, price_low, price_high, rating

  final List<Map<String, dynamic>> banners = [
    {
      'title': 'Mega Festival Belanja 2026',
      'subtitle': 'Diskon Spesial Hingga 70% + Gratis Ongkir Se-Indonesia',
      'code': 'MEGASALE',
      'colors': [const Color(0xFF4F46E5), const Color(0xFF7C3AED)],
      'icon': Icons.flash_on_rounded,
    },
    {
      'title': 'Gadget & Tech Universe',
      'subtitle': 'Cashback s.d Rp 1.000.000 untuk Pembelian Smart Device',
      'code': 'GADGETPRO',
      'colors': [const Color(0xFF0284C7), const Color(0xFF06B6D4)],
      'icon': Icons.devices_other_rounded,
    },
    {
      'title': 'Fashion Week Autumn Style',
      'subtitle': 'Koleksi Terkini Distro & Brand Pilihan Terbaik',
      'code': 'STYLE26',
      'colors': [const Color(0xFFDB2777), const Color(0xFFF43F5E)],
      'icon': Icons.checkroom_rounded,
    },
  ];

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                        'Urutkan & Filter Produk',
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
                  const Text(
                    'Urutkan Berdasarkan:',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSortChip('default', 'Rekomendasi', setModalState),
                      _buildSortChip(
                        'price_low',
                        'Harga Terendah',
                        setModalState,
                      ),
                      _buildSortChip(
                        'price_high',
                        'Harga Tertinggi',
                        setModalState,
                      ),
                      _buildSortChip('rating', 'Rating Tertinggi', setModalState),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Terapkan Pengurutan'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortChip(
    String sortKey,
    String label,
    void Function(void Function()) setModalState,
  ) {
    final isSelected = currentSort == sortKey;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setModalState(() {
            currentSort = sortKey;
          });
          setState(() {
            currentSort = sortKey;
          });
        }
      },
      selectedColor: AppTheme.primaryColor.withOpacity(0.15),
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryColor : null,
        fontWeight: isSelected ? FontWeight.bold : null,
      ),
    );
  }

  void _showTopUpSheet() {
    int selectedAmount = 100000;
    final amounts = [50000, 100000, 250000, 500000];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
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
                      'Top Up Saldo Pay',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: amounts.map((a) {
                    final isSel = selectedAmount == a;
                    return ChoiceChip(
                      label: Text(formatRupiah(a)),
                      selected: isSel,
                      onSelected: (sel) {
                        if (sel) setSheetState(() => selectedAmount = a);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      AppState.instance.topUpWallet(selectedAmount);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Top Up ${formatRupiah(selectedAmount)} berhasil!',
                          ),
                          backgroundColor: AppTheme.successColor,
                        ),
                      );
                    },
                    child: Text('Isi ${formatRupiah(selectedAmount)}'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        // Filter produk
        List<Product> filteredProducts = products.where((product) {
          final matchesCategory = selectedCategoryId == 'all' ||
              product.category.toLowerCase() ==
                  selectedCategoryId.toLowerCase();
          final matchesSearch = searchQuery.isEmpty ||
              product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              product.category.toLowerCase().contains(searchQuery.toLowerCase());
          return matchesCategory && matchesSearch;
        }).toList();

        // Urutkan produk
        if (currentSort == 'price_low') {
          filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        } else if (currentSort == 'price_high') {
          filteredProducts.sort((a, b) => b.price.compareTo(a.price));
        } else if (currentSort == 'rating') {
          filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
        }

        return Scaffold(
          appBar: MyAppBar(
            onSearchChanged: (query) {
              setState(() {
                searchQuery = query;
              });
            },
            onFilterPressed: _openFilterModal,
          ),
          body: ResponsiveContentWrapper(
            maxWidth: 1200,
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(milliseconds: 600));
                setState(() {});
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==============================
                    // 1. DOMPET & QUICK ACTIONS
                    // ==============================
                    _buildWalletCard(isDark),

                    const SizedBox(height: 18),

                    // ==============================
                    // 2. PROMO BANNER CAROUSEL
                    // ==============================
                    _buildPromoBannerCarousel(),

                    const SizedBox(height: 24),

                    // ==============================
                    // 3. KATEGORI PILIHAN
                    // ==============================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Kategori Pilihan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedCategoryId = 'all';
                              searchQuery = '';
                              currentSort = 'default';
                            });
                          },
                          child: const Text('Reset Filter'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildCategoryList(),

                    const SizedBox(height: 24),

                    // ==============================
                    // 4. FLASH SALE SECTION
                    // ==============================
                    if (selectedCategoryId == 'all' && searchQuery.isEmpty) ...[
                      _buildFlashSaleSection(),
                      const SizedBox(height: 24),
                    ],

                    // ==============================
                    // 5. GRID PRODUK TERBARU
                    // ==============================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Rekomendasi Untuk Anda',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${filteredProducts.length} item',
                                style: const TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: _openFilterModal,
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 4,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.sort_rounded,
                                  size: 18,
                                  color: AppTheme.primaryColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  currentSort == 'default'
                                      ? 'Urutkan'
                                      : 'Diurutkan',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // List / Grid Produk
                    if (filteredProducts.isEmpty)
                      _buildEmptyState()
                    else
                      _buildProductGrid(filteredProducts),

                    // Padding ekstra di bawah agar tidak tertutup floating navbar
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Card Dompet & Saldo Ringkas
  Widget _buildWalletCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Saldo Pay
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Saldo Pay',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    Text(
                      formatRupiah(AppState.instance.walletBalance),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Divider vertikal
          Container(
            height: 30,
            width: 1,
            color: Colors.grey.shade300,
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),

          // Koin Rewards
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.monetization_on_rounded,
                    color: AppTheme.accentColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Koin Bonus',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    Text(
                      '${AppState.instance.coinBalance} Koin',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tombol Topup
          FilledButton.tonal(
            onPressed: _showTopUpSheet,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: const Size(0, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_circle_outline, size: 16),
                SizedBox(width: 4),
                Text('Top Up', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Banner Promo Carousel
  Widget _buildPromoBannerCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 155,
          child: PageView.builder(
            itemCount: banners.length,
            onPageChanged: (index) {
              setState(() {
                activeBannerIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: banner['colors'] as List<Color>,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (banner['colors'] as List<Color>)[0]
                          .withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  banner['icon'] as IconData,
                                  color: Colors.white,
                                  size: 13,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'KODE: ${banner['code']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            banner['title'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            banner['subtitle'] as String,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Voucher promo ${banner['code']} berhasil diklaim!',
                                ),
                                backgroundColor: AppTheme.successColor,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor:
                                (banner['colors'] as List<Color>)[0],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Klaim',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: activeBannerIndex == index ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: activeBannerIndex == index
                    ? AppTheme.primaryColor
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Horizontal Category List
  Widget _buildCategoryList() {
    final allCategories = [
      const Category(
        id: 'all',
        name: 'Semua',
        image: 'https://cdn-icons-png.flaticon.com/512/3502/3502601.png',
      ),
      ...categories,
    ];

    return SizedBox(
      height: 105,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: allCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cat = allCategories[index];
          final isSelected = selectedCategoryId == cat.id ||
              (cat.id == 'all' && selectedCategoryId == 'all');

          return InkWell(
            onTap: () {
              setState(() {
                selectedCategoryId = cat.id;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 76,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 66,
                    height: 66,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.borderLight,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? AppTheme.primaryColor.withOpacity(0.3)
                              : Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: cat.id == 'all'
                          ? Icon(
                              Icons.grid_view_rounded,
                              size: 28,
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.primaryColor,
                            )
                          : SafeImage(
                              imageUrl: cat.image,
                              width: 38,
                              height: 38,
                              fit: BoxFit.contain,
                              fallbackIcon: Icons.category_outlined,
                            ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? AppTheme.primaryColor
                          : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Flash Sale Horizontal Row
  Widget _buildFlashSaleSection() {
    final flashSaleProducts = products.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.bolt_rounded,
                  color: AppTheme.dangerColor,
                  size: 26,
                ),
                const SizedBox(width: 4),
                const Text(
                  'Flash Sale',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                // Timer Chip
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.dangerColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '03 : 24 : 12',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: flashSaleProducts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = flashSaleProducts[index];
              return SizedBox(
                width: 165,
                child: ProductCard(product: product),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Grid Produk dengan Aspect Ratio yang Pas (Bebas Overflow!)
  Widget _buildProductGrid(List<Product> productList) {
    final crossAxisCount = ResponsiveHelper.getGridCrossAxisCount(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: productList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 14,
        childAspectRatio: crossAxisCount >= 4 ? 0.75 : 0.67,
      ),
      itemBuilder: (context, index) {
        final product = productList[index];
        return ProductCard(product: product);
      },
    );
  }

  /// Tampilan jika pencarian / kategori kosong
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 54,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Produk Tidak Ditemukan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Coba ubah kata kunci atau pilih kategori lain.',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                searchQuery = '';
                selectedCategoryId = 'all';
                currentSort = 'default';
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reset Pencarian'),
          ),
        ],
      ),
    );
  }
}
