import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WatchExternallyView extends StatelessWidget {
  final String videoUrl;
  final String label;
  final String message;

  const WatchExternallyView({
    super.key,
    required this.videoUrl,
    required this.label,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.play_circle_outline_rounded, size: 64, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text(
          message,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => launchUrlString(videoUrl, mode: LaunchMode.externalApplication),
          icon: const Icon(Icons.open_in_new),
          label: Text(label),
        ),
      ],
    );
  }
}
