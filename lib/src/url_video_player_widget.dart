import 'package:flutter/material.dart';
import 'players/direct_player.dart';
import 'players/facebook_player.dart';
import 'players/instagram_player.dart';
import 'players/youtube_player.dart';
import 'url_detector.dart';
import 'video_labels.dart';
import 'video_type.dart';

/// A full-screen video player that automatically detects the platform from
/// [url] and uses the correct playback strategy:
///
/// * **YouTube** — embedded via `youtube-nocookie.com` inside an `InAppWebView`
/// * **Facebook** — official Facebook video plugin embed in `InAppWebView`
/// * **Instagram** — official Instagram embed (posts, Reels, IGTV) in `InAppWebView`
/// * **Direct URL** — streamed with `video_player` + Chewie controls
///
/// All WebView players show a shimmer skeleton while loading and fall back to
/// a "Watch on Platform" button when the content is private or login-gated.
///
/// ### Minimal usage
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (_) => UrlVideoPlayer(url: 'https://youtu.be/abc123'),
///   ),
/// );
/// ```
///
/// ### With customisation
/// ```dart
/// UrlVideoPlayer(
///   url: 'https://www.facebook.com/watch?v=123456',
///   title: 'Product Demo',
///   labels: UrlVideoPlayerLabels(
///     watchOnFacebook: 'Open in Facebook',
///   ),
/// )
/// ```
class UrlVideoPlayer extends StatelessWidget {
  /// The video URL. Supported formats:
  /// * `https://youtu.be/<id>` or `https://www.youtube.com/watch?v=<id>`
  /// * `https://www.facebook.com/watch?v=<id>` or `https://fb.watch/<id>`
  /// * `https://www.instagram.com/reel/<shortcode>/`
  /// * Any direct `.mp4` / `.webm` / `.m3u8` URL
  final String url;

  /// Text displayed in the [AppBar]. Defaults to an empty string (no title).
  final String title;

  /// Whether to show an [AppBar] with a back button and [title].
  ///
  /// Set to `false` when embedding [UrlVideoPlayer] inside a widget that
  /// already provides navigation chrome.
  final bool showAppBar;

  /// Background colour of the player screen. Defaults to [Colors.black].
  final Color backgroundColor;

  /// Overrides all user-visible strings. Use [UrlVideoPlayerLabels] to
  /// localise or rebrand the default English text.
  final UrlVideoPlayerLabels labels;

  /// Replaces the default shimmer skeleton with a custom widget shown while
  /// the WebView or video is initialising.
  final Widget? loadingWidget;

  const UrlVideoPlayer({
    super.key,
    required this.url,
    this.title = '',
    this.showAppBar = true,
    this.backgroundColor = Colors.black,
    this.labels = const UrlVideoPlayerLabels(),
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final VideoType type = UrlVideoUrlDetector.detect(url);

    final Widget player = switch (type) {
      VideoType.youtube => YouTubeVideoPlayer(
          videoUrl: url,
          labels: labels,
          loadingWidget: loadingWidget,
        ),
      VideoType.facebook => FacebookVideoPlayer(
          videoUrl: url,
          labels: labels,
          loadingWidget: loadingWidget,
        ),
      VideoType.instagram => InstagramVideoPlayer(
          videoUrl: url,
          labels: labels,
          loadingWidget: loadingWidget,
        ),
      VideoType.direct => DirectVideoPlayer(
          videoUrl: url,
          labels: labels,
        ),
    };

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: showAppBar
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: title.isNotEmpty
                  ? Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
            )
          : null,
      body: Center(child: player),
    );
  }
}
