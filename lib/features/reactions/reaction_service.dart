import 'dart:async';
import '../../core/services/app_sync_service.dart';

class ReactionItem {
  ReactionItem({
    required this.userName,
    required this.emoji,
    required this.imageId,
    this.timestamp,
  });

  final String userName;
  final String emoji;
  final String imageId;
  final DateTime? timestamp;
}

class ReactionUserEntry {
  ReactionUserEntry({
    required this.userName,
    required this.emoji,
    required this.imageId,
    required this.timestamp,
  });

  final String userName;
  final String emoji;
  final String imageId;
  final DateTime timestamp;
}

class ReactionSummary {
  ReactionSummary({
    required this.totalCount,
    required this.currentUserReaction,
    required this.userNames,
    required this.emojiCounts,
    required this.userEntries,
    required this.imageId,
  });

  final int totalCount;
  final String? currentUserReaction;
  final List<String> userNames;
  final Map<String, int> emojiCounts;
  final List<ReactionUserEntry> userEntries;
  final String imageId;
}

class ReactionService {
  ReactionService({
    List<ReactionItem>? initialReactions,
    AppSyncService? syncService,
  }) {
    _syncService = syncService ?? AppSyncService();
    _reactions.addAll(
      initialReactions ??
          [
            ReactionItem(
              userName: 'An',
              emoji: '😍',
              imageId: 'image_01',
              timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
            ),
            ReactionItem(
              userName: 'Binh',
              emoji: '🔥',
              imageId: 'image_01',
              timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
            ),
          ],
    );
    _controller.add(_reactions.toList());
    _syncSubscription = _syncService!.events.listen((event) {
      if (event.type == 'heartbeat') {
        _controller.add(_reactions.toList());
      }
    });
  }

  final List<ReactionItem> _reactions = [];
  final StreamController<List<ReactionItem>> _controller =
      StreamController<List<ReactionItem>>.broadcast();
  AppSyncService? _syncService;
  StreamSubscription? _syncSubscription;

  Stream<List<ReactionItem>> get reactionsStream => _controller.stream;

  Stream<ReactionSummary> watchImageSummary(
    String imageId,
    String currentUserName,
  ) async* {
    yield await getReactionSummary(imageId, currentUserName);
    await for (final _ in _controller.stream) {
      yield await getReactionSummary(imageId, currentUserName);
    }
  }

  Future<List<ReactionItem>> getReactions(String imageId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _reactions.where((item) => item.imageId == imageId).toList();
  }

  Future<ReactionSummary> getReactionSummary(
    String imageId,
    String currentUserName,
  ) async {
    final reactions = await getReactions(imageId);
    final counts = <String, int>{};
    final entries = <ReactionUserEntry>[];

    for (final reaction in reactions) {
      counts[reaction.emoji] = (counts[reaction.emoji] ?? 0) + 1;
      entries.add(
        ReactionUserEntry(
          userName: reaction.userName,
          emoji: reaction.emoji,
          imageId: reaction.imageId,
          timestamp: reaction.timestamp ?? DateTime.now(),
        ),
      );
    }

    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return ReactionSummary(
      totalCount: reactions.length,
      currentUserReaction: reactions
          .where((item) => item.userName == currentUserName)
          .map((item) => item.emoji)
          .cast<String?>()
          .firstOrNull,
      userNames: reactions.map((item) => item.userName).toList(),
      emojiCounts: counts,
      userEntries: entries,
      imageId: imageId,
    );
  }

  Future<void> addOrUpdateReaction(
    String imageId,
    String emoji,
    String userName,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _reactions.removeWhere(
      (item) => item.imageId == imageId && item.userName == userName,
    );
    _reactions.add(
      ReactionItem(
        userName: userName,
        emoji: emoji,
        imageId: imageId,
        timestamp: DateTime.now(),
      ),
    );
    _controller.add(_reactions.toList());
  }

  Future<void> removeReaction(String imageId, String userName) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _reactions.removeWhere(
      (item) => item.imageId == imageId && item.userName == userName,
    );
    _controller.add(_reactions.toList());
  }

  void dispose() {
    _syncSubscription?.cancel();
    _syncService?.dispose();
  }
}

extension on Iterable<String?> {
  String? get firstOrNull => isEmpty ? null : first;
}
