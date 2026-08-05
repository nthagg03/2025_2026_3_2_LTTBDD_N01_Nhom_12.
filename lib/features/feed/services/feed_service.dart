import '../../../repositories/fake_post_repository.dart';
import '../models/feed_item_model.dart';

class FeedService {
  final FakePostRepository _repository = FakePostRepository();

  Future<List<FeedItemModel>> getFeedItems() {
    return _repository.getPosts();
  }

  Future<FeedItemModel?> toggleReaction(String postId, String emoji) {
    return _repository.toggleReaction(postId, emoji);
  }

  Future<void> addPost(FeedItemModel post) {
    return _repository.addPost(post);
  }
}
