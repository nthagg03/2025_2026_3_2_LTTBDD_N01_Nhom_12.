import '../models/friend_model.dart';

class FriendService {
  FriendService() {
    _seedFriends();
    _seedRequests();
    _seedSuggestions();
  }

  final List<FriendModel> _friends = [];
  final List<FriendRequestModel> _incomingRequests = [];
  final List<FriendRequestModel> _outgoingRequests = [];
  final List<FriendSuggestionModel> _suggestions = [];

  void _seedFriends() {
    _friends.addAll([
      FriendModel(
        id: 'f1',
        name: 'Nguyễn Minh Tân',
        avatar: 'T',
        bio: 'Yêu thích nhiếp ảnh và khám phá',
        friendsSince: DateTime.now().subtract(const Duration(days: 120)),
      ),
      FriendModel(
        id: 'f2',
        name: 'Trần Thị Nam',
        avatar: 'N',
        bio: 'Coffee lover ☕',
        friendsSince: DateTime.now().subtract(const Duration(days: 60)),
      ),
      FriendModel(
        id: 'f3',
        name: 'Lê Xuân Thắng',
        avatar: 'T',
        bio: 'Lập trình viên đam mê',
        friendsSince: DateTime.now().subtract(const Duration(days: 30)),
      ),
      FriendModel(
        id: 'f4',
        name: 'Phạm An Thuyên',
        avatar: 'A',
        bio: 'Đi khắp nơi, chụp đủ thứ',
        friendsSince: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ]);
  }

  void _seedRequests() {
    _incomingRequests.addAll([
      FriendRequestModel(
        id: 'req1',
        fromUserId: 'u10',
        fromUserName: 'Hoàng Văn Bình',
        fromUserAvatar: 'B',
        sentAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      FriendRequestModel(
        id: 'req2',
        fromUserId: 'u11',
        fromUserName: 'Ngô Thị Hà',
        fromUserAvatar: 'H',
        sentAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ]);
  }

  void _seedSuggestions() {
    _suggestions.addAll([
      FriendSuggestionModel(
        id: 's1',
        name: 'Đinh Văn Tú',
        avatar: 'T',
        mutualFriends: 3,
      ),
      FriendSuggestionModel(
        id: 's2',
        name: 'Vũ Thị Minh',
        avatar: 'M',
        mutualFriends: 2,
      ),
      FriendSuggestionModel(
        id: 's3',
        name: 'Bùi Quốc Toản',
        avatar: 'T',
        mutualFriends: 1,
      ),
    ]);
  }

  Future<List<FriendModel>> getFriends() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_friends);
  }

  Future<List<FriendRequestModel>> getIncomingRequests() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_incomingRequests);
  }

  Future<List<FriendRequestModel>> getOutgoingRequests() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_outgoingRequests);
  }

  Future<List<FriendSuggestionModel>> getSuggestions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_suggestions);
  }

  Future<void> acceptRequest(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _incomingRequests.indexWhere((r) => r.id == requestId);
    if (idx == -1) return;
    final req = _incomingRequests.removeAt(idx);
    _friends.add(FriendModel(
      id: req.fromUserId,
      name: req.fromUserName,
      avatar: req.fromUserAvatar,
      friendsSince: DateTime.now(),
    ));
  }

  Future<void> declineRequest(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _incomingRequests.removeWhere((r) => r.id == requestId);
  }

  Future<void> cancelOutgoingRequest(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _outgoingRequests.removeWhere((r) => r.id == requestId);
  }

  Future<void> removeFriend(String friendId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _friends.removeWhere((f) => f.id == friendId);
  }

  Future<void> sendFriendRequest(String suggestionId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _suggestions.indexWhere((s) => s.id == suggestionId);
    if (idx == -1) return;
    final suggestion = _suggestions[idx];
    _outgoingRequests.add(FriendRequestModel(
      id: 'out_${DateTime.now().millisecondsSinceEpoch}',
      fromUserId: suggestion.id,
      fromUserName: suggestion.name,
      fromUserAvatar: suggestion.avatar,
      sentAt: DateTime.now(),
    ));
    _suggestions.removeAt(idx);
  }
}
