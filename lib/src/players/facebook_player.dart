import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../video_labels.dart';
import '../widgets/loading_skeleton.dart';
import '../widgets/watch_externally_view.dart';

class FacebookVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final UrlVideoPlayerLabels labels;
  final Widget? loadingWidget;

  const FacebookVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.labels,
    this.loadingWidget,
  });

  @override
  State<FacebookVideoPlayer> createState() => _FacebookVideoPlayerState();
}

class _FacebookVideoPlayerState extends State<FacebookVideoPlayer> {
  bool _loginRequired = false;
  bool _loading = true;

  String _buildHtml(String encodedUrl) => '''
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
    src="https://www.facebook.com/plugins/video.php?href=$encodedUrl&show_text=false&width=640&autoplay=true&mute=false"
    width="100%"
    height="100%"
    scrolling="no"
    frameborder="0"
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
        label: widget.labels.watchOnFacebook,
        message: widget.labels.videoNotAvailableEmbedded,
      );
    }

    final encodedUrl = Uri.encodeComponent(widget.videoUrl);

    return Stack(
      children: [
        InAppWebView(
          initialData: InAppWebViewInitialData(
            data: _buildHtml(encodedUrl),
            baseUrl: WebUri('https://www.facebook.com/'),
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
            if (url.contains('facebook.com/login') ||
                url.contains('facebook.com/checkpoint') ||
                url.contains('m.facebook.com/login')) {
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
