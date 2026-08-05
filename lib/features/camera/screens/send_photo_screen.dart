import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../friends/services/friend_service.dart';
import '../../history/models/history_photo.dart';
import '../../history/services/history_service.dart';

const List<Color> _avatarColors = [
  Color(0xFF7F77DD),
  Color(0xFF4CAF50),
  Color(0xFFE91E63),
  Color(0xFF2196F3),
  Color(0xFFFF9800),
  Color(0xFF9C27B0),
  Color(0xFF00BCD4),
];

Color _getColorForIndex(int index) =>
    _avatarColors[index % _avatarColors.length];

/// Locket-style screen for sending a photo.
/// Combines image preview + caption input + friend selection in one screen.
class SendPhotoScreen extends StatefulWidget {
  const SendPhotoScreen({
    super.key,
    required this.imageBytes,
    this.imagePath,
    this.initialCaption = '',
  });

  final Uint8List imageBytes;
  final String? imagePath;
  final String initialCaption;

  @override
  State<SendPhotoScreen> createState() => _SendPhotoScreenState();
}

class _SendPhotoScreenState extends State<SendPhotoScreen>
    with SingleTickerProviderStateMixin {
  // ── State ──────────────────────────────────────────────────────────────────
  final TextEditingController _captionController = TextEditingController();
  final FocusNode _captionFocus = FocusNode();
  bool _isCaptionVisible = false;
  bool _isSending = false;

  final Set<int> _selectedFriends = {};
  bool _selectAll = false;

  // Send button subtle pulse animation
  late AnimationController _pulseAnim;
  late Animation<double> _pulseScale;


  @override
  void initState() {
    super.initState();
    _captionController.text = widget.initialCaption;
    _pulseAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseScale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseAnim, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _captionController.dispose();
    _captionFocus.dispose();
    _pulseAnim.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  bool get _hasSomeSelected => _selectAll || _selectedFriends.isNotEmpty;

  void _toggleAll() {
    setState(() {
      if (_selectAll) {
        _selectAll = false;
      } else {
        _selectAll = true;
        _selectedFriends.clear();
      }
    });
    HapticFeedback.selectionClick();
  }

  void _toggleFriend(int index) {
    setState(() {
      _selectAll = false;
      if (_selectedFriends.contains(index)) {
        _selectedFriends.remove(index);
      } else {
        _selectedFriends.add(index);
      }
    });
    HapticFeedback.selectionClick();
  }

  void _showCaptionField() {
    setState(() => _isCaptionVisible = true);
    Future.delayed(const Duration(milliseconds: 80), () {
      _captionFocus.requestFocus();
    });
  }

  void _cancel() => Navigator.of(context).pop();

  Future<void> _send() async {
    if (!_hasSomeSelected || _isSending) return;
    FocusScope.of(context).unfocus();
    setState(() => _isSending = true);

    try {
      String path = widget.imagePath ?? '';
      if (path.isEmpty) {
        final tempDir = Directory.systemTemp;
        final file = File(
          '${tempDir.path}/locket_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        await file.writeAsBytes(widget.imageBytes);
        path = file.path;
      }

      await Future<void>.delayed(const Duration(milliseconds: 700));

      final realFriends = FriendService.instance.friends;
      final List<String> recipients;
      if (_selectAll) {
        recipients = realFriends.map((f) => f.name).toList();
      } else {
        recipients = _selectedFriends
            .where((i) => i < realFriends.length)
            .map((i) => realFriends[i].name)
            .toList();
      }


      HistoryService.instance.addPhoto(
        HistoryPhoto(
          id: 'photo_${DateTime.now().millisecondsSinceEpoch}',
          imagePath: path,
          caption: _captionController.text.trim(),
          createdAt: DateTime.now(),
          recipients: recipients,
          isMine: true,
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _selectAll
                ? 'Đã gửi ảnh cho tất cả bạn bè!'
                : 'Đã gửi ảnh cho ${recipients.length} người.',
          ),
          backgroundColor: const Color(0xFF7F77DD),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );

      Navigator.of(context).popUntil((route) => route.isFirst);
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _saveToDevice() async {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Đã lưu ảnh về máy'),
        backgroundColor: Colors.grey[800],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              _buildTopBar(),
              const Spacer(),
              _buildImagePreview(),
              const Spacer(),
              _buildDotsIndicator(),
              const SizedBox(height: 12),
              _buildMiddleActions(),
              const SizedBox(height: 16),
              _buildFriendRow(),
              const SizedBox(height: 16),
            ],

          ),
        ),
      ),
    );
  }

  // ── Top Bar ────────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
      child: Row(
        children: [
          const Spacer(),
          const Text(
            'Gửi đến...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const Spacer(),
          // Download / save button
          GestureDetector(
            onTap: _saveToDevice,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.download_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Image Preview ──────────────────────────────────────────────────────────
  Widget _buildImagePreview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.memory(
                widget.imageBytes,
                fit: BoxFit.cover,
                gaplessPlayback: true,
              ),
              // Gradient at bottom
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Color(0xAA000000),
                    ],
                    stops: [0, 0.55, 1],
                  ),
                ),
              ),
              _buildCaptionOverlay(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildCaptionOverlay() {
    if (!_isCaptionVisible) {
      // Tap-to-add message pill
      return Positioned(
        bottom: 22,
        left: 0,
        right: 0,
        child: GestureDetector(
          onTap: _showCaptionField,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Text(
                'Thêm một tin nhắn',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Caption text field shown when active
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: TextField(
        controller: _captionController,
        focusNode: _captionFocus,
        maxLength: 120,
        maxLines: 3,
        minLines: 1,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => FocusScope.of(context).unfocus(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Thêm một tin nhắn...',
          hintStyle: const TextStyle(color: Colors.white60),
          counterStyle: const TextStyle(color: Colors.white38, fontSize: 11),
          filled: true,
          fillColor: Colors.black.withValues(alpha: 0.5),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFFFB800), width: 1.5),
          ),
        ),
      ),
    );
  }

  // ── Page Dots ──────────────────────────────────────────────────────────────
  Widget _buildDotsIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(6, (i) {
          final isActive = i == 0;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: isActive ? 8 : 6,
            height: isActive ? 8 : 6,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.35),
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }

  // ── Middle: X | Send | Aa+ ─────────────────────────────────────────────────
  Widget _buildMiddleActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // X cancel
        GestureDetector(
          onTap: _cancel,
          child: SizedBox(
            width: 72,
            child: Center(
              child: Icon(
                Icons.close_rounded,
                color: Colors.white.withValues(alpha: 0.85),
                size: 32,
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Send button — large pulsing circle
        ScaleTransition(
          scale: _pulseScale,
          child: GestureDetector(
            onTap: _hasSomeSelected ? _send : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: _hasSomeSelected
                    ? const Color(0xFF8A8A8A)
                    : const Color(0xFF555555),
                shape: BoxShape.circle,
                boxShadow: _hasSomeSelected
                    ? [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.18),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: _isSending
                  ? const Padding(
                      padding: EdgeInsets.all(22),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Aa+ text / caption button
        GestureDetector(
          onTap: _showCaptionField,
          child: SizedBox(
            width: 72,
            child: Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Text(
                        'Aa',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFB800),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Friend Row ─────────────────────────────────────────────────────────────
  Widget _buildFriendRow() {
    return AnimatedBuilder(
      animation: FriendService.instance,
      builder: (context, _) {
        final realFriends = FriendService.instance.friends;

        return SizedBox(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // "Tất cả" avatar
              _buildFriendAvatar(
                label: 'Tất cả',
                selected: _selectAll,
                onTap: _toggleAll,
                avatarChild: const Icon(
                  Icons.groups_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                accentColor: const Color(0xFFFFB800),
                bgColor: const Color(0xFF3A3A3A),
              ),
              const SizedBox(width: 12),
              // Individual real friends from FriendService
              ...realFriends.asMap().entries.map((e) {
                final i = e.key;
                final f = e.value;
                final selected = _selectedFriends.contains(i);
                final color = _getColorForIndex(i);

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _buildFriendAvatar(
                    label: f.name,
                    selected: selected,
                    onTap: () => _toggleFriend(i),
                    avatarChild: Text(
                      f.avatar,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    accentColor: color,
                    bgColor: color.withValues(alpha: 0.45),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }


  Widget _buildFriendAvatar({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required Widget avatarChild,
    required Color accentColor,
    required Color bgColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
              border: Border.all(
                color: selected ? accentColor : Colors.transparent,
                width: 2.5,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.45),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: Center(child: avatarChild),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: selected ? accentColor : Colors.white60,
              fontSize: 11,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
