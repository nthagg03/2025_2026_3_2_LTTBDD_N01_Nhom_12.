import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  AppSyncService? _syncService;
  StreamSubscription? _syncSubscription;
  String? _fcmToken;

  Stream<List<NotificationItem>> get notificationsStream => _controller.stream;
  String? get fcmToken => _fcmToken;

  Future<void> initialize() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        return;
      }

      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const darwinSettings = DarwinInitializationSettings();
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      );
      await _localNotifications.initialize(initSettings);
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.onMessage.listen((message) {
        if (message.notification != null) {
          unawaited(showLocalNotification(message));
        }
      });

      final token = await _messaging.getToken();
      if (token != null) {
        await saveToken(token);
      }
      _messaging.onTokenRefresh.listen(saveToken);
    } catch (error) {
      debugPrint('Notification initialization failed: $error');
    }
  }

  Future<void> saveToken(String token) async {
    _fcmToken = token;
    debugPrint('FCM token saved: $token');
  }

  Future<void> showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'locket_channel',
      'Locket',
      channelDescription: 'Locket notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const darwinDetails = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification?.title ?? 'New notification',
      message.notification?.body ?? 'You have a new update.',
      notificationDetails,
    );
  }

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
