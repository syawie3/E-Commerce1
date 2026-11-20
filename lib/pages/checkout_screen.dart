import 'package:flutter/material.dart';

import '../core/services/app_state.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/currency_formatter.dart';
import '../core/utils/responsive.dart';
import '../data/models/model_cart.dart';
import '../data/models/model_transaksi.dart';
import '../widgets/checkout_success_dialog.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/safe_image.dart';

/// Halaman Proses Checkout Belanja Lengkap
class CheckoutScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CheckoutScreen({super.key, required this.cartItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController voucherController = TextEditingController();

  // Opsi Pengiriman
  final List<Map<String, dynamic>> shippingOptions = [
    {
      'name': 'J&T Express - Reguler',
      'estimate': 'Estimasi 2-3 hari kerja',
      'cost': 15000,
      'isFast': false,
    },
    {
      'name': 'SiCepat HALU - Hemat',
      'estimate': 'Estimasi 3-4 hari kerja',
      'cost': 11000,
      'isFast': false,
    },
    {
      'name': 'GoSend Instant Delivery',
      'estimate': 'Tiba dalam 2-3 jam hari ini',
      'cost': 28000,
      'isFast': true,
    },
    {
      'name': 'JNE YES - Kilat Esok Sampai',
      'estimate': 'Estimasi 1 hari kerja',
      'cost': 22000,
      'isFast': true,
    },
  ];

  int selectedShippingIndex = 0;

  // Metode Pembayaran
  final List<Map<String, dynamic>> paymentOptions = [
    {
      'name': 'Saldo Pay / GoPay',
      'desc': 'Saldo: Rp 1.450.000 (Cepat & Tanpa Biaya Admin)',
      'icon': Icons.account_balance_wallet_rounded,
      'color': Color(0xFF6366F1),
    },
    {
      'name': 'BCA Virtual Account',
      'desc': 'Verifikasi otomatis dalam hitungan detik',
      'icon': Icons.account_balance_rounded,
      'color': Color(0xFF0284C7),
    },
    {
      'name': 'Mandiri Virtual Account',
      'desc': 'Transfer via Livin by Mandiri atau ATM',
      'icon': Icons.credit_card_rounded,
      'color': Color(0xFF0369A1),
    },
    {
      'name': 'QRIS All Payment',
      'desc': 'Scan QR dengan GoPay, OVO, Dana, ShopeePay, BCA',
      'icon': Icons.qr_code_scanner_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'name': 'COD (Bayar di Tempat)',
      'desc': 'Bayar tunai langsung saat kurir mengantarkan paket',
      'icon': Icons.handshake_rounded,
      'color': Color(0xFFF59E0B),
    },
  ];

  int selectedPaymentIndex = 0;
  int discountAmount = 15000;
  String appliedPromoCode = 'DISKONMEMBER';
  bool isProcessing = false;

  void applyVoucher() {
    final code = voucherController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    if (code == 'MEGASALE' || code == 'DISKON70') {
      setState(() {
        discountAmount = 45000;
        appliedPromoCode = code;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voucher MEGASALE aktif! Diskon Rp 45.000 diterapkan 🎉'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } else if (code == 'GRATISONGKIR') {
      final currentShippingCost =
          shippingOptions[selectedShippingIndex]['cost'] as int;
      setState(() {
        discountAmount = currentShippingCost;
        appliedPromoCode = code;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voucher Gratis Ongkir berhasil diterapkan! 🚚'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kode voucher tidak valid atau sudah kadaluarsa.'),
          backgroundColor: AppTheme.dangerColor,
        ),
      );
    }
  }

  void processPayment() async {
    setState(() => isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => isProcessing = false);

    final shippingCost = shippingOptions[selectedShippingIndex]['cost'] as int;
    final shippingCourier = shippingOptions[selectedShippingIndex]['name'] as String;
    final paymentMethod = paymentOptions[selectedPaymentIndex]['name'] as String;

    final orderItems = widget.cartItems
        .map(
          (cartItem) => OrderItem(
            product: cartItem.product,
            quantity: cartItem.quantity,
            variant: cartItem.variant,
          ),
        )
        .toList();

    // Buat order baru di AppState
    final newOrder = AppState.instance.createOrder(
      items: orderItems,
      storeName: widget.cartItems.first.product.isOfficial
          ? 'Official Store'
          : 'Mitra Toko Terpercaya',
      shippingFee: shippingCost,
      discount: discountAmount,
      paymentMethod: paymentMethod,
      courier: shippingCourier,
      address:
          'Jl. Kemang Raya No. 12, Mampang Prapatan, Jakarta Selatan, 12730 (Penerima: Syawie Pratama - 081234567890)',
    );

    // Hapus barang yang dicheckout dari keranjang
    for (var item in widget.cartItems) {
      AppState.instance.removeFromCart(item.id);
    }

    // Tampilkan Dialog Sukses Beranimasi
    CheckoutSuccessDialog.show(
      context: context,
      order: newOrder,
      onViewOrder: () {
        Navigator.pop(context); // Tutup CheckoutScreen
      },
      onContinueShopping: () {
        Navigator.pop(context); // Tutup CheckoutScreen
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final itemsSubtotal = widget.cartItems
        .fold<int>(0, (sum, item) => sum + item.subtotal);
    final shippingCost = shippingOptions[selectedShippingIndex]['cost'] as int;
    final serviceFee = 1000;
    final grandTotal = (itemsSubtotal + shippingCost + serviceFee - discountAmount)
        .clamp(0, double.infinity)
        .toInt();

    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: const Text('Pengiriman & Checkout'),
      ),
      body: ResponsiveContentWrapper(
        maxWidth: 900,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // 1. ALAMAT PENGIRIMAN
              // =========================
              _buildAddressCard(isDark),

              const SizedBox(height: 18),

              // =========================
              // 2. DAFTAR BARANG YANG DIBELI
              // =========================
              _buildItemsPreview(isDark),

              const SizedBox(height: 18),

              // =========================
              // 3. PILIHAN JASA PENGIRIMAN
              // =========================
              _buildShippingSelector(isDark),

              const SizedBox(height: 18),

              // =========================
              // 4. KODE VOUCHER & DISKON
              // =========================
              _buildVoucherCard(isDark),

              const SizedBox(height: 18),

              // =========================
              // 5. METODE PEMBAYARAN
              // =========================
              _buildPaymentSelector(isDark),

              const SizedBox(height: 18),

              // =========================
              // 6. RINGKASAN PEMBAYARAN
              // =========================
              _buildPaymentSummaryCard(
                itemsSubtotal,
                shippingCost,
                serviceFee,
                grandTotal,
                isDark,
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      // Bottom Bar Bayar
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Total Tagihan',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      Text(
                        formatRupiah(grandTotal),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: isProcessing ? null : processPayment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                  ),
                  child: isProcessing
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Bayar Sekarang',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
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

  Widget _buildAddressCard(bool isDark) {
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
              const Icon(
                Icons.location_on_rounded,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Alamat Pengiriman',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Utama',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Syawie Pratama (+62 812-3456-7890)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            'Jl. Kemang Raya No. 12, Kel. Bangka, Kec. Mampang Prapatan, Kota Jakarta Selatan, DKI Jakarta, 12730',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12, height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsPreview(bool isDark) {
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
          Text(
            'Rincian Pesanan (${widget.cartItems.length} Produk)',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const Divider(height: 20),
          ...widget.cartItems.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SafeImage(
                      imageUrl: item.product.image,
                      width: 54,
                      height: 54,
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
                        const SizedBox(height: 2),
                        Text(
                          '${item.quantity} barang (${item.variant})',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          formatRupiah(item.product.price),
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
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

  Widget _buildShippingSelector(bool isDark) {
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
              Icon(Icons.local_shipping_outlined, color: AppTheme.primaryColor),
              SizedBox(width: 8),
              Text(
                'Pilihan Ekspedisi & Kurir',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(shippingOptions.length, (index) {
            final opt = shippingOptions[index];
            final isSelected = selectedShippingIndex == index;

            return InkWell(
              onTap: () {
                setState(() => selectedShippingIndex = index);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.borderLight,
                    width: isSelected ? 1.8 : 1,
                  ),
                  color: isSelected
                      ? AppTheme.primaryColor.withOpacity(0.04)
                      : null,
                ),
                child: Row(
                  children: [
                    Radio<int>(
                      value: index,
                      groupValue: selectedShippingIndex,
                      activeColor: AppTheme.primaryColor,
                      onChanged: (val) {
                        setState(() => selectedShippingIndex = val!);
                      },
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                opt['name'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              if (opt['isFast'] as bool) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.dangerColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'KILAT',
                                    style: TextStyle(
                                      color: AppTheme.dangerColor,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            opt['estimate'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      formatRupiah(opt['cost'] as int),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildVoucherCard(bool isDark) {
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
              const Icon(Icons.confirmation_num_outlined, color: AppTheme.accentColor),
              const SizedBox(width: 8),
              const Text(
                'Voucher & Kupon Diskon',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (appliedPromoCode.isNotEmpty)
                Text(
                  'Aktif: $appliedPromoCode',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: TextField(
                    controller: voucherController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      hintText: 'Cth: MEGASALE / GRATISONGKIR',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: applyVoucher,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 42),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text('Terapkan'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSelector(bool isDark) {
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
              Icon(Icons.payment_rounded, color: AppTheme.primaryColor),
              SizedBox(width: 8),
              Text(
                'Metode Pembayaran',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(paymentOptions.length, (index) {
            final method = paymentOptions[index];
            final isSelected = selectedPaymentIndex == index;

            return InkWell(
              onTap: () {
                setState(() => selectedPaymentIndex = index);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.borderLight,
                    width: isSelected ? 1.8 : 1,
                  ),
                  color: isSelected
                      ? AppTheme.primaryColor.withOpacity(0.04)
                      : null,
                ),
                child: Row(
                  children: [
                    Radio<int>(
                      value: index,
                      groupValue: selectedPaymentIndex,
                      activeColor: AppTheme.primaryColor,
                      onChanged: (val) {
                        setState(() => selectedPaymentIndex = val!);
                      },
                    ),
                    Icon(
                      method['icon'] as IconData,
                      color: method['color'] as Color,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            method['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            method['desc'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPaymentSummaryCard(
    int itemsSubtotal,
    int shippingCost,
    int serviceFee,
    int grandTotal,
    bool isDark,
  ) {
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
          _buildSummaryRow('Subtotal Produk', formatRupiah(itemsSubtotal)),
          const SizedBox(height: 6),
          _buildSummaryRow('Biaya Pengiriman', formatRupiah(shippingCost)),
          const SizedBox(height: 6),
          _buildSummaryRow('Biaya Layanan Sistem', formatRupiah(serviceFee)),
          const SizedBox(height: 6),
          _buildSummaryRow(
            'Diskon Voucher',
            '-${formatRupiah(discountAmount)}',
            isDiscount: true,
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pembayaran',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                formatRupiah(grandTotal),
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

  Widget _buildSummaryRow(String label, String value, {bool isDiscount = false}) {
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
            color: isDiscount ? AppTheme.successColor : null,
          ),
        ),
      ],
    );
  }
}
