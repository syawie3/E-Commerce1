import 'package:flutter/material.dart';

import '../../data/dummy/dummy_produk.dart';
import '../../data/dummy/dummy_transaksi.dart';
import '../../data/models/model_cart.dart';
import '../../data/models/model_produk.dart';
import '../../data/models/model_transaksi.dart';

/// Pesan Chat Antara Pengguna dan Toko
class ChatMessage {
  final String id;
  final String sender;
  final String text;
  final DateTime time;
  final bool isMe;

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.time,
    required this.isMe,
  });
}

/// Saluran Chat Toko
class ChatConversation {
  final String id;
  final String storeName;
  final String avatar;
  final List<ChatMessage> messages;
  final bool isOnline;

  ChatConversation({
    required this.id,
    required this.storeName,
    required this.avatar,
    required this.messages,
    this.isOnline = true,
  });

  String get lastMessage =>
      messages.isNotEmpty ? messages.last.text : 'Mulai percakapan...';

  DateTime get lastTime =>
      messages.isNotEmpty ? messages.last.time : DateTime.now();
}

/// Notification Item
class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final IconData icon;
  final Color iconColor;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.isRead = false,
  });
}

/// Central Reactive App State Manager
/// Mengelola keranjang, favorit, transaksi, chat, dan notifikasi secara terintegrasi.
class AppState extends ChangeNotifier {
  // Singleton pattern
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  static AppState get instance => _instance;

  AppState._internal() {
    _initDefaultState();
  }

  // ==========================================
  // 1. DATA USER & WALLET
  // ==========================================
  String userName = 'Syawie Pratama';
  String userEmail = 'syawie.developer@example.com';
  String userPhone = '+62 812-3456-7890';
  int walletBalance = 1450000;
  int coinBalance = 25400;

  void topUpWallet(int amount) {
    walletBalance += amount;
    notifyListeners();
  }

  bool deductWallet(int amount) {
    if (walletBalance >= amount) {
      walletBalance -= amount;
      notifyListeners();
      return true;
    }
    return false;
  }

  // ==========================================
  // 2. KERANJANG BELANJA (CART)
  // ==========================================
  final List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  int get selectedCartCount => _cartItems
      .where((item) => item.isSelected)
      .fold(0, (sum, item) => sum + item.quantity);

  int get selectedSubtotal => _cartItems
      .where((item) => item.isSelected)
      .fold(0, (sum, item) => sum + item.subtotal);

  bool get isAllSelected =>
      _cartItems.isNotEmpty && _cartItems.every((item) => item.isSelected);

