/// Model Data Produk E-Commerce
class Product {
  final String id;
  final String name;
  final String image;
  final int price;
  final int? originalPrice;
  final String category;
  final String description;
  final double rating;
  final int reviewCount;
  final int soldCount;
  final bool isOfficial;
  final bool isFavorite;
  final String location;
  final List<String> gallery;

  Product({
    this.id = '',
    required this.name,
    required this.image,
    required this.price,
    this.originalPrice,
    this.category = 'Umum',
    this.description = 'Produk original berkualitas tinggi dengan garansi resmi. Dibuat dengan material premium dan desain yang modern untuk kenyamanan penggunaan harian Anda.',
    this.rating = 4.8,
    this.reviewCount = 128,
    this.soldCount = 450,
    this.isOfficial = true,
    this.isFavorite = false,
    this.location = 'Jakarta Selatan',
    this.gallery = const [],
  });

  /// Hitung persentase diskon jika ada harga coret
  int get discountPercent {
    if (originalPrice != null && originalPrice! > price) {
      return (((originalPrice! - price) / originalPrice!) * 100).round();
    }
    return 0;
  }

  Product copyWith({
    String? id,
    String? name,
    String? image,
    int? price,
    int? originalPrice,
    String? category,
    String? description,
    double? rating,
    int? reviewCount,
    int? soldCount,
    bool? isOfficial,
    bool? isFavorite,
    String? location,
    List<String>? gallery,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      category: category ?? this.category,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      soldCount: soldCount ?? this.soldCount,
      isOfficial: isOfficial ?? this.isOfficial,
      isFavorite: isFavorite ?? this.isFavorite,
      location: location ?? this.location,
      gallery: gallery ?? this.gallery,
    );
  }
}
