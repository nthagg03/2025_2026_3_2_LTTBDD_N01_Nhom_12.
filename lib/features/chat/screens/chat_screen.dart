import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';
import '../../friends/models/friend_model.dart';
import '../../friends/services/friend_service.dart';
import 'chat_detail_screen.dart';


/// Locket-style messaging screen (Trò chuyện)
/// Gets its friend list dynamically from FriendService.instance.friends.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Sample fallback message captions per friend index to make chats feel alive
  final List<String> _sampleMessages = const [
    'Nhạc hay là lỗi của anh',
    'Thích thế 💖',
    'Chiều đi học không?',
    'Đã trả lời Locket của bạn!',
    'Vịt quay lá móc mật ngon vãi 🍗',
    'Tối đi cà phê không?',
    'Đã gửi một ảnh 📸',
    'Về tới nhà chưa?',
    'Hôm nay lướt phố vui ghê 🛵',
    'Gửi lại cho tôi tấm ảnh nãy nhé!',
  ];

  final List<String> _sampleTimes = const [
    '2g',
    '12g',
    '29 thg 7',
    '4 thg 7',
    '3 thg 7',
    '24 thg 5',
    '1 thg 5',
    '28 thg 4',
    '25 thg 3',
    '6 thg 12',
  ];

  String _getLastMessage(int index) {
    return _sampleMessages[index % _sampleMessages.length];
  }

  String _getTime(int index) {
    return _sampleTimes[index % _sampleTimes.length];
  }

  Widget _buildChatItem(FriendModel friend, int index) {

    final displayName = friend.badgeEmoji != null
        ? '${friend.name} ${friend.badgeEmoji}'
        : friend.name;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatDetailScreen(friend: friend),
            ),
          );
        },

        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            // Circle Avatar with green border ring
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF1E3A2B), width: 2.5),
                color: const Color(0xFF162D1F),
              ),
              child: Center(
                child: Text(
                  friend.avatar,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Name, Time & Last Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getTime(index),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getLastMessage(index),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white38,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomDock() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E24),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Memories Grid button
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.memories),
            icon: const Icon(
              Icons.grid_view_rounded,
              color: Colors.white60,
              size: 22,
            ),
          ),
          const SizedBox(width: 6),

          // Center Home button (Back to Camera)
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.home_rounded,
              color: Colors.white60,
              size: 22,
            ),
          ),
          const SizedBox(width: 6),

          // Highlighted Chat button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.chat_bubble_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07140B),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > 150) {
            // Swipe RIGHT on ChatScreen -> Return to CameraScreen
            Navigator.pop(context);
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // Top Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Row(
                      children: [
                        const SizedBox(width: 38),
                        const Spacer(),
                        const Text(
                          'Trò chuyện',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.profile),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white30, width: 2),
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
                  ),

                  // Dynamic Chat List from FriendService.instance.friends
                  Expanded(
                    child: AnimatedBuilder(
                      animation: FriendService.instance,
                      builder: (context, _) {
                        final friends = FriendService.instance.friends;

                        if (friends.isEmpty) {
                          return const Center(
                            child: Text(
                              'Chưa có bạn bè nào',
                              style: TextStyle(color: Colors.white54),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: friends.length,
                          itemBuilder: (context, index) {
                            return _buildChatItem(friends[index], index);
                          },
                        );
                      },
                    ),
                  ),

                  // Bottom Dock
                  _buildBottomDock(),
                  const SizedBox(height: 10),
                ],
              ),

              // Yellow FAB (pencil/edit icon) on bottom right
              Positioned(
                bottom: 24,
                right: 18,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB800),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFB800).withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      color: Colors.black,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
