import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/utils/date_utils.dart';
import '../models/feed_item_model.dart';
import '../services/feed_service.dart';
import '../widgets/reaction_bar.dart';
import 'full_photo_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final FeedService _feedService = FeedService();
  List<FeedItemModel> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  Future<void> _loadFeed() async {
    setState(() => _isLoading = true);
    final items = await _feedService.getFeedItems();
    if (!mounted) return;
    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  Future<void> _handleReaction(String postId, String emoji) async {
    final updated = await _feedService.toggleReaction(postId, emoji);
    if (updated != null && mounted) {
      setState(() {
        final index = _items.indexWhere((p) => p.id == postId);
        if (index != -1) {
          _items[index] = updated;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A14),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bảng tin khoảnh khắc',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFB800)),
            )
          : RefreshIndicator(
              color: const Color(0xFFFFB800),
              backgroundColor: const Color(0xFF13132A),
              onRefresh: _loadFeed,
              child: _items.isEmpty
                  ? const Center(
                      child: Text(
                        'Chưa có bài viết nào',
                        style: TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return _buildFeedCard(item);
                      },
                    ),
            ),
    );
  }

  Widget _buildFeedCard(FeedItemModel item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF13132A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2A2A44)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF7F77DD),
                  child: Text(
                    item.authorAvatar,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.authorName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        AppDateUtils.formatTimestamp(item.timestamp),
                        style: const TextStyle(
                          color: Color(0x99FFFFFF),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Photo Preview Container
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FullPhotoScreen(feedItem: item),
                ),
              );
              _loadFeed();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF0A0A14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildImageWidget(item.imageUrl),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.fullscreen_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Xem ảnh',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Caption & Reaction Footer
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.caption.isNotEmpty) ...[
                  Text(
                    item.caption,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E38),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.favorite_rounded,
                            color: Color(0xFFFFB800),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${item.reactionCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    ReactionBar(
                      activeReaction: item.userReaction,
                      onReactionSelected: (emoji) =>
                          _handleReaction(item.id, emoji),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget(String path) {
    if (path.startsWith('/') || path.contains(':\\') || path.contains(':/')) {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildImageError(),
      );
    }
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildImageError(),
    );
  }

  Widget _buildImageError() {
    return Container(
      color: const Color(0xFF1C1C2E),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_rounded,
          color: Colors.white38,
          size: 40,
        ),
      ),
    );
  }
}
