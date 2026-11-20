import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Tombol Kembali (Back Button) Modern dengan Animasi Micro-interaction & Efek Estetik
class CustomBackButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isTransparent;
  final Color? iconColor;
  final Color? backgroundColor;
  final double size;
  final String tooltip;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.isTransparent = false,
    this.iconColor,
    this.backgroundColor,
    this.size = 40,
    this.tooltip = 'Kembali ke halaman sebelumnya',
  });

  @override
  State<CustomBackButton> createState() => _CustomBackButtonState();
}

class _CustomBackButtonState extends State<CustomBackButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultBgColor = widget.isTransparent
        ? Colors.black.withOpacity(0.35)
        : (isDark ? AppTheme.surfaceDark : Colors.white);

    final defaultIconColor = widget.isTransparent
        ? Colors.white
        : (isDark ? Colors.white : AppTheme.textPrimaryLight);

    return Tooltip(
      message: widget.tooltip,
      child: Center(
        child: AnimatedScale(
          duration: const Duration(milliseconds: 150),
          scale: isPressed ? 0.88 : 1.0,
          curve: Curves.easeInOut,
          child: Container(
            width: widget.size,
            height: widget.size,
            margin: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? defaultBgColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: widget.isTransparent
                    ? Colors.white.withOpacity(0.2)
                    : (isDark ? AppTheme.borderDark : AppTheme.borderLight),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(widget.isTransparent ? 0.2 : 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTapDown: (_) => setState(() => isPressed = true),
                onTapUp: (_) => setState(() => isPressed = false),
                onTapCancel: () => setState(() => isPressed = false),
                onTap: () {
                  if (widget.onPressed != null) {
                    widget.onPressed!();
                  } else {
                    Navigator.maybePop(context);
                  }
                },
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: widget.iconColor ?? defaultIconColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
