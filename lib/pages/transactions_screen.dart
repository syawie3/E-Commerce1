import 'package:flutter/material.dart';

import '../core/services/app_state.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/currency_formatter.dart';
import '../core/utils/responsive.dart';
import '../data/models/model_transaksi.dart';
import '../widgets/safe_image.dart';
import 'detail_product_screen.dart';
import 'order_detail_screen.dart';

/// Halaman Riwayat Transaksi & Status Pesanan Real-time
class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> tabs = [
    'Semua',
    'Dikemas',
    'Dikirim',
    'Selesai',
    'Dibatalkan',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final orders = AppState.instance.orders;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Daftar Transaksi'),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppTheme.primaryColor,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: tabs.map((tab) => Tab(text: tab)).toList(),
            ),
          ),
          body: ResponsiveContentWrapper(
            maxWidth: 900,
            child: TabBarView(
              controller: _tabController,
              children: tabs.map((tabName) {
                final filteredList = orders.where((order) {
                  if (tabName == 'Semua') return true;
                  if (tabName == 'Dikemas') {
                    return order.status == OrderStatus.dikemas;
                  }
                  if (tabName == 'Dikirim') {
                    return order.status == OrderStatus.dikirim;
                  }
                  if (tabName == 'Selesai') {
                    return order.status == OrderStatus.selesai;
                  }
                  if (tabName == 'Dibatalkan') {
                    return order.status == OrderStatus.dibatalkan;
                  }
                  return true;
                }).toList();

                if (filteredList.isEmpty) {
                  return _buildEmptyState(tabName);
                }

                return ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: filteredList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final order = filteredList[index];
                    return _buildOrderCard(order);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  /// Card Riwayat Transaksi
  Widget _buildOrderCard(TransactionOrder order) {
    final firstItem = order.items.first;

    Color statusColor;
    Color statusBgColor;

    switch (order.status) {
      case OrderStatus.selesai:
        statusColor = AppTheme.successColor;
        statusBgColor = AppTheme.successColor.withOpacity(0.12);
        break;
      case OrderStatus.dikirim:
        statusColor = AppTheme.secondaryColor;
        statusBgColor = AppTheme.secondaryColor.withOpacity(0.12);
        break;
      case OrderStatus.dikemas:
        statusColor = AppTheme.accentColor;
        statusBgColor = AppTheme.accentColor.withOpacity(0.15);
        break;
      case OrderStatus.menungguPembayaran:
        statusColor = Colors.orange;
        statusBgColor = Colors.orange.withOpacity(0.12);
        break;
      case OrderStatus.dibatalkan:
        statusColor = AppTheme.dangerColor;
        statusBgColor = AppTheme.dangerColor.withOpacity(0.12);
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetailScreen(order: order),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card: Toko & Status Badge
                Row(
                  children: [
                    const Icon(
                      Icons.storefront_rounded,
                      size: 18,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        order.storeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order.status.label,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Nomor Invoice & Tanggal
                Text(
                  '${order.invoiceNumber} • ${_formatDate(order.date)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),

                const Divider(height: 24),

                // Konten Produk
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SafeImage(
                        imageUrl: firstItem.product.image,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            firstItem.product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          if (firstItem.variant != null)
                            Text(
                              'Variasi: ${firstItem.variant}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            '${firstItem.quantity} barang x ${formatRupiah(firstItem.product.price)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          if (order.items.length > 1)
                            Text(
                              '+${order.items.length - 1} produk lainnya',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const Divider(height: 24),

                // Footer: Total Belanja & Action Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Belanja',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        Text(
                          formatRupiah(order.totalAmount),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OrderDetailScreen(order: order),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            minimumSize: const Size(0, 36),
                          ),
                          child: const Text('Lacak', style: TextStyle(fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailProductScreen(
                                  product: firstItem.product,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            minimumSize: const Size(0, 36),
                          ),
                          child: const Text('Beli Lagi',
                              style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String tabName) {
    return Center(
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
              Icons.receipt_long_outlined,
              size: 50,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada transaksi di tab "$tabName"',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Yuk mulai belanja produk impian Anda sekarang!',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} Nov ${date.year}';
  }
}
