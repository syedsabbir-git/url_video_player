/// Identifies which platform a video URL belongs to.
enum VideoType {
  /// A YouTube video (`youtube.com/watch` or `youtu.be/` short-link).
  youtube,

  /// A Facebook video (`facebook.com/` or `fb.watch/` short-link).
  facebook,

  /// An Instagram post, Reel, or IGTV (`instagram.com/p|reel|tv/`).
  instagram,

  /// A direct video file URL (mp4, webm, etc.) streamed via the platform
  /// media player.
  direct,
}
