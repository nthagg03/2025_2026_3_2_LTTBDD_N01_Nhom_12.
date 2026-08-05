import 'package:flutter/material.dart';

import '../models/friend_model.dart';
import '../services/friend_service.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  bool _isExpanded = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onAddFromSearch() {
    final text = _searchQuery.trim();
    if (text.isEmpty) return;
    FriendService.instance.addFriendByName(text);
    _searchCtrl.clear();
    setState(() => _searchQuery = '');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã kết bạn với "$text" 💛'),
        backgroundColor: const Color(0xFFFFC107),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! > 150) {
            Navigator.pop(context);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(top: 48),
          decoration: const BoxDecoration(
            color: Color(0xFF141416),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: AnimatedBuilder(
              animation: FriendService.instance,
              builder: (context, _) {
                final allFriends = FriendService.instance.friends;
                final allSuggestions = FriendService.instance.suggestions;

                final filteredFriends = allFriends.where((f) {
                  return f.name
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase());
                }).toList();

                final filteredSuggestions = allSuggestions.where((s) {
                  return s.name
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase());
                }).toList();

                final displayedFriends =
                    (_isExpanded || _searchQuery.isNotEmpty)
                        ? filteredFriends
                        : filteredFriends.take(3).toList();

                return Column(
                  children: [
                    // Top drag handle bar (Tap or drag down to close)
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.circular(2.5),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Top Header (Count + Subtitle)
                    GestureDetector(
                      onVerticalDragEnd: (details) {
                        if (details.primaryVelocity != null &&
                            details.primaryVelocity! > 100) {
                          Navigator.pop(context);
                        }
                      },
                      child: Column(
                        children: [
                          Text(
                            '${allFriends.length} / 20 người bạn',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Thêm các bạn thân của bạn',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF242426),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (val) =>
                              setState(() => _searchQuery = val),
                          onSubmitted: (_) => _onAddFromSearch(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 15),
                          decoration: InputDecoration(
                            hintText: 'Thêm một người bạn mới',
                            hintStyle: const TextStyle(
                                color: Colors.white38, fontSize: 14),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: Colors.white60,
                              size: 22,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                        Icons.add_circle_rounded,
                                        color: Color(0xFFFFC107)),
                                    onPressed: _onAddFromSearch,
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Main Scroll View
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollInfo) {
                          if (scrollInfo is OverscrollNotification &&
                              scrollInfo.overscroll < -10) {
                            Navigator.pop(context);
                            return true;
                          }
                          return false;
                        },
                        child: ListView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          children: [

                      // Section 1: Bạn bè của bạn
                      if (filteredFriends.isNotEmpty) ...[
                        Row(
                          children: const [
                            Icon(Icons.groups_rounded, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Bạn bè của bạn',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        ...displayedFriends.map((friend) => _buildFriendItem(friend)),

                        // "Xem thêm" / "Thu gọn" button
                        if (filteredFriends.length > 3 && _searchQuery.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                const Expanded(child: Divider(color: Colors.white12, thickness: 1)),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF242426),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _isExpanded ? 'Thu gọn' : 'Xem thêm',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(child: Divider(color: Colors.white12, thickness: 1)),
                              ],
                            ),
                          ),

                        const SizedBox(height: 24),
                      ],

                      // Section 2: Các đề xuất
                      if (filteredSuggestions.isNotEmpty) ...[
                        Row(
                          children: const [
                            Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Các đề xuất',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        ...filteredSuggestions.map((sug) => _buildSuggestionItem(sug)),
                      ],

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  ),
),
);
}




  Widget _buildFriendItem(FriendModel friend) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Yellow ring Avatar
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFFC107), width: 2),
                ),
                child: CircleAvatar(
                  backgroundColor: const Color(0xFF2C2C2E),
                  child: Text(
                    friend.avatar,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              if (friend.badgeEmoji != null)
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      friend.badgeEmoji!,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // Friend Name
          Expanded(
            child: Text(
              friend.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Remove Friend 'X'
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white60, size: 20),
            onPressed: () {
              FriendService.instance.removeFriend(friend.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã hủy kết bạn với ${friend.name}'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(FriendSuggestionModel sug) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          // Dark circle Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF2A2A2E),
            child: Text(
              sug.avatar,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Name + Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sug.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sug.subtitle,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Yellow "+ Thêm" button
          GestureDetector(
            onTap: () {
              FriendService.instance.addFriendFromSuggestion(sug);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã thêm ${sug.name} vào danh sách bạn bè 💛'),
                  backgroundColor: const Color(0xFFFFC107),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC107),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '+ Thêm',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

