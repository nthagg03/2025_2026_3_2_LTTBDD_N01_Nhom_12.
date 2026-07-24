import 'dart:async';

class AppSyncService {
  AppSyncService() {
    _ticker = Timer.periodic(const Duration(seconds: 4), (_) {
      _eventController.add(
        AppSyncEvent(
          type: 'heartbeat',
          payload: {'ts': DateTime.now().toIso8601String()},
        ),
      );
    });
  }

  late final Timer _ticker;
  final StreamController<AppSyncEvent> _eventController =
      StreamController<AppSyncEvent>.broadcast();

  Stream<AppSyncEvent> get events => _eventController.stream;

  void dispose() {
    _ticker.cancel();
    _eventController.close();
  }
}

class AppSyncEvent {
  AppSyncEvent({required this.type, required this.payload});

  final String type;
  final Map<String, dynamic> payload;
}
