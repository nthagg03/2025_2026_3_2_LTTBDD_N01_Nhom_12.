import 'package:flutter_test/flutter_test.dart';
import 'package:locket/features/feed/services/feed_service.dart';
import 'package:locket/models/post.dart';
import 'package:locket/repositories/fake_post_repository.dart';

void main() {
  group('FakePostRepository & FeedService', () {
    final repo = FakePostRepository();
    final feedService = FeedService();

    test('getFeedItems returns initial mock posts', () async {
      final posts = await feedService.getFeedItems();
      expect(posts.length, greaterThanOrEqualTo(4));
      expect(posts.first.authorName, isNotEmpty);
    });

    test('toggleReaction adds and removes reaction', () async {
      final posts = await feedService.getFeedItems();
      final targetPost = posts.first;
      final initialCount = targetPost.reactionCount;

      // Add reaction
      final updated = await feedService.toggleReaction(targetPost.id, '❤️');
      expect(updated, isNotNull);
      expect(updated?.userReaction, equals('❤️'));
      expect(updated?.reactionCount, equals(initialCount + 1));

      // Remove reaction by tapping same emoji
      final reset = await feedService.toggleReaction(targetPost.id, '❤️');
      expect(reset, isNotNull);
      expect(reset?.userReaction, isNull);
      expect(reset?.reactionCount, equals(initialCount));
    });

    test('addPost prepends new post to feed', () async {
      final newPost = Post(
        id: 'new_post_999',
        authorName: 'Test Author',
        authorAvatar: 'TA',
        imageUrl: 'lib/assets/imgs/testimg.jpg',
        caption: 'New test post caption',
        timestamp: DateTime.now(),
      );

      await feedService.addPost(newPost);
      final posts = await feedService.getFeedItems();

      expect(posts.first.id, equals('new_post_999'));
      expect(posts.first.caption, equals('New test post caption'));
    });
  });
}
