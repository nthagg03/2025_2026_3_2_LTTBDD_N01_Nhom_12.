import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'select_recipients_screen.dart';

class PhotoPreviewScreen extends StatefulWidget {
  final Uint8List imageBytes;
  final String? imagePath;

  const PhotoPreviewScreen({
    super.key,
    required this.imageBytes,
    this.imagePath,
  });

  @override
  State<PhotoPreviewScreen> createState() => _PhotoPreviewScreenState();
}

class _PhotoPreviewScreenState extends State<PhotoPreviewScreen> {
  final TextEditingController _captionController = TextEditingController();

  static const int _maxCaptionLength = 120;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  void _retakePhoto() {
    Navigator.pop(context);
  }

  Future<void> _continue() async {
    final caption = _captionController.text.trim();

    FocusScope.of(context).unfocus();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectRecipientsScreen(
          imageBytes: widget.imageBytes,
          imagePath: widget.imagePath,
          caption: caption,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.memory(
                        widget.imageBytes,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      ),
                      _buildGradient(),
                      _buildCaptionInput(),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: _retakePhoto,
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF13132A),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.close_rounded),
          ),
          const Spacer(),
          const Text(
            'Xem trước ảnh',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildGradient() {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.transparent, Color(0xD9000000)],
          stops: [0, 0.52, 1],
        ),
      ),
    );
  }

  Widget _buildCaptionInput() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 18,
      child: TextField(
        controller: _captionController,
        maxLength: _maxCaptionLength,
        minLines: 1,
        maxLines: 3,
        textInputAction: TextInputAction.done,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Thêm chú thích...',
          hintStyle: const TextStyle(color: Colors.white60),
          counterStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Colors.black.withValues(alpha: 0.46),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
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

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _retakePhoto,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(54),
                side: const BorderSide(color: Color(0xFF2A2A44)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27),
                ),
              ),
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Chụp lại'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: FilledButton.icon(
              onPressed: _continue,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFFB800),
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27),
                ),
              ),
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text(
                'Tiếp tục',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
