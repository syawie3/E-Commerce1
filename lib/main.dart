import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/responsive.dart';
import 'pages/feeds_screen.dart';
import 'pages/home_screen.dart';
import 'pages/login_screen.dart';
import 'pages/mall_screen.dart';
import 'pages/profile_screen.dart';
import 'pages/transactions_screen.dart';

void main() {
  runApp(const NavigationBarApp());
}

/// Root Widget Aplikasi E-Commerce
class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modern E-Commerce Store',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const LoginScreen(),
    );
  }
}

/// Shell Navigasi Utama dengan Floating Navigation Bar
class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    FeedsScreen(),
    MallScreen(),
    TransactionsScreen(),
    ProfileScreen(),
  ];

  // Status visibilitas floating navbar saat di-scroll
  bool _showNavigationBar = true;

  // Deteksi arah scroll untuk menyembunyikan/menampilkan navbar
  void _handleScroll(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse) {
        // Scroll ke bawah -> sembunyikan navbar agar pandangan lebih luas
        if (_showNavigationBar) {
          setState(() {
            _showNavigationBar = false;
          });
        }
      } else if (notification.direction == ScrollDirection.forward) {
        // Scroll ke atas -> tampilkan kembali navbar
        if (!_showNavigationBar) {
          setState(() {
            _showNavigationBar = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _handleScroll(notification);
          return false;
        },
        child: Stack(
          children: [
            // Konten Halaman Aktif (IndexedStack agar state tidak reset saat ganti tab)
            IndexedStack(
              index: currentPageIndex,
              children: pages,
            ),

            // Floating Pill Navigation Bar (Responsif di Web & Mobile)
            Positioned(
              left: 16,
              right: 16,
              bottom: 14,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ResponsiveContentWrapper(
                  maxWidth: 520,
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    offset:
                        _showNavigationBar ? Offset.zero : const Offset(0, 1.8),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      opacity: _showNavigationBar ? 1.0 : 0.0,
                      child: _buildFloatingNavBar(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Desain Floating Navbar Modern berbentuk Kapsul (Pill)
  Widget _buildFloatingNavBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          height: 66,
          selectedIndex: currentPageIndex,
          indicatorColor: AppTheme.primaryColor.withOpacity(0.15),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: AppTheme.primaryColor),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon:
                  Icon(Icons.explore_rounded, color: AppTheme.primaryColor),
              label: 'Feeds',
            ),
            NavigationDestination(
              icon: Icon(Icons.storefront_outlined),
              selectedIcon:
                  Icon(Icons.storefront_rounded, color: AppTheme.primaryColor),
              label: 'Mall',
            ),
            NavigationDestination(
              icon: Badge(
                label: Text('2'),
                backgroundColor: AppTheme.primaryColor,
                child: Icon(Icons.receipt_long_outlined),
              ),
              selectedIcon: Badge(
                label: Text('2'),
                backgroundColor: AppTheme.primaryColor,
                child: Icon(Icons.receipt_long_rounded, color: AppTheme.primaryColor),
              ),
              label: 'Transaksi',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon:
                  Icon(Icons.person_rounded, color: AppTheme.primaryColor),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
