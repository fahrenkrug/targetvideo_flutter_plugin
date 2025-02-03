import 'targetvideo_flutter_plugin_platform_interface.dart';

class TargetVideoPlayer {
  final String playerReference;

  // Constructor
  TargetVideoPlayer({
    required this.playerReference
  });

  // Player methods
  Future<void> loadVideo(int playerId, int videoId, int viewId) async {
    await TargetvideoFlutterPluginPlatform.instance.loadVideo(playerId, videoId, viewId, playerReference);
  }

  Future<void> loadPlaylist(int playerId, int playlistId, int viewId) async {
    await TargetvideoFlutterPluginPlatform.instance.loadPlaylist(playerId, playlistId, viewId, playerReference);
  }

  Future<void> pauseVideo() async {
    await TargetvideoFlutterPluginPlatform.instance.pauseVideo(playerReference);
  }

  Future<void> playVideo() async {
    await TargetvideoFlutterPluginPlatform.instance.playVideo(playerReference);
  }

  Future<void> previous() async {
    await TargetvideoFlutterPluginPlatform.instance.previous(playerReference);
  }

  Future<void> next() async {
    await TargetvideoFlutterPluginPlatform.instance.next(playerReference);
  }

  Future<void> mute() async {
    await TargetvideoFlutterPluginPlatform.instance.mute(playerReference);
  }

  Future<void> unMute() async {
    await TargetvideoFlutterPluginPlatform.instance.unMute(playerReference);
  }

  Future<void> setFullscreen(bool fullscreen) async {
    await TargetvideoFlutterPluginPlatform.instance.setFullscreen(fullscreen, playerReference);
  }

  Future<void> showControls() async {
    await TargetvideoFlutterPluginPlatform.instance.showControls(playerReference);
  }

  Future<void> hideControls() async {
    await TargetvideoFlutterPluginPlatform.instance.hideControls(playerReference);
  }

  Future<bool?> isAdPlaying() async {
    return await TargetvideoFlutterPluginPlatform.instance.isAdPlaying(playerReference);
  }

  Future<num?> getPlayerCurrentTime() async {
    return await TargetvideoFlutterPluginPlatform.instance.getPlayerCurrentTime(playerReference);
  }

  Future<num?> getAdDuration() async {
    return await TargetvideoFlutterPluginPlatform.instance.getAdDuration(playerReference);
  }

  Future<num?> getVideoDuration() async {
    return await TargetvideoFlutterPluginPlatform.instance.getVideoDuration(playerReference);
  }

  Future<bool?> isPaused() async {
    return await TargetvideoFlutterPluginPlatform.instance.isPaused(playerReference);
  }

  Future<bool?> isRepeated() async {
    return await TargetvideoFlutterPluginPlatform.instance.isRepeated(playerReference);
  }

  Future<void> destroyPlayer() async {
    await TargetvideoFlutterPluginPlatform.instance.destroyPlayer(playerReference);
  }

  Future<bool?> isAutoplay() async {
    return await TargetvideoFlutterPluginPlatform.instance.isAutoplay(playerReference);
  }

  void handleAllPlayerEvents(Function(dynamic event) onEvent) {
    _playerEvents.listen((event) {
      if (event['event'] is String) {
        onEvent(event);
      }
    });
  }

  Stream<Map<String, dynamic>> get _playerEvents {
    return TargetvideoFlutterPluginPlatform.instance.playerEvents;
  }
}