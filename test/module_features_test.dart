import 'package:flutter_test/flutter_test.dart';
import 'package:locket/features/chat/chat_service.dart';
import 'package:locket/features/reactions/reaction_service.dart';

void main() {
  group('ReactionService', () {
    test('returns counts and current user reaction', () async {
      final service = ReactionService(initialReactions: []);

      await service.addOrUpdateReaction('image_01', '😍', 'Bạn');
      await service.addOrUpdateReaction('image_01', '🔥', 'An');

      final summary = await service.getReactionSummary('image_01', 'Bạn');

      expect(summary.totalCount, 2);
      expect(summary.currentUserReaction, '😍');
      expect(summary.userNames, contains('Bạn'));
      expect(summary.emojiCounts['😍'], 1);
    });

    test('removeReaction removes the current user reaction', () async {
      final service = ReactionService(initialReactions: []);

      await service.addOrUpdateReaction('image_01', '😍', 'Bạn');
      await service.removeReaction('image_01', 'Bạn');

      final summary = await service.getReactionSummary('image_01', 'Bạn');

      expect(summary.totalCount, 0);
      expect(summary.currentUserReaction, null);
    });
  });

  group('ChatService', () {
    test('sends a message and keeps the newest conversation first', () async {
      final service = ChatService(
        initialConversations: [
          ChatConversation(
            id: 'chat_1',
            contactName: 'Mai',
            lastMessage: 'Old message',
            unreadCount: 0,
            updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
            messages: const [],
          ),
        ],
      );

      await service.sendMessage(
        'chat_1',
        'Bạn',
        'Hello from test',
        isReplyToPhoto: false,
      );

      final messages = await service.getMessages('chat_1');
      final conversations = await service.getConversations();

      expect(messages.last.text, 'Hello from test');
      expect(conversations.first.id, 'chat_1');
    });
  });
}
