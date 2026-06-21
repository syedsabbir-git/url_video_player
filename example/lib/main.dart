import 'package:flutter/material.dart';
import 'package:url_video_player/url_video_player.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'UrlVideoPlayer Demo',
      home: _VideoListScreen(),
    );
  }
}

class _VideoListScreen extends StatelessWidget {
  const _VideoListScreen();

  static const _videos = [
    _VideoItem(
      label: 'YouTube',
      url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
    _VideoItem(
      label: 'YouTube (short link)',
      url: 'https://youtu.be/dQw4w9WgXcQ',
    ),
    _VideoItem(
      label: 'Facebook',
      url: 'https://www.facebook.com/watch?v=10156049449356729',
    ),
    _VideoItem(
      label: 'Instagram Reel',
      url: 'https://www.instagram.com/reel/C_example/',
    ),
    _VideoItem(
      label: 'Direct MP4',
      url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UrlVideoPlayer Demo')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _videos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final video = _videos[index];
          return _VideoTile(video: video);
        },
      ),
    );
  }
}

class _VideoTile extends StatelessWidget {
  final _VideoItem video;

  const _VideoTile({required this.video});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: const Icon(Icons.play_circle_outline),
      title: Text(video.label),
      subtitle: Text(
        video.url,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 11),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UrlVideoPlayer(
              url: video.url,
              title: video.label,
            ),
          ),
        );
      },
    );
  }
}

class _VideoItem {
  final String label;
  final String url;
  const _VideoItem({required this.label, required this.url});
}
