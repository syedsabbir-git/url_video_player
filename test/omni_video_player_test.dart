import 'package:flutter_test/flutter_test.dart';
import 'package:url_video_player/url_video_player.dart';

void main() {
  group('UrlVideoUrlDetector.detect', () {
    test('detects youtube.com/watch URLs', () {
      expect(
        UrlVideoUrlDetector.detect('https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
        VideoType.youtube,
      );
    });

    test('detects youtu.be short links', () {
      expect(
        UrlVideoUrlDetector.detect('https://youtu.be/dQw4w9WgXcQ'),
        VideoType.youtube,
      );
    });

    test('detects facebook.com links', () {
      expect(
        UrlVideoUrlDetector.detect('https://www.facebook.com/watch?v=123456'),
        VideoType.facebook,
      );
    });

    test('detects fb.watch short links', () {
      expect(
        UrlVideoUrlDetector.detect('https://fb.watch/abc123/'),
        VideoType.facebook,
      );
    });

    test('detects instagram.com/reel links', () {
      expect(
        UrlVideoUrlDetector.detect('https://www.instagram.com/reel/ABC123/'),
        VideoType.instagram,
      );
    });

    test('detects instagram.com/p links', () {
      expect(
        UrlVideoUrlDetector.detect('https://www.instagram.com/p/ABC123/'),
        VideoType.instagram,
      );
    });

    test('detects instagram.com/tv links', () {
      expect(
        UrlVideoUrlDetector.detect('https://www.instagram.com/tv/ABC123/'),
        VideoType.instagram,
      );
    });

    test('falls back to direct for plain mp4 URL', () {
      expect(
        UrlVideoUrlDetector.detect('https://example.com/video.mp4'),
        VideoType.direct,
      );
    });

    test('falls back to direct for unknown URL', () {
      expect(
        UrlVideoUrlDetector.detect('https://vimeo.com/123456'),
        VideoType.direct,
      );
    });
  });

  group('UrlVideoUrlDetector.extractYouTubeId', () {
    test('extracts ID from watch URL', () {
      expect(
        UrlVideoUrlDetector.extractYouTubeId(
            'https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
        'dQw4w9WgXcQ',
      );
    });

    test('extracts ID from youtu.be short link', () {
      expect(
        UrlVideoUrlDetector.extractYouTubeId('https://youtu.be/dQw4w9WgXcQ'),
        'dQw4w9WgXcQ',
      );
    });

    test('returns null for non-YouTube URL', () {
      expect(
        UrlVideoUrlDetector.extractYouTubeId('https://example.com/video'),
        isNull,
      );
    });
  });

  group('UrlVideoUrlDetector.extractInstagramShortcode', () {
    test('extracts shortcode from reel URL', () {
      expect(
        UrlVideoUrlDetector.extractInstagramShortcode(
            'https://www.instagram.com/reel/ABC123xyz/'),
        'ABC123xyz',
      );
    });

    test('extracts shortcode from post URL', () {
      expect(
        UrlVideoUrlDetector.extractInstagramShortcode(
            'https://www.instagram.com/p/ABC123xyz/'),
        'ABC123xyz',
      );
    });

    test('returns null for non-Instagram URL', () {
      expect(
        UrlVideoUrlDetector.extractInstagramShortcode(
            'https://example.com/reel/ABC123/'),
        isNull,
      );
    });
  });

  group('UrlVideoUrlDetector.instagramEmbedPath', () {
    test('returns reel for reel URLs', () {
      expect(
        UrlVideoUrlDetector.instagramEmbedPath(
            'https://www.instagram.com/reel/ABC123/'),
        'reel',
      );
    });

    test('returns tv for IGTV URLs', () {
      expect(
        UrlVideoUrlDetector.instagramEmbedPath(
            'https://www.instagram.com/tv/ABC123/'),
        'tv',
      );
    });

    test('returns p for post URLs', () {
      expect(
        UrlVideoUrlDetector.instagramEmbedPath(
            'https://www.instagram.com/p/ABC123/'),
        'p',
      );
    });
  });

  group('UrlVideoPlayerLabels', () {
    test('has correct English defaults', () {
      const labels = UrlVideoPlayerLabels();
      expect(labels.watchOnYouTube, 'Watch on YouTube');
      expect(labels.watchOnFacebook, 'Watch on Facebook');
      expect(labels.watchOnInstagram, 'Watch on Instagram');
    });

    test('accepts custom values', () {
      const labels = UrlVideoPlayerLabels(watchOnYouTube: 'Open YouTube');
      expect(labels.watchOnYouTube, 'Open YouTube');
      expect(labels.watchOnFacebook, 'Watch on Facebook');
    });
  });
}
