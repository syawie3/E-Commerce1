import 'package:flutter/material.dart';

import '../core/services/app_state.dart';
import '../core/theme/app_theme.dart';
import '../data/models/model_produk.dart';

/// Tombol Wishlist dengan Animasi Denyut (Pulse / Bounce Heart)
class AnimatedPulseHeart extends StatefulWidget {
  final Product product;
  final double size;
  final VoidCallback? onToggled;

  const AnimatedPulseHeart({
    super.key,
    required this.product,
    this.size = 20,
    this.onToggled,
  });

  @override
  State<AnimatedPulseHeart> createState() => _AnimatedPulseHeartState();
}

class _AnimatedPulseHeartState extends State<AnimatedPulseHeart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.45)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.45, end: 0.9)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    final appState = AppState.instance;
    final wasFavorite = appState.isFavorite(widget.product);

    _controller.forward(from: 0.0);
    appState.toggleFavorite(widget.product);
    widget.onToggled?.call();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              !wasFavorite ? Icons.favorite : Icons.favorite_border,
              color: !wasFavorite ? AppTheme.dangerColor : Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                !wasFavorite
                    ? '${widget.product.name} disimpan ke Favorit!'
                    : '${widget.product.name} dihapus dari Favorit',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final isFav = AppState.instance.isFavorite(widget.product);

        return ScaleTransition(
          scale: _scaleAnimation,
          child: Material(
            color: Colors.white.withOpacity(0.92),
            shape: const CircleBorder(),
            elevation: 2,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _handleTap,
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: Icon(
                  isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  size: widget.size,
                  color: isFav ? AppTheme.dangerColor : Colors.grey.shade600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
