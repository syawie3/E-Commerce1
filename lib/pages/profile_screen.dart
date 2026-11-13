import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../core/utils/responsive.dart';
import 'kalkulator_screen.dart';
import 'login_screen.dart';

/// Halaman Profil Pengguna & Pusat Pengaturan
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Membuka Pengaturan Akun...')),
              );
            },
          ),
        ],
      ),
      body: ResponsiveContentWrapper(
        maxWidth: 750,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              // =========================
              // 1. KARTU IDENTITAS USER
              // =========================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 33,
                        backgroundColor: AppTheme.primaryDark,
                        child: const Text(
                          'S',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Syawie Pratama',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'GOLD',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'syawie.developer@example.com',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            '+62 812-3456-7890',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.white),
                      onPressed: () {},
                      tooltip: 'Edit Profil',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // =========================
              // 2. STATUS PESANAN SAYA
              // =========================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pesanan Saya',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildOrderStatusItem(
                          Icons.payment_rounded,
                          'Belum Bayar',
                          '1',
                        ),
                        _buildOrderStatusItem(
                          Icons.inventory_2_outlined,
                          'Dikemas',
                          '2',
                        ),
                        _buildOrderStatusItem(
                          Icons.local_shipping_outlined,
                          'Dikirim',
                          '1',
                        ),
                        _buildOrderStatusItem(
                          Icons.rate_review_outlined,
                          'Beri Nilai',
                          '4',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // =========================
              // 3. DAFTAR MENU & FITUR
              // =========================
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderLight),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      context,
                      icon: Icons.calculate_outlined,
                      title: 'Kalkulator Cepat Belanja',
                      subtitle: 'Hitung total belanjaan dan pembagian harga',
                      badge: 'Baru',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const KalkulatorScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildMenuItem(
                      context,
                      icon: Icons.location_on_outlined,
                      title: 'Alamat Pengiriman',
                      subtitle: 'Rumah, Kantor, dan Alamat Tambahan',
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildMenuItem(
                      context,
                      icon: Icons.favorite_border_rounded,
                      title: 'Wishlist & Favorit',
                      subtitle: '12 Produk Disukai',
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildMenuItem(
                      context,
                      icon: Icons.credit_card_rounded,
                      title: 'Metode Pembayaran',
                      subtitle: 'BCA Virtual Account, GoPay, OVO',
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildMenuItem(
                      context,
                      icon: Icons.security_rounded,
                      title: 'Keamanan Akun & PIN',
                      subtitle: 'Ganti password dan autentikasi 2 langkah',
                      onTap: () {},
                    ),
                    const Divider(height: 1, indent: 56),
                    _buildMenuItem(
                      context,
                      icon: Icons.help_outline_rounded,
                      title: 'Pusat Bantuan & FAQ',
                      subtitle: 'Hubungi Customer Care 24/7',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // =========================
              // 4. TOMBOL LOGOUT
              // =========================
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _confirmLogout(context),
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: AppTheme.dangerColor,
                  ),
                  label: const Text(
                    'Keluar dari Akun',
                    style: TextStyle(
                      color: AppTheme.dangerColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.dangerColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderStatusItem(IconData icon, String label, String badge) {
    return Column(
      children: [
        Badge(
          label: Text(badge),
          backgroundColor: AppTheme.primaryColor,
          child: Icon(icon, size: 28, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    String? badge,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.primaryColor, size: 22),
      ),
      title: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          if (badge != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.successColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: onTap,
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari sesi akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );
  }
}
