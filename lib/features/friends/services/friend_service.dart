import 'package:flutter/foundation.dart';
import '../models/friend_model.dart';

class FriendService extends ChangeNotifier {
  static final FriendService instance = FriendService._internal();
  factory FriendService() => instance;

  FriendService._internal() {
    _seedFriends();
    _seedSuggestions();
  }

  final List<FriendModel> _friends = [];
  final List<FriendSuggestionModel> _suggestions = [];

  List<FriendModel> get friends => List.unmodifiable(_friends);
  List<FriendSuggestionModel> get suggestions => List.unmodifiable(_suggestions);
  int get friendCount => _friends.length;

  void _seedFriends() {
    _friends.addAll([
      FriendModel(
        id: 'f1',
        name: 'Wxrdie 👹',
        avatar: 'W',
        badgeEmoji: '👹',
        friendsSince: DateTime.now(),
      ),
      FriendModel(
        id: 'f4',
        name: 'VuPhuong',
        avatar: 'V',
        friendsSince: DateTime.now(),
      ),
      FriendModel(
        id: 'f6',
        name: 'Nam',
        avatar: 'N',
        friendsSince: DateTime.now(),
      ),
      FriendModel(
        id: 'f7',
        name: 'MCK 🎤',
        avatar: 'M',
        badgeEmoji: '🎤',
        friendsSince: DateTime.now(),
      ),
      FriendModel(
        id: 'f8',
        name: 'TLinh 👑',
        avatar: 'T',
        badgeEmoji: '👑',
        friendsSince: DateTime.now(),
      ),
      ...List.generate(
        15,
        (index) => FriendModel(
          id: 'f_extra_$index',
          name: 'Bạn Locket ${index + 1}',
          avatar: '${index + 1}',
          friendsSince: DateTime.now(),
        ),
      ),
    ]);
  }

  void _seedSuggestions() {
    _suggestions.addAll([
      FriendSuggestionModel(
        id: 's1',
        name: 'Ộbitô',
        avatar: 'Ô',
        subtitle: '2+ người bạn chung ✨',
        mutualFriends: 2,
      ),
      FriendSuggestionModel(
        id: 's2',
        name: 'stevejobVN',
        avatar: 'ST',
        subtitle: '2+ người bạn chung ✨',
        mutualFriends: 2,
      ),
      FriendSuggestionModel(
        id: 's3',
        name: 'Bảnh',
        avatar: 'KB',
        subtitle: 'Đã có trên Locket 💛',
        mutualFriends: 0,
      ),
      FriendSuggestionModel(
        id: 's4',
        name: 'Phong Ly',
        avatar: 'PL',
        subtitle: 'Đã có trên Locket 💛',
        mutualFriends: 0,
      ),
    ]);
  }

  Future<List<FriendModel>> getFriends() async {
    return List.from(_friends);
  }

  Future<List<FriendSuggestionModel>> getSuggestions() async {
    return List.from(_suggestions);
  }

  void addFriendFromSuggestion(FriendSuggestionModel suggestion) {
    _suggestions.removeWhere((s) => s.id == suggestion.id);
    _friends.insert(
      0,
      FriendModel(
        id: 'f_${suggestion.id}',
        name: suggestion.name,
        avatar: suggestion.avatar,
        friendsSince: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void addFriendByName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    _friends.insert(
      0,
      FriendModel(
        id: 'f_custom_${DateTime.now().millisecondsSinceEpoch}',
        name: trimmed,
        avatar: trimmed[0].toUpperCase(),
        friendsSince: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void removeFriend(String friendId) {
    _friends.removeWhere((f) => f.id == friendId);
    notifyListeners();
  }
}

