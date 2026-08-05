class FriendModel {
  final String id;
  final String name;
  final String avatar;
  final String? badgeEmoji;
  final String? bio;
  final DateTime friendsSince;

  const FriendModel({
    required this.id,
    required this.name,
    required this.avatar,
    this.badgeEmoji,
    this.bio,
    required this.friendsSince,
  });
}

class FriendRequestModel {
  final String id;
  final String fromUserId;
  final String fromUserName;
  final String fromUserAvatar;
  final DateTime sentAt;

  const FriendRequestModel({
    required this.id,
    required this.fromUserId,
    required this.fromUserName,
    required this.fromUserAvatar,
    required this.sentAt,
  });
}

class FriendSuggestionModel {
  final String id;
  final String name;
  final String avatar;
  final String subtitle;
  final int mutualFriends;
  bool requestSent;

  FriendSuggestionModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.subtitle,
    required this.mutualFriends,
    this.requestSent = false,
  });
}

