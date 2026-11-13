import 'model_produk.dart';

/// Status Transaksi Pesanan
enum OrderStatus {
  menungguPembayaran('Menunggu Pembayaran'),
  dikemas('Sedang Dikemas'),
  dikirim('Sedang Dikirim'),
  selesai('Selesai'),
  dibatalkan('Dibatalkan');

  final String label;
  const OrderStatus(this.label);
}

/// Item dalam transaksi
class OrderItem {
  final Product product;
  final int quantity;
  final String? variant;

  const OrderItem({
    required this.product,
    this.quantity = 1,
    this.variant,
  });

  int get subtotal => product.price * quantity;
}

/// Model Transaksi Pesanan
class TransactionOrder {
  final String id;
  final String invoiceNumber;
  final DateTime date;
  final OrderStatus status;
  final String storeName;
  final List<OrderItem> items;
  final int shippingFee;
  final int discount;

  const TransactionOrder({
    required this.id,
    required this.invoiceNumber,
    required this.date,
    required this.status,
    required this.storeName,
    required this.items,
    this.shippingFee = 15000,
    this.discount = 10000,
  });

  int get totalAmount {
    final itemsTotal = items.fold<int>(0, (sum, item) => sum + item.subtotal);
    return itemsTotal + shippingFee - discount;
  }
}

