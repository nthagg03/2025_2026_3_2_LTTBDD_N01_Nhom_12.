import 'package:flutter_test/flutter_test.dart';
import 'package:locket/features/chat/chat_service.dart';
import 'package:locket/repositories/fake_chat_repository.dart';

void main() {
  group('FakeChatRepository & ChatService', () {
    final repo = FakeChatRepository();
    final service = repo.service;

    test('getConversations returns initial conversations list', () async {
      final conversations = await repo.getConversations();
      expect(conversations, isNotEmpty);
      expect(conversations.first.contactName, isNotEmpty);
    });

    test('sendMessage appends new message to conversation', () async {
      final conversations = await repo.getConversations();
      final targetId = conversations.first.id;
      final initialMessageCount = (await repo.getMessages(targetId)).length;

      await repo.sendMessage(
        targetId,
        'Bạn',
        'Test automated message',
      );

      final updatedMessages = await repo.getMessages(targetId);
      expect(updatedMessages.length, equals(initialMessageCount + 1));
      expect(updatedMessages.last.text, equals('Test automated message'));
    });

    test('markAsRead clears unread count', () async {
      final conversations = await repo.getConversations();
      final target = conversations.firstWhere((c) => c.unreadCount > 0, orElse: () => conversations.first);

      await repo.markAsRead(target.id);
      final refreshed = await repo.getConversations();
      final updatedTarget = refreshed.firstWhere((c) => c.id == target.id);

      expect(updatedTarget.unreadCount, equals(0));
    });
  });
}
