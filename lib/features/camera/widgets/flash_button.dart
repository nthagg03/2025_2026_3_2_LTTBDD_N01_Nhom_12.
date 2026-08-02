import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FlashButton extends StatelessWidget {
  final FlashMode flashMode;
  final VoidCallback onPressed;

  const FlashButton({
    super.key,
    required this.flashMode,
    required this.onPressed,
  });

  IconData get _icon {
    switch (flashMode) {
      case FlashMode.off:
        return Icons.flash_off_rounded;

      case FlashMode.auto:
        return Icons.flash_auto_rounded;

      case FlashMode.always:
        return Icons.flash_on_rounded;

      case FlashMode.torch:
        return Icons.highlight_rounded;
    }
  }

  String get _tooltip {
    switch (flashMode) {
      case FlashMode.off:
        return 'Flash đang tắt';

      case FlashMode.auto:
        return 'Flash tự động';

      case FlashMode.always:
        return 'Flash luôn bật';

      case FlashMode.torch:
        return 'Đèn pin';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _tooltip,
      child: Material(
        color: Colors.black.withValues(alpha: 0.45),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(
              _icon,
              color: flashMode == FlashMode.off
                  ? Colors.white
                  : const Color(0xFFFFB800),
              size: 25,
            ),
          ),
        ),
      ),
    );
  }
}