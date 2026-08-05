import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/utils/date_utils.dart';
import '../../../repositories/fake_post_repository.dart';
import '../models/feed_item_model.dart';
import '../widgets/reaction_bar.dart';

class FullPhotoScreen extends StatefulWidget {
  final FeedItemModel feedItem;

  const FullPhotoScreen({super.key, required this.feedItem});

  @override
  State<FullPhotoScreen> createState() => _FullPhotoScreenState();
}

class _FullPhotoScreenState extends State<FullPhotoScreen>
    with SingleTickerProviderStateMixin {
  late FeedItemModel _currentPost;
  bool _showHeartAnimation = false;

  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _currentPost = widget.feedItem;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_animController);

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _showHeartAnimation = false);
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleReaction(String emoji) async {
    final updated =
        await FakePostRepository().toggleReaction(_currentPost.id, emoji);
    if (updated != null && mounted) {
      setState(() {
        _currentPost = updated;
      });
    }
  }

  void _triggerDoubleTapLike() {
    setState(() => _showHeartAnimation = true);
    _animController.forward(from: 0.0);
    _handleReaction('❤️');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0) > 200) {
            Navigator.pop(context);
          }
        },
        child: Stack(
          children: [
            // Photo View with Double-Tap Support
            Center(
              child: GestureDetector(
                onDoubleTap: _triggerDoubleTapLike,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildImageWidget(_currentPost.imageUrl),
                    if (_showHeartAnimation)
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Color(0xFFFFB800),
                          size: 110,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Top Header Bar
            SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFF7F77DD),
                      child: Text(
                        _currentPost.authorAvatar,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentPost.authorName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          AppDateUtils.formatTimestamp(_currentPost.timestamp),
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Caption & Reaction Bar Overlay
            Positioned(
              left: 16,
              right: 16,
              bottom: 32,
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_currentPost.caption.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Text(
                          _currentPost.caption,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Interactive Reaction Picker
                    ReactionBar(
                      activeReaction: _currentPost.userReaction,
                      onReactionSelected: _handleReaction,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(String path) {
    if (path.startsWith('/') || path.contains(':\\') || path.contains(':/')) {
      return Image.file(
        File(path),
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _buildImageError(),
      );
    }
    return Image.asset(
      path,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _buildImageError(),
    );
  }

  Widget _buildImageError() {
    return Container(
      height: 380,
      color: const Color(0xFF13132A),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_rounded,
          color: Colors.white38,
          size: 48,
        ),
      ),
    );
  }
}
