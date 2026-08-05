class Post {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String imageUrl;
  final String caption;
  final DateTime timestamp;
  final int reactionCount;
  final String? userReaction;
  final List<String> reactions;

  const Post({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.imageUrl,
    required this.caption,
    required this.timestamp,
    this.reactionCount = 0,
    this.userReaction,
    this.reactions = const [],
  });

  Post copyWith({
    String? id,
    String? authorName,
    String? authorAvatar,
    String? imageUrl,
    String? caption,
    DateTime? timestamp,
    int? reactionCount,
    String? Function()? userReaction,
    List<String>? reactions,
  }) {
    return Post(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      timestamp: timestamp ?? this.timestamp,
      reactionCount: reactionCount ?? this.reactionCount,
      userReaction: userReaction != null ? userReaction() : this.userReaction,
      reactions: reactions ?? this.reactions,
    );
  }
}
