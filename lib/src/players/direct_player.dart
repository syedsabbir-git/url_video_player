import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../video_labels.dart';
import '../widgets/error_view.dart';

class DirectVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final UrlVideoPlayerLabels labels;

  const DirectVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.labels,
  });

  @override
  State<DirectVideoPlayer> createState() => _DirectVideoPlayerState();
}

class _DirectVideoPlayerState extends State<DirectVideoPlayer> {
  VideoPlayerController? _videoCtrl;
  ChewieController? _chewieCtrl;
  bool _initialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadVideo(widget.videoUrl);
  }

  @override
  void didUpdateWidget(DirectVideoPlayer old) {
    super.didUpdateWidget(old);
    if (old.videoUrl != widget.videoUrl) {
      _disposeControllers();
      setState(() {
        _initialized = false;
        _hasError = false;
      });
      _loadVideo(widget.videoUrl);
    }
  }

  Future<void> _loadVideo(String url) async {
    try {
      final videoCtrl = VideoPlayerController.networkUrl(Uri.parse(url));
      await videoCtrl.initialize();
      await videoCtrl.seekTo(Duration.zero);
      await videoCtrl.setVolume(1);

      final chewieCtrl = ChewieController(
        videoPlayerController: videoCtrl,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        aspectRatio: videoCtrl.value.aspectRatio,
      );

      if (mounted) {
        setState(() {
          _videoCtrl = videoCtrl;
          _chewieCtrl = chewieCtrl;
          _initialized = true;
        });
      } else {
        chewieCtrl.dispose();
        videoCtrl.dispose();
      }
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  void _disposeControllers() {
    _chewieCtrl?.dispose();
    _videoCtrl?.dispose();
    _chewieCtrl = null;
    _videoCtrl = null;
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) return VideoErrorView(message: widget.labels.failedToLoad);

    if (!_initialized || _chewieCtrl == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white70),
      );
    }

    return Chewie(controller: _chewieCtrl!);
  }
}
