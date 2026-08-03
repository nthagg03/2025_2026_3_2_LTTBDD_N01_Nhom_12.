class FeedItemModel {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String imageUrl;
  final String caption;
  final DateTime timestamp;
  final int reactionCount;

  const FeedItemModel({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.imageUrl,
    required this.caption,
    required this.timestamp,
    this.reactionCount = 0,
  });
}
