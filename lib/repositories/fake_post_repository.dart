import '../models/post.dart';

class FakePostRepository {
  static final FakePostRepository _instance = FakePostRepository._internal();
  factory FakePostRepository() => _instance;
  FakePostRepository._internal();

  final List<Post> _posts = [
    Post(
      id: 'post_1',
      authorName: 'Tân',
      authorAvatar: 'T',
      imageUrl: 'lib/assets/imgs/testimg.jpg',
      caption: 'Một ngày hè nắng đẹp tại bãi biển 🏖️',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      reactionCount: 5,
      reactions: ['❤️', '🔥'],
    ),
    Post(
      id: 'post_2',
      authorName: 'Nam',
      authorAvatar: 'N',
      imageUrl: 'lib/assets/imgs/testimg.jpg',
      caption: 'Thưởng thức cà phê sáng cùng anh em ☕',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      reactionCount: 12,
      reactions: ['😍', '🔥', '👍'],
    ),
    Post(
      id: 'post_3',
      authorName: 'Thắng',
      authorAvatar: 'T',
      imageUrl: 'lib/assets/imgs/testimg.jpg',
      caption: 'Hoàng hôn rực rỡ chiều nay ✨',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      reactionCount: 8,
      reactions: ['❤️', '😮'],
    ),
    Post(
      id: 'post_4',
      authorName: 'An Thuyên',
      authorAvatar: 'A',
      imageUrl: 'lib/assets/imgs/testimg.jpg',
      caption: 'Check-in góc làm việc mới 🚀',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      reactionCount: 19,
      reactions: ['🔥', '👍'],
    ),
  ];

  Future<List<Post>> getPosts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<Post>.from(_posts);
  }

  Future<Post?> toggleReaction(String postId, String emoji) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return null;

    final post = _posts[index];
    final isSameReaction = post.userReaction == emoji;

    String? newUserReaction;
    int newCount = post.reactionCount;

    if (isSameReaction) {
      newUserReaction = null;
      newCount = (newCount > 0) ? newCount - 1 : 0;
    } else {
      if (post.userReaction == null) {
        newCount += 1;
      }
      newUserReaction = emoji;
    }

    final updated = post.copyWith(
      userReaction: () => newUserReaction,
      reactionCount: newCount,
    );

    _posts[index] = updated;
    return updated;
  }

  Future<void> addPost(Post post) async {
    _posts.insert(0, post);
  }
}
