import '../models/model_transaksi.dart';
import 'dummy_produk.dart';

/// Dummy data riwayat transaksi
final List<TransactionOrder> dummyTransactions = [
  TransactionOrder(
    id: 'TRX-20261110-001',
    invoiceNumber: 'INV/20261110/MPL/9842109',
    date: DateTime.now().subtract(const Duration(hours: 3)),
    status: OrderStatus.dikemas,
    storeName: 'Anker Official Store',
    items: [
      OrderItem(
        product: products[0],
        quantity: 1,
        variant: 'Matte Black',
      ),
    ],
    shippingFee: 12000,
    discount: 10000,
  ),
  TransactionOrder(
    id: 'TRX-20261108-002',
    invoiceNumber: 'INV/20261108/MPL/7718923',
    date: DateTime.now().subtract(const Duration(days: 2)),
    status: OrderStatus.dikirim,
    storeName: 'Aza Wear Official',
    items: [
      OrderItem(
        product: products[2],
        quantity: 1,
        variant: 'Size 42 - Red Flame',
      ),
    ],
    shippingFee: 15000,
    discount: 15000,
  ),
  TransactionOrder(
    id: 'TRX-20261102-003',
    invoiceNumber: 'INV/20261102/MPL/6192840',
    date: DateTime.now().subtract(const Duration(days: 6)),
    status: OrderStatus.selesai,
    storeName: 'Gramedia Book Store',
    items: [
      OrderItem(
        product: products[8],
        quantity: 2,
        variant: 'Hardcover Edition',
      ),
    ],
    shippingFee: 10000,
    discount: 5000,
  ),
  TransactionOrder(
    id: 'TRX-20261025-004',
    invoiceNumber: 'INV/20261025/MPL/4491023',
    date: DateTime.now().subtract(const Duration(days: 14)),
    status: OrderStatus.selesai,
    storeName: 'Gadget Mall Official',
    items: [
      OrderItem(
        product: products[1],
        quantity: 1,
        variant: 'Midnight Blue',
      ),
    ],
    shippingFee: 18000,
    discount: 20000,
  ),
  TransactionOrder(
    id: 'TRX-20261012-005',
    invoiceNumber: 'INV/20261012/MPL/2298711',
    date: DateTime.now().subtract(const Duration(days: 25)),
    status: OrderStatus.dibatalkan,
    storeName: 'Custom Distro Bandung',
    items: [
      OrderItem(
        product: products[6],
        quantity: 3,
        variant: 'Size L - Black/White',
      ),
    ],
    shippingFee: 10000,
    discount: 0,
  ),
];

