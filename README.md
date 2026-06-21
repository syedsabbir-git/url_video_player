# url_video_player

A Flutter video player that **automatically detects and plays YouTube, Facebook, Instagram, and direct video URLs** — no manual configuration needed.

| Platform | Strategy |
|----------|----------|
| YouTube | `youtube-nocookie.com` embed via InAppWebView |
| Facebook | Official Facebook video plugin embed via InAppWebView |
| Instagram | Official embed (posts, Reels, IGTV) via InAppWebView |
| Direct URL (mp4 / webm) | Native `video_player` + Chewie controls |

Private or login-gated content gracefully degrades to a **"Watch on Platform"** button that opens the native app.

---

## Features

- Zero URL pre-processing — just pass the raw link
- Shimmer loading skeleton while the player initialises
- Fallback to external app for private / login-required content
- Fully customisable labels for localisation
- Optional custom loading widget override

---

## Platform setup (required)

### Android

In `android/app/src/main/AndroidManifest.xml`, add:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

In `android/app/build.gradle`, set:
```groovy
defaultConfig {
    minSdkVersion 21
}
```

### iOS

In `ios/Runner/Info.plist`, add:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

---

## Installation

```yaml
dependencies:
  url_video_player: ^0.1.0
```

---

## Usage

### Push as a full-screen player

```dart
import 'package:url_video_player/url_video_player.dart';

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => UrlVideoPlayer(
      url: 'https://youtu.be/dQw4w9WgXcQ',
      title: 'My Video',
    ),
  ),
);
```

Works identically for Facebook and Instagram URLs:

```dart
UrlVideoPlayer(url: 'https://www.facebook.com/watch?v=123456789')
UrlVideoPlayer(url: 'https://www.instagram.com/reel/ABC123/')
UrlVideoPlayer(url: 'https://example.com/video.mp4')
```

### Customise labels (localisation)

```dart
UrlVideoPlayer(
  url: videoUrl,
  labels: UrlVideoPlayerLabels(
    watchOnYouTube: 'YouTube-এ দেখুন',
    watchOnFacebook: 'ফেসবুকে দেখুন',
    watchOnInstagram: 'ইনস্টাগ্রামে দেখুন',
    videoNotAvailableEmbedded: 'এই ভিডিওটি অ্যাপের মধ্যে চালানো সম্ভব নয়',
    failedToLoad: 'ভিডিও লোড করা ব্যর্থ হয়েছে',
  ),
)
```

### Custom loading widget

```dart
UrlVideoPlayer(
  url: videoUrl,
  loadingWidget: Center(
    child: CircularProgressIndicator(color: Colors.red),
  ),
)
```

### Detect video type manually

```dart
import 'package:url_video_player/url_video_player.dart';

final VideoType type = UrlVideoUrlDetector.detect(url);
// VideoType.youtube | VideoType.facebook | VideoType.instagram | VideoType.direct
```

### Embed without an AppBar

```dart
UrlVideoPlayer(
  url: videoUrl,
  showAppBar: false,
)
```

---

## API reference

### `UrlVideoPlayer`

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `url` | `String` | required | The video URL |
| `title` | `String` | `''` | AppBar title |
| `showAppBar` | `bool` | `true` | Show/hide the AppBar |
| `backgroundColor` | `Color` | `Colors.black` | Player background colour |
| `labels` | `UrlVideoPlayerLabels` | English defaults | Customise all text strings |
| `loadingWidget` | `Widget?` | shimmer skeleton | Override the loading state |

### `UrlVideoPlayerLabels`

| Field | Default |
|-------|---------|
| `watchOnYouTube` | `'Watch on YouTube'` |
| `watchOnFacebook` | `'Watch on Facebook'` |
| `watchOnInstagram` | `'Watch on Instagram'` |
| `videoNotAvailableEmbedded` | `'This video cannot be played in-app'` |
| `failedToLoad` | `'Failed to load video'` |

---

## Contributing

Issues and pull requests are welcome at
[github.com/syedsabbir-git/url_video_player](https://github.com/syedsabbir-git/url_video_player).
