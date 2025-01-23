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
  Future<void> loadVideo(int playerId, int videoId, int viewId, String playerReference) async {
    try {
      await methodChannel.invokeMethod('loadVideo', {
        'playerId': playerId,
        'videoId': videoId,
        'viewId': viewId,
        'playerReference': playerReference,
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
      await methodChannel.invokeMethod('pauseVideo', {'playerReference': playerReference});
    } on PlatformException catch (e) {
      debugPrint('Failed to load playlist: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> playVideo(String playerReference) async {
    try {
      await methodChannel.invokeMethod('playVideo', {'playerReference': playerReference});
    } on PlatformException catch (e) {
      debugPrint('Failed to play video: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> previous(String playerReference) async {
    try {
      await methodChannel.invokeMethod('previous', {'playerReference': playerReference});
    } on PlatformException catch (e) {
      debugPrint('Failed to play previous video: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> next(String playerReference) async {
    try {
      await methodChannel.invokeMethod('next', {'playerReference': playerReference});
    } on PlatformException catch (e) {
      debugPrint('Failed to play next video: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> mute(String playerReference) async {
    try {
      await methodChannel.invokeMethod('mute', {'playerReference': playerReference});
    } on PlatformException catch (e) {
      debugPrint('Failed to mute video: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> unMute(String playerReference) async {
    try {
      await methodChannel.invokeMethod('unMute', {'playerReference': playerReference});
    } on PlatformException catch (e) {
      debugPrint('Failed to unmute video: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> setFullscreen(bool fullscreen, String playerReference) async {
    try {
      await methodChannel.invokeMethod('setFullscreen', {'fullscreen': fullscreen});
    } on PlatformException catch (e) {
      debugPrint('Failed to set fullscreen: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> showControls(String playerReference) async {
    try {
      await methodChannel.invokeMethod('showControls', {'playerReference': playerReference});
    } on PlatformException catch (e) {
      debugPrint('Failed to show controls: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> hideControls(String playerReference) async {
    try {
      await methodChannel.invokeMethod('hideControls', {'playerReference': playerReference});
    } on PlatformException catch (e) {
      debugPrint('Failed to hide controls: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<bool?> isAdPlaying(String playerReference) async {
    try {
      return await methodChannel.invokeMethod<bool>('isAdPlaying', {'playerReference': playerReference});
    } on PlatformException catch (e) {
      debugPrint('Failed to check if ad is playing: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<num?> getPlayerCurrentTime(String playerReference) async {
    try {
      return await methodChannel.invokeMethod<num>('getPlayerCurrentTime', {'playerReference': playerReference});
    } on PlatformException catch (e) {
      debugPrint('Failed to get player current time: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<num?> getAdDuration(String playerReference) async {
    try {
      return await methodChannel.invokeMethod<num>('getAdDuration', {'playerReference': playerReference});
    } on PlatformException catch (e) {
      debugPrint('Failed to get ad duration: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<num?> getVideoDuration(String playerReference) async {
    try {
      return await methodChannel.invokeMethod<num>('getVideoDuration', {'playerReference': playerReference});
    } on PlatformException catch (e) {
      debugPrint('Failed to get video duration: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<bool?> isPaused(String playerReference) async {
    try {
      return await methodChannel.invokeMethod<bool>('isPaused', {'playerReference': playerReference});
    } on PlatformException catch (e) {
      debugPrint('Failed to check if video is paused: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<bool?> isRepeated(String playerReference) async {
    try {
      return await methodChannel.invokeMethod<bool>('isRepeated', {'playerReference': playerReference});
    } on PlatformException catch (e) {
      debugPrint('Failed to check if video is repeated: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> destroyPlayer(String playerReference) async {
    try {
      await methodChannel.invokeMethod('destroyPlayer', {'playerReference': playerReference});
    } on PlatformException catch (e) {
      debugPrint('Failed to destroy player: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<bool?> isAutoplay(String playerReference) async {
    try {
      return await methodChannel.invokeMethod<bool>('isAutoplay', {'playerReference': playerReference});
    } on PlatformException catch (e) {
      debugPrint('Failed to check autoplay: ${e.message}');
      rethrow;
    }
  }
}
