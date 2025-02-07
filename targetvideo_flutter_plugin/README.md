# TargetVideo flutter plugin

A new Flutter plugin for video reproduction using native BridSDK for iOS and Android.

### What is this repository for? ###

* This SDK aims at easily playing videos with or without ads in your Flutter application. Apps built with this SDK integrate with video hosting, streaming, and analytics services.

### How do I get set up? ###

* Add 'targetvideo_flutter_plugin: ^0.0.1' to your pubspec.yaml file and run flutter pub get.
* import 'package:targetvideo_flutter_plugin/targetvideo_player.dart'; in your class and start using our plugin.
* We provide custom platform view you can use for easy testing, impor 'package:targetvideo_flutter_plugin/targetvideo_player_platform_view.dart'; to use it.
* It is necessary to add NSUserTrackingUsageDescription to your app info.plis file.
* Create a player with its player reference: 'final TargetVideoPlayer _player = TargetVideoPlayer(playerReference: "playerName")'
* Call 'load' player method to start a video reproduction in your view.

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


