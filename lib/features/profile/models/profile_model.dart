class ProfileModel {
  final String name;
  final String username;
  final String avatar;
  final String bio;
  final int friendCount;
  final int postCount;
  final int streakDays;
  final DateTime joinedAt;

  const ProfileModel({
    required this.name,
    required this.username,
    required this.avatar,
    required this.bio,
    required this.friendCount,
    required this.postCount,
    required this.streakDays,
    required this.joinedAt,
  });

  ProfileModel copyWith({
    String? name,
    String? username,
    String? avatar,
    String? bio,
    int? friendCount,
    int? postCount,
    int? streakDays,
    DateTime? joinedAt,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      friendCount: friendCount ?? this.friendCount,
      postCount: postCount ?? this.postCount,
      streakDays: streakDays ?? this.streakDays,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
