import 'package:flutter/material.dart';

class ShutterButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const ShutterButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 84,
        height: 84,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFFFB800), width: 4),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isLoading ? Colors.grey : Colors.white,
          ),
          child: isLoading
              ? const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Color(0xFF7F77DD),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
