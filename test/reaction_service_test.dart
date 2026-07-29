import 'package:flutter_test/flutter_test.dart';
import 'package:locket/features/reactions/reaction_service.dart';

void main() {
  test(
    'updating a reaction replaces the old one for the same user and image',
    () async {
      final service = ReactionService(
        initialReactions: [
          ReactionItem(userName: 'Bạn', emoji: '😍', imageId: 'image_01'),
        ],
      );

      await service.addOrUpdateReaction('image_01', '🔥', 'Bạn');

      final summary = await service.getReactionSummary('image_01', 'Bạn');
      expect(summary.totalCount, 1);
      expect(summary.currentUserReaction, '🔥');
      expect(summary.emojiCounts['🔥'], 1);
      expect(summary.emojiCounts['😍'], isNull);
    },
  );

  test(
    'watchImageSummary emits refreshed data after reactions change',
    () async {
      final service = ReactionService(initialReactions: []);

      final firstSummary = await service
          .watchImageSummary('image_01', 'Bạn')
          .first;
      expect(firstSummary.totalCount, 0);

      await service.addOrUpdateReaction('image_01', '👏', 'Mai');

      final updatedSummary = await service
          .watchImageSummary('image_01', 'Bạn')
          .skip(1)
          .first;

      expect(updatedSummary.totalCount, 1);
      expect(updatedSummary.emojiCounts['👏'], 1);
      expect(updatedSummary.userEntries.first.userName, 'Mai');
    },
  );
}
