import 'package:flutter/material.dart';

class VideoErrorView extends StatelessWidget {
  final String message;

  const VideoErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.broken_image_rounded, size: 64, color: Colors.grey[600]),
        const SizedBox(height: 16),
        Text(
          message,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}
