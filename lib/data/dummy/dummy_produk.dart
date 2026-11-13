import '../models/model_produk.dart';

/// Koleksi data produk dummy e-commerce
final List<Product> products = [
  Product(
    id: 'prod-1',
    name: 'Wireless Noise Cancelling Headphone Pro',
    image:
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&auto=format&fit=crop&q=80',
    price: 349000,
    originalPrice: 499000,
    category: 'Elektronik',
    rating: 4.9,
    reviewCount: 284,
    soldCount: 1420,
    isOfficial: true,
    location: 'Jakarta Barat',
    description:
        'Headphone wireless dengan fitur Active Noise Cancellation terkini. Baterai tahan hingga 40 jam pemakaian non-stop dengan suara bass yang mendalam dan jernih.',
  ),
  Product(
    id: 'prod-2',
    name: 'Smart Watch Fitness Tracker Series 9',
    image:
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&auto=format&fit=crop&q=80',
    price: 499000,
    originalPrice: 650000,
    category: 'Gadget',
    rating: 4.8,
    reviewCount: 312,
    soldCount: 980,
    isOfficial: true,
    location: 'Jakarta Pusat',
    description:
        'Smartwatch canggih dengan layar AMOLED 1.78 inci, sensor detak jantung, SpO2, GPS internal, serta tahan air hingga kedalaman 50 meter (5ATM).',
  ),
  Product(
    id: 'prod-3',
    name: 'Sepatu Running Ultralight Breathable',
    image:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&auto=format&fit=crop&q=80',
    price: 389000,
    originalPrice: 520000,
    category: 'Olahraga',
    rating: 4.9,
    reviewCount: 512,
    soldCount: 2350,
    isOfficial: true,
    location: 'Bandung',
    description:
        'Sepatu lari super ringan dengan bantalan foam berteknologi responsif tinggi. Upper berbahan rajut sirkulasi udara yang nyaman dipakai seharian.',
  ),
  Product(
    id: 'prod-4',
    name: 'Backpack Anti-Air Urban Minimalist Laptop 15"',
    image:
        'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600&auto=format&fit=crop&q=80',
    price: 219000,
    originalPrice: 299000,
    category: 'Fashion',
    rating: 4.7,
    reviewCount: 189,
    soldCount: 740,
    isOfficial: false,
    location: 'Tangerang',
    description:
        'Tas ransel elegan berbahan kanvas tahan air (water-repellent) dengan kompartemen laptop busa tebal dan port USB charger eksternal.',
  ),
  Product(
    id: 'prod-5',
    name: 'Mechanical Gaming Keyboard RGB Hot-Swappable',
    image:
        'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&auto=format&fit=crop&q=80',
    price: 580000,
    originalPrice: 750000,
    category: 'Gaming',
    rating: 4.9,
    reviewCount: 430,
    soldCount: 1100,
    isOfficial: true,
    location: 'Surabaya',
    description:
        'Keyboard mekanikal layout 75% dengan switch tactile pre-lubed yang empuk. Lampu RGB 16.8 juta warna dengan berbagai efek dinamis.',
  ),
  Product(
    id: 'prod-6',
    name: 'Wireless Ergonomic Gaming Mouse 16000 DPI',
    image:
        'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=600&auto=format&fit=crop&q=80',
    price: 275000,
    originalPrice: 350000,
    category: 'Gaming',
    rating: 4.8,
    reviewCount: 220,
    soldCount: 890,
    isOfficial: true,
    location: 'Jakarta Barat',
    description:
        'Mouse gaming nirkabel dengan latensi super rendah 1ms dan baterai tahan hingga 70 jam. Desain ergonomis mencegah lelah saat bermain game.',
  ),
  Product(
    id: 'prod-7',
    name: 'Kaos Polos Heavyweight Cotton Combed 24s',
    image:
        'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=600&auto=format&fit=crop&q=80',
    price: 89000,
    originalPrice: 120000,
    category: 'Fashion',
    rating: 4.8,
    reviewCount: 860,
    soldCount: 4200,
    isOfficial: false,
    location: 'Bandung',
    description:
        'Bahan 100% katun combed 24s tebal, lembut di kulit, menyerap keringat dengan baik, dan jahitan rantai standar distro.',
  ),
  Product(
    id: 'prod-8',
    name: 'Mesin Kopi Espresso Manual Portable Maker',
    image:
        'https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=600&auto=format&fit=crop&q=80',
    price: 460000,
    originalPrice: 590000,
    category: 'Makanan',
    rating: 4.9,
    reviewCount: 175,
    soldCount: 520,
    isOfficial: true,
    location: 'Jakarta Selatan',
    description:
        'Alat seduh espresso portabel bertekanan hingga 18 bar. Menghasilkan crema espresso tebal dan kaya rasa layaknya kafe profesional.',
  ),
  Product(
    id: 'prod-9',
    name: 'Buku Atomic Habits: Perubahan Kecil Hasil Menakjubkan',
    image:
        'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=600&auto=format&fit=crop&q=80',
    price: 98000,
    originalPrice: 115000,
    category: 'Buku',
    rating: 5.0,
    reviewCount: 1250,
    soldCount: 8900,
    isOfficial: true,
    location: 'Jakarta Timur',
    description:
        'Buku bestseller internasional karya James Clear tentang sistem pembentukan kebiasaan baik dan eliminasi kebiasaan buruk secara praktis.',
  ),
  Product(
    id: 'prod-10',
    name: 'Smart Speaker Voice Assistant Wireless Bluetooth',
    image:
        'https://images.unsplash.com/photo-1543512214-318c7553f230?w=600&auto=format&fit=crop&q=80',
    price: 320000,
    originalPrice: 420000,
    category: 'Elektronik',
    rating: 4.7,
    reviewCount: 140,
    soldCount: 610,
    isOfficial: false,
    location: 'Semarang',
    description:
        'Speaker pintar dengan suara 360 derajat omnidirectional dan kontrol suara untuk smart home Anda.',
  ),
];
