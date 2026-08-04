import 'package:flutter/material.dart';

class EmptyHistory extends StatelessWidget {
  const EmptyHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.photo_camera_outlined,
            size: 80,
            color: Colors.white38,
          ),
          SizedBox(height: 20),
          Text(
            "No memories yet",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Take your first Locket photo.",
            style: TextStyle(
              color: Colors.white54,
            ),
          )
        ],
      ),
    );
  }
}