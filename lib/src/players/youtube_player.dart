import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../url_detector.dart';
import '../video_labels.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_skeleton.dart';
import '../widgets/watch_externally_view.dart';

class YouTubeVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final UrlVideoPlayerLabels labels;
  final Widget? loadingWidget;

  const YouTubeVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.labels,
    this.loadingWidget,
  });

  @override
  State<YouTubeVideoPlayer> createState() => _YouTubeVideoPlayerState();
}

class _YouTubeVideoPlayerState extends State<YouTubeVideoPlayer> {
  bool _embedBlocked = false;
  bool _loading = true;

  String _buildHtml(String videoId) => '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    html, body { margin:0; padding:0; background:#000; height:100%; width:100%; overflow:hidden; }
    iframe { width:100%; height:100%; border:none; display:block; }
  </style>
</head>
<body>
  <iframe
    src="https://www.youtube-nocookie.com/embed/$videoId?autoplay=1&rel=0&modestbranding=1&playsinline=1&controls=1"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
    allowfullscreen>
  </iframe>
  <script>
    window.addEventListener('message', function(e) {
      if (e.data && typeof e.data === 'string' && e.data.indexOf('"error":') !== -1) {
        window.flutter_inappwebview.callHandler('onEmbedError');
      }
    });
  </script>
</body>
</html>
''';

  @override
  Widget build(BuildContext context) {
    final videoId = UrlVideoUrlDetector.extractYouTubeId(widget.videoUrl);

    if (videoId == null) {
      return VideoErrorView(message: widget.labels.failedToLoad);
    }

    if (_embedBlocked) {
      return WatchExternallyView(
        videoUrl: widget.videoUrl,
        label: widget.labels.watchOnYouTube,
        message: widget.labels.videoNotAvailableEmbedded,
      );
    }

    return Stack(
      children: [
        InAppWebView(
          initialData: InAppWebViewInitialData(
            data: _buildHtml(videoId),
            baseUrl: WebUri('https://www.google.com/'),
            mimeType: 'text/html',
            encoding: 'utf-8',
          ),
          initialSettings: InAppWebViewSettings(
            mediaPlaybackRequiresUserGesture: false,
            allowsInlineMediaPlayback: true,
            javaScriptEnabled: true,
            transparentBackground: true,
            supportZoom: false,
          ),
          onWebViewCreated: (controller) {
            controller.addJavaScriptHandler(
              handlerName: 'onEmbedError',
              callback: (_) {
                if (mounted) setState(() => _embedBlocked = true);
              },
            );
          },
          onLoadStop: (controller, url) {
            if (mounted) setState(() => _loading = false);
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            final url = navigationAction.request.url?.toString() ?? '';
            if (!url.startsWith('http') &&
                !url.startsWith('https') &&
                !url.startsWith('about')) {
              return NavigationActionPolicy.CANCEL;
            }
            return NavigationActionPolicy.ALLOW;
          },
        ),
        VideoLoadingOverlay(visible: _loading, customWidget: widget.loadingWidget),
      ],
    );
  }
}
