import 'package:flutter/material.dart';

class ReactionBar extends StatelessWidget {
  final String? activeReaction;
  final Function(String emoji) onReactionSelected;

  static const List<String> availableEmojis = ['❤️', '🔥', '😍', '😮', '👍'];

  const ReactionBar({
    super.key,
    required this.activeReaction,
    required this.onReactionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E38),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2A2A44)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: availableEmojis.map((emoji) {
          final isSelected = activeReaction == emoji;
          return GestureDetector(
            onTap: () => onReactionSelected(emoji),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF7F77DD).withValues(alpha: 0.3)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: const Color(0xFFFFB800), width: 1.5)
                    : null,
              ),
              child: Text(
                emoji,
                style: TextStyle(
                  fontSize: isSelected ? 20 : 17,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
