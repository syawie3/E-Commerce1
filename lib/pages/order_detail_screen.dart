import 'package:flutter/material.dart';

import '../core/services/app_state.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/currency_formatter.dart';
import '../core/utils/responsive.dart';
import '../data/models/model_transaksi.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/safe_image.dart';
import 'chat_screen.dart';

/// Halaman Detail Transaksi & Pelacakan Pesanan Real-time
class OrderDetailScreen extends StatefulWidget {
  final TransactionOrder order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  void _showReviewDialog(BuildContext context, TransactionOrder order) {
    double selectedRating = 5;
    final commentController = TextEditingController(
      text: 'Produk sangat memuaskan, pengemasan aman dan pengiriman kilat!',
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text('Beri Ulasan Produk'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Bagaimana kualitas produk yang Anda terima?',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starIndex = index + 1;
                    return IconButton(
                      icon: Icon(
                        starIndex <= selectedRating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: AppTheme.accentColor,
                        size: 32,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          selectedRating = starIndex.toDouble();
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Tulis ulasan Anda di sini...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  AppState.instance.submitOrderReview(
                    order.id,
                    selectedRating,
                    commentController.text,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Terima kasih! Ulasan Anda telah disimpan.'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                },
                child: const Text('Kirim Ulasan'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmCancelOrder(BuildContext context, TransactionOrder order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Pesanan?'),
        content: const Text(
          'Apakah Anda yakin ingin membatalkan pesanan ini? Dana yang sudah dibayarkan akan dikembalikan ke Saldo Pay Anda.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kembali'),
          ),
          ElevatedButton(
            onPressed: () {
              AppState.instance.cancelOrder(order.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pesanan berhasil dibatalkan'),
                  backgroundColor: AppTheme.dangerColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerColor,
            ),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final currentOrder = AppState.instance.orders.firstWhere(
          (o) => o.id == widget.order.id,
          orElse: () => widget.order,
        );

        Color statusColor;
        Color statusBgColor;

        switch (currentOrder.status) {
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

        return Scaffold(
          appBar: AppBar(
            leading: const CustomBackButton(),
            title: const Text('Rincian Pesanan'),
            actions: [
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                tooltip: 'Chat Toko',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatScreen()),
                  );
                },
              ),
            ],
          ),
          body: ResponsiveContentWrapper(
            maxWidth: 850,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Header Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.inventory_2_rounded, color: statusColor, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentOrder.status.label,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                currentOrder.invoiceNumber,
                                style: TextStyle(
                                  color: statusColor.withOpacity(0.85),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Timeline Pelacakan Pengiriman
                  _buildTrackingTimeline(currentOrder, isDark),

                  const SizedBox(height: 18),

                  // Alamat Pengiriman
                  _buildAddressSection(currentOrder, isDark),

                  const SizedBox(height: 18),

                  // Daftar Produk
                  _buildProductsList(currentOrder, isDark),

                  const SizedBox(height: 18),

                  // Info Pembayaran
                  _buildPaymentInfo(currentOrder, isDark),

                  const SizedBox(height: 24),

                  // Review section jika sudah direview
                  if (currentOrder.review != null) ...[
                    _buildReviewDisplay(currentOrder.review!, isDark),
                    const SizedBox(height: 24),
                  ],

                  // Tombol Aksi Bawah
                  if (currentOrder.status == OrderStatus.selesai &&
                      currentOrder.review == null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _showReviewDialog(context, currentOrder),
                        icon: const Icon(Icons.star_outline_rounded),
                        label: const Text('Beri Ulasan Produk'),
                      ),
                    ),

                  if (currentOrder.status == OrderStatus.dikemas ||
                      currentOrder.status == OrderStatus.menungguPembayaran)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () =>
                            _confirmCancelOrder(context, currentOrder),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppTheme.dangerColor),
                          foregroundColor: AppTheme.dangerColor,
                        ),
                        child: const Text('Batalkan Pesanan Ini'),
                      ),
                    ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrackingTimeline(TransactionOrder order, bool isDark) {
    final steps = order.trackingSteps.isNotEmpty
        ? order.trackingSteps
        : [
            const TrackingStep(
              title: 'Pesanan Telah Dibuat',
              description: 'Pembayaran terverifikasi dan diteruskan ke toko',
              time: '10:30 WIB',
              isCompleted: true,
            ),
            const TrackingStep(
              title: 'Paket Sedang Dikemas',
              description: 'Penjual sedang membungkus pesanan dengan bubble wrap',
              time: '14:15 WIB',
              isCompleted: true,
            ),
            const TrackingStep(
              title: 'Dalam Perjalanan Kurir',
              description: 'Paket telah dibawa oleh kurir ekspedisi',
              time: 'Estimasi besok',
              isCompleted: false,
            ),
            const TrackingStep(
              title: 'Pesanan Selesai',
              description: 'Paket telah diterima oleh penerima',
              time: 'Estimasi 2-3 hari',
              isCompleted: false,
            ),
          ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.route_outlined, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              const Text(
                'Lacak Pengiriman',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                'Resi: JT${order.id.replaceAll(RegExp(r'[^0-9]'), '').padRight(12, '8')}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          ...List.generate(steps.length, (index) {
            final step = steps[index];
            final isLast = index == steps.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: step.isCompleted
                            ? AppTheme.primaryColor
                            : Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        step.isCompleted ? Icons.check : Icons.circle,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 36,
                        color: step.isCompleted
                            ? AppTheme.primaryColor
                            : Colors.grey.shade300,
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            step.title,
                            style: TextStyle(
                              fontWeight: step.isCompleted
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            step.time,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step.description,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAddressSection(TransactionOrder order, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on_outlined, color: AppTheme.primaryColor),
              SizedBox(width: 8),
              Text(
                'Alamat Tujuan Pengiriman',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            order.shippingAddress,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kurir: ${order.courier}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(TransactionOrder order, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.storefront_rounded, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              Text(
                order.storeName,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 20),
          ...order.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SafeImage(
                      imageUrl: item.product.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        if (item.variant != null)
                          Text(
                            'Varian: ${item.variant}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        Text(
                          '${item.quantity} barang x ${formatRupiah(item.product.price)}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    formatRupiah(item.subtotal),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo(TransactionOrder order, bool isDark) {
    final itemsSubtotal = order.items.fold<int>(0, (s, i) => s + i.subtotal);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rincian Pembayaran',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const Divider(height: 20),
          _buildRow('Metode Pembayaran', order.paymentMethod),
          const SizedBox(height: 6),
          _buildRow('Subtotal Produk', formatRupiah(itemsSubtotal)),
          const SizedBox(height: 6),
          _buildRow('Ongkos Kirim', formatRupiah(order.shippingFee)),
          const SizedBox(height: 6),
          _buildRow('Diskon Voucher', '-${formatRupiah(order.discount)}', isGreen: true),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Belanja',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                formatRupiah(order.totalAmount),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewDisplay(OrderReview review, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Ulasan Anda',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(width: 8),
              Row(
                children: List.generate(
                  review.rating.toInt(),
                  (i) => const Icon(
                    Icons.star_rounded,
                    color: AppTheme.accentColor,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            review.comment,
            style: const TextStyle(fontSize: 12, height: 1.35),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isGreen ? AppTheme.successColor : null,
          ),
        ),
      ],
    );
  }
}
