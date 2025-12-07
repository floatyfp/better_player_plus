## Picture in Picture configuration
Picture in Picture is not supported on all devices.

Requirements:
* iOS: iOS version greater than 14.0
* Android: Android version greater than 8.0, enough RAM, v2 Flutter android embedding

Each OS provides method to check if given device supports PiP. If device doesn't support PiP, then
error will be printed in console.

Check if PiP is supported in given device:
```dart
_betterPlayerController.isPictureInPictureSupported();
```

To show PiP mode call this method:

```dart
_betterPlayerController.enablePictureInPicture(_betterPlayerKey);
```
`_betterPlayerKey` is a key which is used in BetterPlayer widget:

```dart
GlobalKey _betterPlayerKey = GlobalKey();
...
    AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer(
            controller: _betterPlayerController,
            key: _betterPlayerKey,
        ),
    ),
```

To hide PiP mode call this method:
```dart
betterPlayerController.disablePictureInPicture();
```

## Automatic Picture in Picture

Automatic PiP allows the video to automatically enter Picture in Picture mode when the app goes to
the background (e.g., when the user presses the home button or switches apps).

Requirements:
* iOS: iOS 14.2 or higher
* Android: Android 12 (API 31) or higher

Check if automatic PiP is supported:
```dart
bool isSupported = await _betterPlayerController.isAutomaticPictureInPictureSupported();
```

### Android Setup

For automatic PiP to work properly on Android, you need to override `onPictureInPictureModeChanged` 
in your MainActivity. This ensures the player properly detects and responds to PiP state changes.

Update your `MainActivity.kt`:

```kotlin
package your.package.name

import android.content.res.Configuration
import io.flutter.embedding.android.FlutterActivity
import uz.shs.better_player_plus.BetterPlayerPlugin

class MainActivity : FlutterActivity() {
    override fun onPictureInPictureModeChanged(active: Boolean, newConfig: Configuration) {
        super.onPictureInPictureModeChanged(active, newConfig)
        BetterPlayerPlugin.onPictureInPictureModeChanged(active)
    }
}
```

**Important**: Without this override, the player will not properly handle returning from PiP mode, 
and may remain in fullscreen mode when you return to the app. This affects both manual and automatic PiP.

### Enable via Configuration

You can enable automatic PiP via the `BetterPlayerConfiguration`:

```dart
BetterPlayerController(
  BetterPlayerConfiguration(
    automaticallyEnterPictureInPicture: true,
    // ... other config
  ),
);
```

### Enable/Disable at Runtime

You can also enable or disable automatic PiP at runtime:

```dart
// Enable automatic PiP
_betterPlayerController.setAutomaticPictureInPictureEnabled(true);

// Disable automatic PiP
_betterPlayerController.setAutomaticPictureInPictureEnabled(false);
```

### Best Practices

Always check if automatic PiP is supported before enabling it:

```dart
if (await _betterPlayerController.isAutomaticPictureInPictureSupported()) {
  _betterPlayerController.setAutomaticPictureInPictureEnabled(true);
} else {
  // Show a message or use manual PiP instead
  print('Automatic PiP is not supported on this device');
}
```

## Controls Configuration

PiP menu item is enabled as default in both Material and Cupertino controls. You can disable it with
`BetterPlayerControlsConfiguration`'s variable: `enablePip`. You can change PiP control menu icon with
`pipMenuIcon` variable in `BetterPlayerControlsConfiguration`.

Warning:
Both Android and iOS PiP versions are in very early stage. There can be bugs and small issues. Please
make sure that you've checked state of the PiP in Better Player before moving it to the production.

Known limitations:
Android: When PiP is enabled, Better Player will open full screen mode to play video correctly. When
user disables PiP, Better Player will back to the previous settings and for a half of second your device
will have incorrect orientation.