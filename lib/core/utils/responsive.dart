import 'package:flutter/material.dart';

/// Helper untuk tampilan responsif (Web, Tablet, Mobile)
class ResponsiveHelper {
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 640;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= 640 && width < 1024;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1024;

  /// Jumlah kolom grid produk responsif
  static int getGridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1200) return 5;
    if (width >= 900) return 4;
    if (width >= 640) return 3;
    return 2;
  }
}

/// Container pembungkus yang membatasi lebar maksimal pada layar Desktop/Web
/// agar tampilan rapi dan tidak terlalu melar ke samping.
class ResponsiveContentWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  const ResponsiveContentWrapper({
    super.key,
    required this.child,
    this.maxWidth = 1100,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

