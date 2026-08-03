import 'package:flutter/material.dart';

class CameraTopBar extends StatelessWidget {
  final int friendCount;
  final String? avatarUrl;
  final VoidCallback? onFriendsPressed;
  final VoidCallback? onProfilePressed;

  const CameraTopBar({
    super.key,
    this.friendCount = 0,
    this.avatarUrl,
    this.onFriendsPressed,
    this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.black.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            onTap: onFriendsPressed,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.group_rounded,
                    color: Colors.white,
                    size: 21,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    '$friendCount bạn bè',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onProfilePressed,
          child: Container(
            width: 44,
            height: 44,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFFB800), width: 2),
            ),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF1C1C2E),
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl!)
                  : null,
              child: avatarUrl == null
                  ? const Icon(Icons.person_rounded, color: Colors.white)
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
