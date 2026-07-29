import 'dart:async';
import 'package:flutter/material.dart';
import 'notification_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationService _service = NotificationService();
  late Future<List<NotificationItem>> _futureNotifications;

  @override
  void initState() {
    super.initState();
    _futureNotifications = _service.getNotifications();
    unawaited(_service.initialize());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: FutureBuilder<List<NotificationItem>>(
        future: _futureNotifications,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                color: item.isUnread ? Colors.blue.shade50 : null,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(item.type[0].toUpperCase()),
                  ),
                  title: Text(item.title),
                  subtitle: Text(item.body),
                  trailing: item.isUnread
                      ? const Icon(
                          Icons.fiber_manual_record,
                          color: Colors.blue,
                          size: 12,
                        )
                      : const Icon(Icons.chevron_right),
                  onTap: () async {
                    if (item.isUnread) {
                      await _service.markAsRead(item.id);
                      if (!mounted) return;
                      setState(() {
                        _futureNotifications = _service.getNotifications();
                      });
                    }

                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Open ${item.targetScreen}')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
