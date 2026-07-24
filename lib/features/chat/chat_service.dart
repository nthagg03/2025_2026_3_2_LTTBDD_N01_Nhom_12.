import 'dart:async';
import '../../core/services/app_sync_service.dart';

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.senderName,
    required this.text,
    required this.createdAt,
    required this.isRead,
    required this.isReplyToPhoto,
    required this.replyImageUrl,
  });

  final String id;
  final String senderName;
  final String text;
  final DateTime createdAt;
  final bool isRead;
  final bool isReplyToPhoto;
  final String? replyImageUrl;
}

class ChatConversation {
  ChatConversation({
    required this.id,
    required this.contactName,
    required this.lastMessage,
    required this.unreadCount,
    required this.updatedAt,
    required List<ChatMessage> messages,
  }) : messages = List<ChatMessage>.from(messages);

  final String id;
  final String contactName;
  String lastMessage;
  int unreadCount;
  DateTime updatedAt;
  final List<ChatMessage> messages;
}

class ChatService {
  ChatService({
    List<ChatConversation>? initialConversations,
    AppSyncService? syncService,
  }) {
    _syncService = syncService ?? AppSyncService();
    _conversations.addAll(
      (initialConversations ??
              [
                ChatConversation(
                  id: 'chat_1',
                  contactName: 'Mai',
                  lastMessage: 'Ảnh đẹp quá!',
                  unreadCount: 2,
                  updatedAt: DateTime.now().subtract(
                    const Duration(minutes: 2),
                  ),
                  messages: [
                    ChatMessage(
                      id: 'm1',
                      senderName: 'Mai',
                      text: 'Ảnh đẹp quá!',
                      createdAt: DateTime.now().subtract(
                        const Duration(minutes: 2),
                      ),
                      isRead: true,
                      isReplyToPhoto: false,
                      replyImageUrl: null,
                    ),
                  ],
                ),
                ChatConversation(
                  id: 'chat_2',
                  contactName: 'Tuan',
                  lastMessage: 'Reply ảnh của em nhé.',
                  unreadCount: 0,
                  updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
                  messages: [
                    ChatMessage(
                      id: 'm2',
                      senderName: 'Tuan',
                      text: 'Reply ảnh của em nhé.',
                      createdAt: DateTime.now().subtract(
                        const Duration(hours: 1),
                      ),
                      isRead: true,
                      isReplyToPhoto: true,
                      replyImageUrl: 'https://picsum.photos/seed/reply/200/200',
                    ),
                  ],
                ),
              ])
          .map(
            (conversation) => ChatConversation(
              id: conversation.id,
              contactName: conversation.contactName,
              lastMessage: conversation.lastMessage,
              unreadCount: conversation.unreadCount,
              updatedAt: conversation.updatedAt,
              messages: conversation.messages,
            ),
          ),
    );
    _controller.add(List.from(_conversations));
    _syncSubscription = _syncService!.events.listen((event) {
      if (event.type == 'heartbeat') {
        _controller.add(List.from(_conversations));
      }
    });
  }

  final List<ChatConversation> _conversations = [];
  final StreamController<List<ChatConversation>> _controller =
      StreamController<List<ChatConversation>>.broadcast();
  AppSyncService? _syncService;
  StreamSubscription? _syncSubscription;

  Stream<List<ChatConversation>> get conversationsStream => _controller.stream;

  Future<List<ChatConversation>> getConversations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _conversations.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return List.from(_conversations);
  }

  Future<List<ChatMessage>> getMessages(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final conversation = _conversations.firstWhere(
      (item) => item.id == conversationId,
    );
    return List.from(conversation.messages);
  }

  Future<void> sendMessage(
    String conversationId,
    String senderName,
    String text, {
    bool isReplyToPhoto = false,
    String? replyImageUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final conversation = _conversations.firstWhere(
      (item) => item.id == conversationId,
    );
    conversation.messages.add(
      ChatMessage(
        id: 'm_${DateTime.now().millisecondsSinceEpoch}',
        senderName: senderName,
        text: text,
        createdAt: DateTime.now(),
        isRead: false,
        isReplyToPhoto: isReplyToPhoto,
        replyImageUrl: replyImageUrl,
      ),
    );
    conversation.lastMessage = text;
    conversation.updatedAt = DateTime.now();
    _controller.add(List.from(_conversations));
  }

  Future<void> markConversationAsRead(String conversationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final conversation = _conversations.firstWhere(
      (item) => item.id == conversationId,
    );
    conversation.unreadCount = 0;
    _controller.add(List.from(_conversations));
  }

  void dispose() {
    _syncSubscription?.cancel();
    _syncService?.dispose();
  }
}
