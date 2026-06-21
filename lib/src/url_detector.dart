import 'video_type.dart';

/// Utility class for analysing video URLs.
class UrlVideoUrlDetector {
  UrlVideoUrlDetector._();

  /// Returns the [VideoType] that best matches [url].
  ///
  /// Detection order: YouTube → Facebook → Instagram → direct.
  static VideoType detect(String url) {
    final lower = url.toLowerCase();
    if (_isYouTube(lower)) return VideoType.youtube;
    if (_isFacebook(lower)) return VideoType.facebook;
    if (_isInstagram(lower)) return VideoType.instagram;
    return VideoType.direct;
  }

  static bool _isYouTube(String lower) =>
      lower.contains('youtube.com/watch') || lower.contains('youtu.be/');

  static bool _isFacebook(String lower) =>
      lower.contains('facebook.com/') || lower.contains('fb.watch/');

  static bool _isInstagram(String lower) => lower.contains('instagram.com/');

  /// Extracts the YouTube video ID from a URL, or `null` if the URL is not
  /// a recognisable YouTube link.
  static String? extractYouTubeId(String url) {
    try {
      final uri = Uri.parse(url.trim());
      if (uri.host.contains('youtu.be')) {
        return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      } else if (uri.queryParameters.containsKey('v')) {
        return uri.queryParameters['v'];
      } else if (uri.pathSegments.contains('embed')) {
        return uri.pathSegments.last;
      }
    } catch (_) {}
    return null;
  }

  /// Extracts the Instagram shortcode from a post, Reel, or IGTV URL.
  static String? extractInstagramShortcode(String url) {
    final match =
        RegExp(r'instagram\.com/(?:p|reel|tv)/([A-Za-z0-9_-]+)').firstMatch(url);
    return match?.group(1);
  }

  /// Returns the Instagram embed path segment (`p`, `reel`, or `tv`) inferred
  /// from the original URL.
  static String instagramEmbedPath(String url) {
    if (url.contains('/reel/')) return 'reel';
    if (url.contains('/tv/')) return 'tv';
    return 'p';
  }
}
