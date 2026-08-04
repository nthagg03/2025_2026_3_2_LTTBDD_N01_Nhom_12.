import '../features/chat/chat_service.dart';

class FakeChatRepository {
  static final FakeChatRepository _instance = FakeChatRepository._internal();
  factory FakeChatRepository() => _instance;
  FakeChatRepository._internal();

  final ChatService _service = ChatService();
  ChatService get service => _service;

  Future<List<ChatConversation>> getConversations() => _service.getConversations();

  Future<List<ChatMessage>> getMessages(String conversationId) =>
      _service.getMessages(conversationId);

  Future<void> sendMessage(
    String conversationId,
    String senderName,
    String text, {
    bool isReplyToPhoto = false,
    String? replyImageUrl,
  }) {
    return _service.sendMessage(
      conversationId,
      senderName,
      text,
      isReplyToPhoto: isReplyToPhoto,
      replyImageUrl: replyImageUrl,
    );
  }

  Future<void> markAsRead(String conversationId) {
    return _service.markConversationAsRead(conversationId);
  }
}
