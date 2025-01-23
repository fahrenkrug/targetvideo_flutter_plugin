import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'targetvideo_flutter_plugin_platform_interface.dart';

/// An implementation of [TargetvideoFlutterPluginPlatform] that uses method channels.
class MethodChannelTargetvideoFlutterPlugin
    extends TargetvideoFlutterPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('targetvideo_flutter_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> createPlayer(String playerReference) async {
    try {
      await methodChannel.invokeMethod('createPlayer', {
        'playerReference': playerReference,
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to create player: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> loadVideo(int playerId, int videoId, int viewId) async {
    try {
      await methodChannel.invokeMethod('loadVideo', {
        'playerId': playerId,
        'videoId': videoId,
        'viewId': viewId,
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to load video: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> loadPlaylist(int playerId, int playlistId, int viewId, String playerReference) async {
    try {
      await methodChannel.invokeMethod('loadPlaylist', {
        'playerId': playerId,
        'playlistId': playlistId,
        'viewId': viewId,
        'playerReference': playerReference,
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to load playlist: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> pauseVideo(String playerReference) async {
    try {
      await methodChannel.invokeMethod('pauseVideo', {
        'playerReference': playerReference,
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to load playlist: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> playVideo() async {
    try {
      await methodChannel.invokeMethod('playVideo');
    } on PlatformException catch (e) {
      debugPrint('Failed to play video: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> previous() async {
    try {
      await methodChannel.invokeMethod('previous');
    } on PlatformException catch (e) {
      debugPrint('Failed to play previous video: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> next() async {
    try {
      await methodChannel.invokeMethod('next');
    } on PlatformException catch (e) {
      debugPrint('Failed to play next video: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> mute() async {
    try {
      await methodChannel.invokeMethod('mute');
    } on PlatformException catch (e) {
      debugPrint('Failed to mute video: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> unMute() async {
    try {
      await methodChannel.invokeMethod('unMute');
    } on PlatformException catch (e) {
      debugPrint('Failed to unmute video: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> setFullscreen(bool fullscreen) async {
    try {
      await methodChannel.invokeMethod('setFullscreen', {'fullscreen': fullscreen});
    } on PlatformException catch (e) {
      debugPrint('Failed to set fullscreen: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> showControls() async {
    try {
      await methodChannel.invokeMethod('showControls');
    } on PlatformException catch (e) {
      debugPrint('Failed to show controls: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> hideControls() async {
    try {
      await methodChannel.invokeMethod('hideControls');
    } on PlatformException catch (e) {
      debugPrint('Failed to hide controls: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<bool> isAdPlaying() async {
    try {
      return await methodChannel.invokeMethod<bool>('isAdPlaying') ?? false;
    } on PlatformException catch (e) {
      debugPrint('Failed to check if ad is playing: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<num?> getPlayerCurrentTime() async {
    try {
      return await methodChannel.invokeMethod<num>('getPlayerCurrentTime');
    } on PlatformException catch (e) {
      debugPrint('Failed to get player current time: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<num?> getAdDuration() async {
    try {
      return await methodChannel.invokeMethod<num>('getAdDuration');
    } on PlatformException catch (e) {
      debugPrint('Failed to get ad duration: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<num?> getVideoDuration() async {
    try {
      return await methodChannel.invokeMethod<num>('getVideoDuration');
    } on PlatformException catch (e) {
      debugPrint('Failed to get video duration: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<bool> isPaused() async {
    try {
      return await methodChannel.invokeMethod<bool>('isPaused') ?? false;
    } on PlatformException catch (e) {
      debugPrint('Failed to check if video is paused: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<bool> isRepeated() async {
    try {
      return await methodChannel.invokeMethod<bool>('isRepeated') ?? false;
    } on PlatformException catch (e) {
      debugPrint('Failed to check if video is repeated: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> destroyPlayer() async {
    try {
      await methodChannel.invokeMethod('destroyPlayer');
    } on PlatformException catch (e) {
      debugPrint('Failed to destroy player: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<bool> isAutoplay() async {
    try {
      return await methodChannel.invokeMethod<bool>('isAutoplay') ?? false;
    } on PlatformException catch (e) {
      debugPrint('Failed to check autoplay: ${e.message}');
      rethrow;
    }
  }
}
