import 'package:flutter/material.dart';

class FlipCameraButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const FlipCameraButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.45),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 48,
          height: 48,
          child: isLoading
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(
                  Icons.cameraswitch_rounded,
                  color: Colors.white,
                  size: 26,
                ),
        ),
      ),
    );
  }
}