  void addToCart(Product product, {int quantity = 1, String variant = 'Default'}) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id && item.variant == variant,
    );

    if (existingIndex != -1) {
      _cartItems[existingIndex].quantity += quantity;
    } else {
      _cartItems.add(
        CartItem(
          id: 'cart_${DateTime.now().millisecondsSinceEpoch}_${product.id}',
          product: product,
          quantity: quantity,
          variant: variant,
          isSelected: true,
        ),
      );
    }
    notifyListeners();
  }

  void updateCartQuantity(String cartItemId, int newQuantity) {
    final index = _cartItems.indexWhere((i) => i.id == cartItemId);
    if (index != -1) {
      if (newQuantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void removeFromCart(String cartItemId) {
    _cartItems.removeWhere((item) => item.id == cartItemId);
    notifyListeners();
  }

  void toggleCartItemSelection(String cartItemId) {
    final index = _cartItems.indexWhere((i) => i.id == cartItemId);
    if (index != -1) {
      _cartItems[index].isSelected = !_cartItems[index].isSelected;
      notifyListeners();
    }
  }

  void toggleSelectAllCart(bool selectAll) {
    for (var item in _cartItems) {
      item.isSelected = selectAll;
    }
    notifyListeners();
  }

  void removeSelectedCartItems() {
    _cartItems.removeWhere((item) => item.isSelected);
    notifyListeners();
  }

  // ==========================================
  // 3. WISHLIST / FAVORIT
  // ==========================================
  final Set<String> _favoriteProductIds = {};

  Set<String> get favoriteProductIds => Set.unmodifiable(_favoriteProductIds);

  bool isFavorite(Product product) => _favoriteProductIds.contains(product.id);

  void toggleFavorite(Product product) {
    if (_favoriteProductIds.contains(product.id)) {
      _favoriteProductIds.remove(product.id);
    } else {
      _favoriteProductIds.add(product.id);
    }
    notifyListeners();
  }

  List<Product> get favoriteProducts {
    return products
        .where((product) => _favoriteProductIds.contains(product.id))
        .toList();
  }

  // ==========================================
  // 4. TRANSAKSI & PESANAN (ORDERS)
  // ==========================================
  final List<TransactionOrder> _orders = [];

  List<TransactionOrder> get orders => List.unmodifiable(_orders);

  TransactionOrder createOrder({
    required List<OrderItem> items,
    required String storeName,
    required int shippingFee,
    required int discount,
    required String paymentMethod,
    required String courier,
    required String address,
  }) {
    final newOrder = TransactionOrder(
      id: 'TRX-${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      invoiceNumber: 'INV/${DateTime.now().millisecondsSinceEpoch}/MPL',
      date: DateTime.now(),
      status: OrderStatus.dikemas,
      storeName: storeName,
      items: items,
      shippingFee: shippingFee,
      discount: discount,
      paymentMethod: paymentMethod,
      courier: courier,
      shippingAddress: address,
      trackingSteps: [
        TrackingStep(
          title: 'Pesanan Telah Dibuat',
          description: 'Pembayaran telah dikonfirmasi dan pesanan diteruskan ke penjual',
          time: 'Baru saja',
          isCompleted: true,
        ),
        TrackingStep(
          title: 'Sedang Dikemas Penjual',
          description: 'Penjual sedang menyiapkan barang untuk diserahkan ke kurir',
          time: 'Hari ini',
          isCompleted: true,
        ),
        const TrackingStep(
          title: 'Diserahkan ke Kurir',
          description: 'Paket dalam perjalanan menuju sorting hub',
          time: 'Estimasi besok',
          isCompleted: false,
        ),
        const TrackingStep(
          title: 'Paket Diterima',
          description: 'Paket telah sampai di alamat tujuan',
          time: 'Estimasi 2-3 hari',
          isCompleted: false,
        ),
      ],
    );

    _orders.insert(0, newOrder);

    // Tambah notifikasi pesanan
    addNotification(
      title: 'Pesanan Berhasil Dibuat!',
      message: 'Pesanan #${newOrder.invoiceNumber} sedang dikemas oleh $storeName.',
      icon: Icons.inventory_2_rounded,
      iconColor: const Color(0xFF6366F1),
    );

    notifyListeners();
    return newOrder;
  }

  void cancelOrder(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].status = OrderStatus.dibatalkan;
      notifyListeners();
    }
  }

  void submitOrderReview(String orderId, double rating, String comment) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].review = OrderReview(
        rating: rating,
        comment: comment,
        date: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // ==========================================
  // 5. CHAT SYSTEM (PERCAKAPAN TOKO)
  // ==========================================
  final List<ChatConversation> _conversations = [];

  List<ChatConversation> get conversations =>
      List.unmodifiable(_conversations);

  void sendChatMessage(String conversationId, String text) {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final newMsg = ChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        sender: userName,
        text: text,
        time: DateTime.now(),
        isMe: true,
      );
      _conversations[index].messages.add(newMsg);
      notifyListeners();

      // Simulasi auto-reply ramah dari toko setelah 1 detik
      Future.delayed(const Duration(milliseconds: 1200), () {
        final storeName = _conversations[index].storeName;
        String autoReplyText =
            'Halo kak! Terima kasih sudah menghubungi $storeName. Produk ready stock dan siap kami kirim hari ini ya! 😊📦';

        if (text.toLowerCase().contains('diskon') ||
            text.toLowerCase().contains('promo')) {
          autoReplyText =
              'Untuk promo aktif, kakak bisa pakai voucher cashback di halaman checkout ya! Selamat berbelanja kak ✨';
        } else if (text.toLowerCase().contains('kapan kirim') ||
            text.toLowerCase().contains('ongkir')) {
          autoReplyText =
              'Pesanan sebelum jam 16:00 WIB kami kirim di hari yang sama kak! Pengiriman cepat dengan garansi aman.';
        }

        final replyMsg = ChatMessage(
          id: 'reply_${DateTime.now().millisecondsSinceEpoch}',
          sender: storeName,
          text: autoReplyText,
          time: DateTime.now(),
          isMe: false,
        );
        _conversations[index].messages.add(replyMsg);
        notifyListeners();
      });
    }
  }

  // ==========================================
  // 6. NOTIFIKASI PUSAT
  // ==========================================
  final List<AppNotification> _notifications = [];

  List<AppNotification> get notifications =>
      List.unmodifiable(_notifications);

  int get unreadNotificationCount =>
      _notifications.where((n) => !n.isRead).length;

  void addNotification({
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
  }) {
    _notifications.insert(
      0,
      AppNotification(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        message: message,
        time: DateTime.now(),
        icon: icon,
        iconColor: iconColor,
      ),
    );
    notifyListeners();
  }

  void markAllNotificationsAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  // ==========================================
  // INISIALISASI DATA DUMMY AWAL
  // ==========================================
  void _initDefaultState() {
    // 1. Wishlist awal
    if (products.length >= 3) {
      _favoriteProductIds.add(products[0].id);
      _favoriteProductIds.add(products[2].id);
    }

    // 2. Item cart awal agar langsung bisa dicoba oleh pengguna
    if (products.length >= 2) {
      _cartItems.add(
        CartItem(
          id: 'cart_init_1',
          product: products[0],
          quantity: 1,
          variant: 'Black Edition',
          isSelected: true,
        ),
      );
      _cartItems.add(
        CartItem(
          id: 'cart_init_2',
          product: products[1],
          quantity: 2,
          variant: 'Midnight Blue',
          isSelected: true,
        ),
      );
    }

    // 3. Riwayat Transaksi awal
    _orders.addAll(dummyTransactions);

    // 4. Saluran Chat Awal
    _conversations.addAll([
      ChatConversation(
        id: 'chat_anker',
        storeName: 'Anker Official Store',
        avatar:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=100&auto=format&fit=crop&q=80',
        messages: [
          ChatMessage(
            id: 'm1',
            sender: 'Anker Official Store',
            text:
                'Halo Kak Syawie! Pesanan Headphone Pro Anda sedang dalam proses packing ya.',
            time: DateTime.now().subtract(const Duration(hours: 2)),
            isMe: false,
          ),
          ChatMessage(
            id: 'm2',
            sender: 'Syawie Pratama',
            text: 'Baik kak, terima kasih banyak atas respon cepatnya!',
            time: DateTime.now().subtract(const Duration(hours: 1)),
            isMe: true,
          ),
        ],
      ),
      ChatConversation(
        id: 'chat_nike',
        storeName: 'Aza Wear Official',
        avatar:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=100&auto=format&fit=crop&q=80',
        messages: [
          ChatMessage(
            id: 'm3',
            sender: 'Aza Wear Official',
            text: 'Halo kak, sepatu running size 42 warna merah sudah ready stock ya.',
            time: DateTime.now().subtract(const Duration(days: 1)),
            isMe: false,
          ),
        ],
      ),
    ]);

    // 5. Notifikasi Awal
    _notifications.addAll([
      AppNotification(
        id: 'n1',
        title: 'Flash Sale Sedang Berlangsung! ⚡',
        message: 'Dapatkan diskon hingga 70% untuk produk headphone & smartwatch pilihan.',
        time: DateTime.now().subtract(const Duration(minutes: 45)),
        icon: Icons.bolt_rounded,
        iconColor: const Color(0xFFEF4444),
      ),
      AppNotification(
        id: 'n2',
        title: 'Paket Sedang Dikirim 🚚',
        message: 'Pesanan #INV/20261108/MPL/7718923 telah dibawa kurir J&T Express.',
        time: DateTime.now().subtract(const Duration(hours: 3)),
        icon: Icons.local_shipping_rounded,
        iconColor: const Color(0xFF06B6D4),
      ),
      AppNotification(
        id: 'n3',
        title: 'Cashback 25.400 Koin Telah Masuk',
        message: 'Selamat! Koin reward dari transaksi sebelumnya berhasil dikreditkan ke akun Anda.',
        time: DateTime.now().subtract(const Duration(days: 1)),
        icon: Icons.monetization_on_rounded,
        iconColor: const Color(0xFFF59E0B),
        isRead: true,
      ),
    ]);
  }
}
