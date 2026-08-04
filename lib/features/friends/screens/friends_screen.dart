import 'package:flutter/material.dart';

import '../models/friend_model.dart';
import '../services/friend_service.dart';
import '../widgets/person_list_tile.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  final FriendService _service = FriendService();
  late TabController _tabController;

  List<FriendModel> _friends = [];
  List<FriendRequestModel> _requests = [];
  List<FriendSuggestionModel> _suggestions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);
    final results = await Future.wait([
      _service.getFriends(),
      _service.getIncomingRequests(),
      _service.getSuggestions(),
    ]);
    if (!mounted) return;
    setState(() {
      _friends = results[0] as List<FriendModel>;
      _requests = results[1] as List<FriendRequestModel>;
      _suggestions = results[2] as List<FriendSuggestionModel>;
      _isLoading = false;
    });
  }

  void _showRemoveDialog(FriendModel friend) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF13132A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person_remove_rounded,
                    color: Colors.redAccent),
                title: const Text(
                  'Hủy kết bạn',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  final messenger = ScaffoldMessenger.of(context);
                  await _service.removeFriend(friend.id);
                  if (!mounted) return;
                  await _loadAll();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Đã hủy kết bạn với ${friend.name}'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.close_rounded, color: Colors.white54),
                title: const Text(
                  'Đóng',
                  style: TextStyle(color: Colors.white54),
                ),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Color(0x99FFFFFF), fontSize: 15),
      ),
    );
  }

  Widget _buildFriendsTab() {
    if (_friends.isEmpty) {
      return _buildEmpty('Chưa có bạn bè nào');
    }
    return RefreshIndicator(
      color: const Color(0xFFFFB800),
      backgroundColor: const Color(0xFF13132A),
      onRefresh: _loadAll,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _friends.length,
        separatorBuilder: (_, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final friend = _friends[index];
          return PersonListTile.fromFriend(
            friend: friend,
            trailing: IconButton(
              icon: const Icon(Icons.more_horiz_rounded,
                  color: Colors.white54),
              onPressed: () => _showRemoveDialog(friend),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRequestsTab() {
    if (_requests.isEmpty) {
      return _buildEmpty('Chưa có lời mời kết bạn nào');
    }
    return RefreshIndicator(
      color: const Color(0xFFFFB800),
      backgroundColor: const Color(0xFF13132A),
      onRefresh: _loadAll,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _requests.length,
        separatorBuilder: (_, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final req = _requests[index];
          return PersonListTile(
            name: req.fromUserName,
            avatar: req.fromUserAvatar,
            subtitle: 'Đã gửi lời mời',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Accept
                GestureDetector(
                  onTap: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await _service.acceptRequest(req.id);
                    if (!mounted) return;
                    await _loadAll();
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                            'Đã chấp nhận lời mời của ${req.fromUserName}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFB800),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: Colors.black, size: 20),
                  ),
                ),
                const SizedBox(width: 8),
                // Decline
                GestureDetector(
                  onTap: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await _service.declineRequest(req.id);
                    if (!mounted) return;
                    await _loadAll();
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Đã từ chối lời mời'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF2A2A44)),
                    ),
                    child: const Icon(Icons.close_rounded,
                        color: Colors.white54, size: 20),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuggestionsTab() {
    if (_suggestions.isEmpty) {
      return _buildEmpty('Không có gợi ý nào');
    }
    return RefreshIndicator(
      color: const Color(0xFFFFB800),
      backgroundColor: const Color(0xFF13132A),
      onRefresh: _loadAll,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _suggestions.length,
        separatorBuilder: (_, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final suggestion = _suggestions[index];
          return PersonListTile(
            name: suggestion.name,
            avatar: suggestion.avatar,
            subtitle: '${suggestion.mutualFriends} bạn chung',
            trailing: suggestion.requestSent
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A44),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Đã gửi',
                      style: TextStyle(color: Colors.white38, fontSize: 13),
                    ),
                  )
                : GestureDetector(
                    onTap: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      await _service.sendFriendRequest(suggestion.id);
                      if (!mounted) return;
                      await _loadAll();
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                              'Đã gửi lời mời đến ${suggestion.name}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB800),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Kết bạn',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A14),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bạn bè',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFFFB800),
          unselectedLabelColor: Colors.white54,
          indicatorColor: const Color(0xFFFFB800),
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Tab(text: 'Bạn bè (${_friends.length})'),
            Tab(text: 'Lời mời (${_requests.length})'),
            const Tab(text: 'Gợi ý'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFB800)),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildFriendsTab(),
                _buildRequestsTab(),
                _buildSuggestionsTab(),
              ],
            ),
    );
  }
}
