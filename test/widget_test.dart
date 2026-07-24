// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:locket/core/services/app_sync_service.dart';
import 'package:locket/features/chat/chat_service.dart';
import 'package:locket/features/notifications/notification_service.dart';
import 'package:locket/main.dart';

void main() {
  testWidgets('app shows module list', (WidgetTester tester) async {
    await tester.pumpWidget(const LocketApp());

    expect(find.text('Module skeleton'), findsOneWidget);
    expect(find.text('Reactions'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);
  });

  test('notification can be marked as read', () async {
    final service = NotificationService();
    final notifications = await service.getNotifications();
    final unreadItem = notifications.firstWhere((item) => item.isUnread);

    await service.markAsRead(unreadItem.id);
    final updated = await service.getNotifications();
    final item = updated.firstWhere((entry) => entry.id == unreadItem.id);

    expect(item.isUnread, isFalse);
  });

  test('chat unread count can be reset after opening conversation', () async {
    final service = ChatService();
    final conversations = await service.getConversations();
    final conversation = conversations.firstWhere(
      (item) => item.unreadCount > 0,
    );

    await service.markConversationAsRead(conversation.id);
    final updated = await service.getConversations();
    final refreshed = updated.firstWhere((item) => item.id == conversation.id);

    expect(refreshed.unreadCount, 0);
  });

  test('sync service emits heartbeat events', () async {
    final service = AppSyncService();
    final event = await service.events.first;

    expect(event.type, 'heartbeat');
    service.dispose();
  });
}
