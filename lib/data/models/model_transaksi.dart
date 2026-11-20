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

/// Riwayat Status Pengiriman untuk Timeline Tracking
class TrackingStep {
  final String title;
  final String description;
  final String time;
  final bool isCompleted;

  const TrackingStep({
    required this.title,
    required this.description,
    required this.time,
    this.isCompleted = false,
  });
}

/// Review / Ulasan Produk
class OrderReview {
  final double rating;
  final String comment;
  final DateTime date;

  const OrderReview({
    required this.rating,
    required this.comment,
    required this.date,
  });
}

/// Model Transaksi Pesanan
class TransactionOrder {
  final String id;
  final String invoiceNumber;
  final DateTime date;
  OrderStatus status;
  final String storeName;
  final List<OrderItem> items;
  final int shippingFee;
  final int discount;
  final String paymentMethod;
  final String courier;
  final String shippingAddress;
  final List<TrackingStep> trackingSteps;
  OrderReview? review;

  TransactionOrder({
    required this.id,
    required this.invoiceNumber,
    required this.date,
    required this.status,
    required this.storeName,
    required this.items,
    this.shippingFee = 15000,
    this.discount = 10000,
    this.paymentMethod = 'GoPay / Saldo Pay',
    this.courier = 'J&T Express - Reguler',
    this.shippingAddress = 'Jl. Kemang Raya No. 12, Mampang Prapatan, Jakarta Selatan, 12730',
    this.trackingSteps = const [],
    this.review,
  });

  int get totalAmount {
    final itemsTotal = items.fold<int>(0, (sum, item) => sum + item.subtotal);
    final total = itemsTotal + shippingFee - discount;
    return total < 0 ? 0 : total;
  }
}
