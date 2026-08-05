import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../friends/models/friend_model.dart';
import '../../history/models/history_photo.dart';
import '../../history/services/history_service.dart';

class ChatMessageItem {
  final String id;
  final String? text;
  final bool isMine;
  final bool isDateHeader;
  final HistoryPhoto? photo;
  final String? photoReply;

  const ChatMessageItem({
    required this.id,
    this.text,
    this.isMine = false,
    this.isDateHeader = false,
    this.photo,
    this.photoReply,
  });
}

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({
    super.key,
    required this.friend,
  });

  final FriendModel friend;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  late List<ChatMessageItem> _messages;

  @override
  void initState() {
    super.initState();
    _initSampleMessages();
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _initSampleMessages() {
    // Get a photo from memories history for the photo message bubble
    final allPhotos = HistoryService.instance.photos;
    final HistoryPhoto samplePhoto = allPhotos.isNotEmpty
        ? allPhotos.first
        : HistoryPhoto(
            id: 'sample_photo',
            imagePath: 'lib/assets/imgs/testimg.jpg',
            caption: 'Sắp đến giờ G',
            createdAt: DateTime.now(),
            recipients: [widget.friend.name],
          );


    _messages = [
      const ChatMessageItem(
        id: 'm1',
        text: 'Mời em về stu của anh',
        isMine: true,
      ),
      const ChatMessageItem(
        id: 'm2',
        text: 'Ngay ở khu nhà anh',
        isMine: false,
      ),
      const ChatMessageItem(
        id: 'm3',
        text: 'Thu quả thanh',
        isMine: false,
      ),
      const ChatMessageItem(
        id: 'm4',
        text: 'Bằng cái micro của anh',
        isMine: true,
      ),
      const ChatMessageItem(
        id: 'm5',
        text: 'Giọng em ngọt như quả chanh chỉ autotune là nhanh',
        isMine: false,
      ),
      const ChatMessageItem(
        id: 'm6',
        text: 'Nhạc hay là lỗi của anh',
        isMine: false,
      ),
    ];
  }

  void _sendMessage() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessageItem(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          text: text,
          isMine: true,
        ),
      );
    });

    _msgCtrl.clear();
    HapticFeedback.lightImpact();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendEmojiReaction(String emoji) {
    HapticFeedback.lightImpact();
    setState(() {
      _messages.add(
        ChatMessageItem(
          id: 'reaction_${DateTime.now().millisecondsSinceEpoch}',
          text: emoji,
          isMine: true,
        ),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 16, 6),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),

          const Spacer(),

          // Friend Header Pill (Avatar + Name >)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 1.5),
                  color: const Color(0xFF38393C),
                ),
                child: Center(
                  child: Text(
                    widget.friend.avatar,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B3C40),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.friend.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white70,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Spacer(),

          const SizedBox(width: 44), // balance spacing
        ],
      ),
    );
  }

  Widget _buildDateHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTextMessage(ChatMessageItem msg) {
    final isMine = msg.isMine;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) ...[
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF38393C),
              ),
              child: Center(
                child: Text(
                  widget.friend.avatar,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                color: isMine ? Colors.white : const Color(0xFF424448),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                msg.text ?? '',
                style: TextStyle(
                  color: isMine ? Colors.black : Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoMessage(ChatMessageItem msg) {
    final photo = msg.photo;
    Widget imgWidget;

    if (photo != null) {
      final path = photo.imagePath;
      if (path.startsWith('lib/') || path.startsWith('assets/')) {
        imgWidget = Image.asset(path, fit: BoxFit.cover);
      } else if (File(path).existsSync()) {
        imgWidget = Image.file(File(path), fit: BoxFit.cover);
      } else {
        imgWidget = Container(
          color: const Color(0xFF38393C),
          child: const Center(
            child: Icon(Icons.photo_rounded, color: Colors.white38, size: 48),
          ),
        );
      }
    } else {
      imgWidget = Container(
        color: const Color(0xFF38393C),
        child: const Center(
          child: Icon(Icons.photo_rounded, color: Colors.white38, size: 48),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Photo Card Container
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.78,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      imgWidget,

                      // Top Overlay (Friend Avatar + Name + 15g)
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF424448),
                                ),
                                child: Center(
                                  child: Text(
                                    widget.friend.avatar,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                widget.friend.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '15g',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Bottom Overlay Pill (Caption e.g. "Sắp đến giờ G")
                      if (photo != null && photo.caption.isNotEmpty)
                        Positioned(
                          bottom: 14,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.55),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                photo.caption,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Photo Reply Text Bubble below photo
          if (msg.photoReply != null && msg.photoReply!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(
                  msg.photoReply!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF38393C),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _msgCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                onSubmitted: (_) => _sendMessage(),
                decoration: const InputDecoration(
                  hintText: 'Tin nhắn...',
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 15),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),

            // Quick Emojis (💛, 🔥, 😍, ➕)
            GestureDetector(
              onTap: () => _sendEmojiReaction('💛'),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text('💛', style: TextStyle(fontSize: 22)),
              ),
            ),
            GestureDetector(
              onTap: () => _sendEmojiReaction('🔥'),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text('🔥', style: TextStyle(fontSize: 22)),
              ),
            ),
            GestureDetector(
              onTap: () => _sendEmojiReaction('😍'),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text('😍', style: TextStyle(fontSize: 22)),
              ),
            ),
            GestureDetector(
              onTap: () => _sendEmojiReaction('👍'),
              child: const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.add_reaction_outlined,
                  color: Colors.white70,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF242528),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),

            // Chat Messages Feed
            Expanded(
              child: ListView.builder(
                controller: _scrollCtrl,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  if (msg.isDateHeader) {
                    return _buildDateHeader(msg.text ?? '');
                  }
                  if (msg.photo != null) {
                    return _buildPhotoMessage(msg);
                  }
                  return _buildTextMessage(msg);
                },
              ),
            ),

            // Bottom Input Bar
            _buildInputBar(),
          ],
        ),
      ),
    );
  }
}
