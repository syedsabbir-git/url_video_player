/// Holds every user-visible string used by [OmniVideoPlayer].
///
/// Override individual fields to localise or rebrand the text. All fields have
/// sensible English defaults so the widget works out of the box.
class UrlVideoPlayerLabels {
  /// Button label when a YouTube video cannot be embedded.
  final String watchOnYouTube;

  /// Button label when a Facebook video requires login or is private.
  final String watchOnFacebook;

  /// Button label when an Instagram video requires login or is private.
  final String watchOnInstagram;

  /// Message shown below the icon when embedding is not available.
  final String videoNotAvailableEmbedded;

  /// Message shown when the video fails to load entirely.
  final String failedToLoad;

  const UrlVideoPlayerLabels({
    this.watchOnYouTube = 'Watch on YouTube',
    this.watchOnFacebook = 'Watch on Facebook',
    this.watchOnInstagram = 'Watch on Instagram',
    this.videoNotAvailableEmbedded = 'This video cannot be played in-app',
    this.failedToLoad = 'Failed to load video',
  });
}
