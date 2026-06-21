import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../url_detector.dart';
import '../video_labels.dart';
import '../widgets/error_view.dart';
import '../widgets/loading_skeleton.dart';
import '../widgets/watch_externally_view.dart';

class InstagramVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final UrlVideoPlayerLabels labels;
  final Widget? loadingWidget;

  const InstagramVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.labels,
    this.loadingWidget,
  });

  @override
  State<InstagramVideoPlayer> createState() => _InstagramVideoPlayerState();
}

class _InstagramVideoPlayerState extends State<InstagramVideoPlayer> {
  bool _loginRequired = false;
  bool _loading = true;

  String _buildHtml(String embedUrl) => '''
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
    src="$embedUrl"
    width="100%"
    height="100%"
    frameborder="0"
    scrolling="no"
    allowfullscreen="true"
    allow="autoplay; clipboard-write; encrypted-media; picture-in-picture; web-share">
  </iframe>
</body>
</html>
''';

  @override
  Widget build(BuildContext context) {
    if (_loginRequired) {
      return WatchExternallyView(
        videoUrl: widget.videoUrl,
        label: widget.labels.watchOnInstagram,
        message: widget.labels.videoNotAvailableEmbedded,
      );
    }

    final shortcode = UrlVideoUrlDetector.extractInstagramShortcode(widget.videoUrl);
    if (shortcode == null) {
      return VideoErrorView(message: widget.labels.failedToLoad);
    }

    final type = UrlVideoUrlDetector.instagramEmbedPath(widget.videoUrl);
    final embedUrl = 'https://www.instagram.com/$type/$shortcode/embed/captioned/';

    return Stack(
      children: [
        InAppWebView(
          initialData: InAppWebViewInitialData(
            data: _buildHtml(embedUrl),
            baseUrl: WebUri('https://www.instagram.com/'),
            mimeType: 'text/html',
            encoding: 'utf-8',
          ),
          initialSettings: InAppWebViewSettings(
            mediaPlaybackRequiresUserGesture: false,
            allowsInlineMediaPlayback: true,
            javaScriptEnabled: true,
            transparentBackground: true,
            supportZoom: false,
            thirdPartyCookiesEnabled: true,
          ),
          onLoadStop: (controller, url) {
            if (mounted) setState(() => _loading = false);
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            final url =
                navigationAction.request.url?.toString().toLowerCase() ?? '';
            if (url.contains('instagram.com/accounts/login') ||
                url.contains('instagram.com/challenge/')) {
              if (mounted) setState(() => _loginRequired = true);
              return NavigationActionPolicy.CANCEL;
            }
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
