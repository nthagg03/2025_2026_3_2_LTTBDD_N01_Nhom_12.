import 'dart:async';
import '../../core/services/app_sync_service.dart';

class NotificationItem {
  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.targetScreen,
    required this.isUnread,
  });

  final String id;
  final String title;
  final String body;
  final String type;
  final String targetScreen;
  bool isUnread;
}

class NotificationService {
  NotificationService({AppSyncService? syncService}) {
    _syncService = syncService ?? AppSyncService();
    _notifications.addAll(_seedNotifications());
    _controller.add(List.from(_notifications));
    _syncSubscription = _syncService!.events.listen((event) {
      if (event.type == 'heartbeat') {
        _controller.add(List.from(_notifications));
      }
    });
  }

  final List<NotificationItem> _notifications = [];
  final StreamController<List<NotificationItem>> _controller =
      StreamController<List<NotificationItem>>.broadcast();
  AppSyncService? _syncService;
  StreamSubscription? _syncSubscription;

  Stream<List<NotificationItem>> get notificationsStream => _controller.stream;

  Future<List<NotificationItem>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_notifications);
  }

  Future<void> markAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final item = _notifications.firstWhere((entry) => entry.id == id);
    item.isUnread = false;
    _controller.add(List.from(_notifications));
  }

  void dispose() {
    _syncSubscription?.cancel();
    _syncService?.dispose();
  }

  List<NotificationItem> _seedNotifications() {
    return [
      NotificationItem(
        id: 'n1',
        title: 'New friend request',
        body: 'Mai sent you a friend request.',
        type: 'friend',
        targetScreen: 'friends',
        isUnread: true,
      ),
      NotificationItem(
        id: 'n2',
        title: 'New reaction',
        body: 'An reacted to your photo.',
        type: 'reaction',
        targetScreen: 'reactions',
        isUnread: true,
      ),
      NotificationItem(
        id: 'n3',
        title: 'New photo uploaded',
        body: 'A new photo is ready to view.',
        type: 'photo',
        targetScreen: 'home_widget',
        isUnread: false,
      ),
    ];
  }
}
