import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'targetvideo_flutter_plugin_method_channel.dart';

abstract class TargetvideoFlutterPluginPlatform extends PlatformInterface {
  /// Constructs a TargetvideoFlutterPluginPlatform.
  TargetvideoFlutterPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static TargetvideoFlutterPluginPlatform _instance = MethodChannelTargetvideoFlutterPlugin();

  /// The default instance of [TargetvideoFlutterPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelTargetvideoFlutterPlugin].
  static TargetvideoFlutterPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TargetvideoFlutterPluginPlatform] when
  /// they register themselves.
  static set instance(TargetvideoFlutterPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> createPlayer(String playerReference) {
    throw UnimplementedError('createPlayer() has not been implemented');
  }

  Future<void> loadVideo(int playerId, int videoId, int viewId, String playerReference) {
    throw UnimplementedError('loadVideo() has not been implemented.');
  }

  Future<void> loadPlaylist(int playerId, int playlistId, int viewId, String playerReference) {
    throw UnimplementedError('loadPlaylist() has not been implemented.');
  }

  Future<void> pauseVideo(String playerReference) {
    throw UnimplementedError('pauseVideo() has not been implemented');
  }

  Future<void> playVideo(String playerReference) {
    throw UnimplementedError('playVideo() has not been implemented.');
  }

  Future<void> previous(String playerReference) {
    throw UnimplementedError('previous() has not been implemented.');
  }

  Future<void> next(String playerReference) {
    throw UnimplementedError('next() has not been implemented.');
  }

  Future<void> mute(String playerReference) {
    throw UnimplementedError('mute() has not been implemented.');
  }

  Future<void> unMute(String playerReference) {
    throw UnimplementedError('unMute() has not been implemented.');
  }

  Future<void> setFullscreen(bool fullscreen, String playerReference) {
    throw UnimplementedError('setFullscreen() has not been implemented.');
  }

  Future<void> showControls(String playerReference) {
    throw UnimplementedError('showControls() has not been implemented.');
  }

  Future<void> hideControls(String playerReference) {
    throw UnimplementedError('hideControls() has not been implemented.');
  }

  Future<bool?> isAdPlaying(String playerReference) {
    throw UnimplementedError('isAdPlaying() has not been implemented.');
  }

  Future<num?> getPlayerCurrentTime(String playerReference) {
    throw UnimplementedError('getPlayerCurrentTime() has not been implemented.');
  }

  Future<num?> getAdDuration(String playerReference) {
    throw UnimplementedError('getAdDuration() has not been implemented.');
  }

  Future<num?> getVideoDuration(String playerReference) {
    throw UnimplementedError('getVideoDuration() has not been implemented.');
  }

  Future<bool?> isPaused(String playerReference) {
    throw UnimplementedError('isPaused() has not been implemented.');
  }

  Future<bool?> isRepeated(String playerReference) {
    throw UnimplementedError('isRepeated() has not been implemented.');
  }

  Future<void> destroyPlayer(String playerReference) {
    throw UnimplementedError('destroyPlayer() has not been implemented.');
  }

  Future<bool?> isAutoplay(String playerReference) {
    throw UnimplementedError('isAutoplay() has not been implemented.');
  }

  Stream<Map<String, dynamic>> get playerEvents {
    throw UnimplementedError('events has not been implemented.');
  }
}
