import 'model_produk.dart';

/// Model Item dalam Keranjang Belanja
class CartItem {
  final String id;
  final Product product;
  int quantity;
  final String variant;
  bool isSelected;

  CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
    this.variant = 'Default',
    this.isSelected = true,
  });

  int get subtotal => product.price * quantity;

  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
    String? variant,
    bool? isSelected,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      variant: variant ?? this.variant,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
