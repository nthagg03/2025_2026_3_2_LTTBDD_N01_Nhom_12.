import 'dart:typed_data';

import 'package:flutter/material.dart';

class SelectRecipientsScreen extends StatefulWidget {
  const SelectRecipientsScreen({
    super.key,
    required this.imageBytes,
    required this.caption,
  });

  final Uint8List imageBytes;
  final String caption;

  @override
  State<SelectRecipientsScreen> createState() => _SelectRecipientsScreenState();
}

class _SelectRecipientsScreenState extends State<SelectRecipientsScreen> {
  final Set<int> _selectedIndexes = {};

  final List<String> _friends = const ['Tân', 'Nam', 'Thắng', 'An Thuyên'];

  bool _isSending = false;

  bool get _isAllSelected =>
      _friends.isNotEmpty && _selectedIndexes.length == _friends.length;

  void _toggleFriend(int index) {
    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else {
        _selectedIndexes.add(index);
      }
    });
  }

  void _toggleAll() {
    setState(() {
      if (_isAllSelected) {
        _selectedIndexes.clear();
      } else {
        _selectedIndexes
          ..clear()
          ..addAll(List<int>.generate(_friends.length, (index) => index));
      }
    });
  }

  Future<void> _sendPhoto() async {
    if (_selectedIndexes.isEmpty || _isSending) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      // Tạm mô phỏng thao tác gửi.
      // Sau này thay bằng Firebase Storage và Firestore.
      await Future<void>.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Đã gửi ảnh cho '
            '${_selectedIndexes.length} người.',
          ),
          backgroundColor: const Color(0xFF7F77DD),
        ),
      );

      Navigator.of(context).popUntil((route) => route.isFirst);
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A14),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Chọn người nhận',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildPhotoInformation(),
            _buildSelectAll(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                itemCount: _friends.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8);
                },
                itemBuilder: (context, index) {
                  return _buildFriendItem(index);
                },
              ),
            ),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoInformation() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF13132A),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(
              widget.imageBytes,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.caption.isEmpty ? 'Không có chú thích' : widget.caption,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: widget.caption.isEmpty ? Colors.white54 : Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectAll() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: InkWell(
        onTap: _toggleAll,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF13132A),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              const Icon(Icons.groups_rounded, color: Color(0xFFFFB800)),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Gửi cho tất cả bạn bè',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Checkbox(
                value: _isAllSelected,
                onChanged: (_) {
                  _toggleAll();
                },
                activeColor: const Color(0xFFFFB800),
                checkColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFriendItem(int index) {
    final friendName = _friends[index];
    final isSelected = _selectedIndexes.contains(index);

    return InkWell(
      onTap: () {
        _toggleFriend(index);
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF272344) : const Color(0xFF13132A),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? const Color(0xFF7F77DD) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFF7F77DD),
              child: Text(
                friendName[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                friendName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Checkbox(
              value: isSelected,
              onChanged: (_) {
                _toggleFriend(index);
              },
              activeColor: const Color(0xFFFFB800),
              checkColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    final selectedCount = _selectedIndexes.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: FilledButton.icon(
        onPressed: selectedCount == 0 || _isSending ? null : _sendPhoto,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFFFB800),
          foregroundColor: Colors.black,
          disabledBackgroundColor: const Color(0xFF2A2A44),
          disabledForegroundColor: Colors.white38,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(27),
          ),
        ),
        icon: _isSending
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ),
              )
            : const Icon(Icons.send_rounded),
        label: Text(
          _isSending
              ? 'Đang gửi...'
              : selectedCount == 0
              ? 'Chọn người nhận'
              : 'Gửi cho $selectedCount người',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
