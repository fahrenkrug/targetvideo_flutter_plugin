# TargetVideo flutter plugin

A new Flutter plugin for video reproduction using native BridSDK for iOS and Android.

### What is this repository for? ###

* This SDK aims at easily playing videos with or without ads in your Flutter application. Apps built with this SDK integrate with video hosting, streaming, and analytics services.

### How do I get set up? ###

* Add 'targetvideo_flutter_plugin: ^x.x.x' to your pubspec.yaml file and run flutter pub get.
* Add a version field to your pubspec.yaml (e.g., `version: 1.0.0+1`) to avoid build warnings.
* import 'package:targetvideo_flutter_plugin/targetvideo_player.dart'; in your class and start using our plugin.
* We provide custom platform view you can use for easy testing, import 'package:targetvideo_flutter_plugin/targetvideo_player_platform_view.dart'; to use it.
* It is necessary to add NSUserTrackingUsageDescription to your app info.plist file.
* Create a player with its player reference: 'final TargetVideoPlayer _player = TargetVideoPlayer(playerReference: "playerName")'
* Call 'load' player method to start a video reproduction in your view.

### iOS Setup Requirements ###

The plugin depends on BridSDK, which requires specific runtime dependencies. Your iOS Podfile must be configured correctly:

**1. Use Dynamic Frameworks**

Your `ios/Podfile` must use dynamic frameworks (not static). Configure it like this:

```ruby
platform :ios, '15.0'

target 'Runner' do
  use_frameworks!  # Dynamic frameworks (do NOT use :linkage => :static)
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end
end
```

**2. Required Dependencies**

The plugin automatically includes these dependencies via podspec:
- `BridSDK` - Video player framework
- `google-cast-sdk` - Google Cast support
- `PrebidMobile` - Ad bidding framework
- `BridSDKDynamicProtobuf` - Protocol buffers support

These will be installed automatically when you run `flutter pub get` or `pod install`.

**3. Clean Build if Switching from Static to Dynamic**

If you previously had static framework linkage configured:

```bash
flutter clean
rm -rf ios/Pods ios/Podfile.lock
flutter pub get
flutter build ios
```

**Note:** BridSDK is a pre-built dynamic framework that requires PrebidMobile and Protobuf to be available as dynamic frameworks at runtime. This is why static linkage is not supported.

### Player Methods ###

* play(): void: Plays the video.
* pause(): void: Pauses the video.
* previous(): void: Plays the previous video in the playlist.
* next(): void: Plays the next video in the playlist.
* mute(): void: Mutes the video.
* unMute(): void: Unmutes the video.
* load(playerID: number, mediaID: number): void: Loads a video with the specified playerID and mediaID from BridTv CMS.
* setFullscreen(fullscreen: boolean): void: Sets the fullscreen mode of the player. Pass true to enter fullscreen mode or false to exit fullscreen mode.
* showControls(): void: Enable the video controls.
* hideControls(): void: Disable the video controls.
* isPlayingAd(): Promise* Checks if an ad is currently playing.
* getPlayerCurrentTime(): Promise<number | null>: Retrieves the current playback time of the player in milliseconds. Returns a promise that resolves with the current time or null if the player is not loaded.
* getAdDuration(): Promise<number | null>: Retrieves the duration of the currently playing ad in milliseconds. Returns a promise that resolves with the ad duration or null if no ad is playing.
* getVideoDuration(): Promise<number | null>: Retrieves the duration of the currently loaded video in milliseconds. Returns a promise that resolves with the video duration or null if no video is loaded.
* isPaused(): Promise: Checks if the video is currently paused.
* isRepeated(): Promise: Checks if the video is already repeated.
* destroyPlayer(): void: Destroys the native player instance and cleans up any resources associated with it.
* isAutoplay(): Promise: Method is used to check if the current video is set to autoplay.
* handleAllPlayerEvents(Function(dynamic event): Listen for player events, ['events'] for player events or ['ad'] for Ad events.


