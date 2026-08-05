import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../routes/app_routes.dart';
import '../models/history_photo.dart';
import '../services/history_service.dart';

class HistoryFeedScreen extends StatefulWidget {
  const HistoryFeedScreen({super.key});

  @override
  State<HistoryFeedScreen> createState() => _HistoryFeedScreenState();
}

class _HistoryFeedScreenState extends State<HistoryFeedScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _msgCtrl = TextEditingController();

  String _selectedFilter = 'Mọi người';
  final List<String> _quickEmojis = const ['💛', '💕', '🤣'];

  @override
  void initState() {
    super.initState();
    HistoryService.instance.addListener(_onHistoryChanged);
  }

  @override
  void dispose() {
    HistoryService.instance.removeListener(_onHistoryChanged);
    _pageController.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  void _onHistoryChanged() {
    if (mounted) setState(() {});
  }

  void _sendReaction(String emoji) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã gửi phản hồi $emoji!'),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF1E3A2B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Row(
        children: [
          // Announcement icon
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFF162B1E),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.campaign_outlined,
                color: Colors.white70,
                size: 20,
              ),
            ),
          ),

          const Spacer(),

          // Filter pill button ("Mọi người ⌄")
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter =
                    _selectedFilter == 'Mọi người' ? 'Bạn bè' : 'Mọi người';
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF162B1E),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedFilter,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white70,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Profile Avatar
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white30, width: 2),
                color: const Color(0xFF1E3A2B),
              ),
              child: const ClipOval(
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSinglePost(HistoryPhoto photo) {
    final path = photo.imagePath;
    Widget imgWidget;

    if (path.startsWith('lib/') || path.startsWith('assets/')) {
      imgWidget = Image.asset(path, fit: BoxFit.cover);
    } else if (File(path).existsSync()) {
      imgWidget = Image.file(File(path), fit: BoxFit.cover);
    } else {
      imgWidget = Container(
        color: const Color(0xFF1B3828),
        child: const Center(
          child: Icon(Icons.photo_rounded, color: Colors.white38, size: 48),
        ),
      );
    }

    final authorName = photo.isMine
        ? 'Bạn'
        : (photo.recipients.isNotEmpty ? photo.recipients.first : 'Bạn bè');
    final avatarLetter = authorName.substring(0, 1).toUpperCase();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Photo Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AspectRatio(
            aspectRatio: 1.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  imgWidget,

                  // Caption or Location overlay at bottom of photo
                  if (photo.caption.isNotEmpty)
                    Positioned(
                      bottom: 14,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            photo.caption,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // User Info (Avatar + Name + Time)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF2E4D3B),
              ),
              child: Center(
                child: Text(
                  avatarLetter,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              authorName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${photo.createdAt.day}/${photo.createdAt.month}',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInteractionRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF162B1E),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _msgCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Tin nhắn...',
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),

            ..._quickEmojis.map(
              (emoji) => GestureDetector(
                onTap: () => _sendReaction(emoji),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),

            GestureDetector(
              onTap: () => _sendReaction('❤️'),
              child: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.add_reaction_outlined,
                  color: Colors.white70,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomDock() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E24),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grid view button
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.memories),
            icon: const Icon(
              Icons.grid_view_rounded,
              color: Colors.white60,
              size: 22,
            ),
          ),

          const SizedBox(width: 4),

          // Center Shutter Button (Back to camera)
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFFB800),
                  width: 3.5,
                ),
              ),
              child: Center(
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 4),

          // Chat icon
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.feed),
            icon: const Icon(
              Icons.chat_bubble_rounded,
              color: Colors.white60,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Reverse photos so latest post is at the top of vertical feed!
    final photos = HistoryService.instance.photos.reversed.toList();

    return Scaffold(
      backgroundColor: const Color(0xFF07140B),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > 150) {
            // Swipe DOWN on top of screen -> return to CameraScreen
            Navigator.pop(context);
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),

              // Vertical PageView for posts
              Expanded(
                child: photos.isEmpty
                    ? const Center(
                        child: Text(
                          'Chưa có bài đăng nào trong lịch sử',
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                    : PageView.builder(
                        controller: _pageController,
                        scrollDirection: Axis.vertical,
                        itemCount: photos.length,
                        itemBuilder: (context, index) {
                          return _buildSinglePost(photos[index]);
                        },
                      ),
              ),

              _buildInteractionRow(),
              const SizedBox(height: 6),
              _buildBottomDock(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

