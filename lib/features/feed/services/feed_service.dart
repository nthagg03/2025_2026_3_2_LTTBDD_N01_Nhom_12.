import '../models/feed_item_model.dart';

class FeedService {
  static final List<FeedItemModel> _mockFeedItems = [
    FeedItemModel(
      id: 'feed_1',
      authorName: 'Tân',
      authorAvatar: 'T',
      imageUrl: 'lib/assets/imgs/testimg.jpg',
      caption: 'Một ngày hè nắng đẹp tại bãi biển 🏖️',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      reactionCount: 5,
    ),
    FeedItemModel(
      id: 'feed_2',
      authorName: 'Nam',
      authorAvatar: 'N',
      imageUrl: 'lib/assets/imgs/testimg.jpg',
      caption: 'Thưởng thức cà phê sáng cùng anh em ☕',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      reactionCount: 12,
    ),
    FeedItemModel(
      id: 'feed_3',
      authorName: 'Thắng',
      authorAvatar: 'T',
      imageUrl: 'lib/assets/imgs/testimg.jpg',
      caption: 'Hoàng hôn rực rỡ chiều nay ✨',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      reactionCount: 8,
    ),
    FeedItemModel(
      id: 'feed_4',
      authorName: 'An Thuyên',
      authorAvatar: 'A',
      imageUrl: 'lib/assets/imgs/testimg.jpg',
      caption: 'Check-in góc làm việc mới 🚀',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      reactionCount: 19,
    ),
  ];

  Future<List<FeedItemModel>> getFeedItems() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.from(_mockFeedItems);
  }
}
