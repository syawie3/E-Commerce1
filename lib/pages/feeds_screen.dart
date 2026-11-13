import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../core/utils/currency_formatter.dart';
import '../core/utils/responsive.dart';
import '../data/dummy/dummy_produk.dart';
import '../data/models/model_produk.dart';
import '../widgets/safe_image.dart';
import 'detail_product_screen.dart';

/// Halaman Feeds Sosial & Inspirasi Belanja
class FeedsScreen extends StatefulWidget {
  const FeedsScreen({super.key});

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final Set<int> likedPosts = {};

  final List<Map<String, dynamic>> posts = [
    {
      'creator': 'GadgetReviewer ID',
      'avatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
      'time': '2 jam yang lalu',
      'caption':
          'Unboxing Wireless Noise Cancelling Headphone! Bass-nya nendang banget dan fitur ANC-nya benar-benar senyap. Cocok banget buat kerja di cafe atau fokus belajar. Rekomended banget guys! 🔥🎧',
      'tags': '#TechReview #Gadget2026 #HeadphoneANC',
      'product': products[0],
      'likes': 428,
      'comments': 38,
    },
    {
      'creator': 'RunnerLife Indonesia',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80',
      'time': '5 jam yang lalu',
      'caption':
          'Morning run 10K ditemani sepatu ultralight ini. Bantalannya super empuk dan gak bikin kaki cepat pegal. Buat kalian yang mau mulai rutinitas olahraga, ini pilihan terbaik! 🏃‍♂️⚡',
      'tags': '#RunningShoes #HealthyLifestyle #SportOutfit',
      'product': products[2],
      'likes': 892,
      'comments': 64,
    },
    {
      'creator': 'SetupMinimalis Indo',
      'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&auto=format&fit=crop&q=80',
      'time': '1 hari yang lalu',
      'caption':
          'Setup produktivitas baru selesai dirakit. Mechanical Keyboard RGB ini feel mengetiknya satisfying banget dengan switch yang tactile dan suaranya renyah! ⌨️✨',
      'tags': '#DeskSetup #MechanicalKeyboard #TechAesthetic',
      'product': products[4],
      'likes': 1204,
      'comments': 95,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feeds & Inspirasi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: ResponsiveContentWrapper(
        maxWidth: 700,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: posts.length + 1,
          separatorBuilder: (_, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildStoriesBar();
            }
            final postIndex = index - 1;
            final post = posts[postIndex];
            final isLiked = likedPosts.contains(postIndex);
            final currentLikes = (post['likes'] as int) + (isLiked ? 1 : 0);

            return _buildFeedCard(post, postIndex, isLiked, currentLikes);
          },
        ),
      ),
    );
  }

  /// Stories Bar
  Widget _buildStoriesBar() {
    final stories = [
      {'name': 'Cerita Anda', 'icon': Icons.add_rounded, 'isMine': true},
      {'name': 'Anker ID', 'icon': Icons.storefront_rounded, 'isMine': false},
      {'name': 'Nike Official', 'icon': Icons.bolt_rounded, 'isMine': false},
      {'name': 'TechDaily', 'icon': Icons.videocam_rounded, 'isMine': false},
      {'name': 'CoffeeLover', 'icon': Icons.coffee_rounded, 'isMine': false},
    ];

    return SizedBox(
      height: 95,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final story = stories[index];
          final isMine = story['isMine'] as bool;

          return Column(
            children: [
              Container(
                width: 62,
                height: 62,
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isMine
                      ? null
                      : const LinearGradient(
                          colors: [Color(0xFFF43F5E), Color(0xFFF59E0B)],
                        ),
                  border: isMine ? Border.all(color: Colors.grey.shade400) : null,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      story['icon'] as IconData,
                      color: isMine ? AppTheme.primaryColor : Colors.black87,
                      size: 26,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                story['name'] as String,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Feed Post Card
  Widget _buildFeedCard(
    Map<String, dynamic> post,
    int index,
    bool isLiked,
    int currentLikes,
  ) {
    final product = post['product'] as Product;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Author
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SafeImage(
                    imageUrl: post['avatar'] as String,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post['creator'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            color: AppTheme.primaryColor,
                            size: 14,
                          ),
                        ],
                      ),
                      Text(
                        post['time'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    minimumSize: const Size(0, 32),
                  ),
                  child: const Text('Ikuti', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),

          // Gambar Postingan
          SafeImage(
            imageUrl: product.image,
            width: double.infinity,
            height: 280,
            fit: BoxFit.cover,
          ),

          // Produk yang ditautkan (Shopping Mini Banner)
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderLight),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SafeImage(
                    imageUrl: product.image,
                    width: 46,
                    height: 46,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatRupiah(product.price),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailProductScreen(product: product),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    minimumSize: const Size(0, 34),
                  ),
                  child: const Text('Beli', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),

          // Interaksi (Like, Comment, Share)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border_rounded,
                    color: isLiked ? AppTheme.dangerColor : null,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isLiked) {
                        likedPosts.remove(index);
                      } else {
                        likedPosts.add(index);
                      }
                    });
                  },
                ),
                Text(
                  '$currentLikes',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.mode_comment_outlined),
                  onPressed: () {},
                ),
                Text(
                  '${post['comments']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Caption & Hashtags
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['caption'] as String,
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 6),
                Text(
                  post['tags'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

