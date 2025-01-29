
import 'targetvideo_flutter_plugin_platform_interface.dart';

class TargetvideoFlutterPlugin {
  Future<String?> getPlatformVersion() {
    return TargetvideoFlutterPluginPlatform.instance.getPlatformVersion();
  }

  static Future<void> createPlayer(String playerReference) async {
    await TargetvideoFlutterPluginPlatform.instance.createPlayer(playerReference);
  }

  static Future<void> loadVideo(int playerId, int videoId, int viewId, String playerReference) async {
    await TargetvideoFlutterPluginPlatform.instance.loadVideo(playerId, videoId, viewId, playerReference);
  }

  static Future<void> loadPlaylist(int playerId, int playlistId, int viewId, String playerReference) async {
    await TargetvideoFlutterPluginPlatform.instance.loadPlaylist(playerId, playlistId, viewId, playerReference);
  }

  static Future<void> pauseVideo(String playerReference) async {
    await TargetvideoFlutterPluginPlatform.instance.pauseVideo(playerReference);
  }

  static Future<void> playVideo(String playerReference) async {
    await TargetvideoFlutterPluginPlatform.instance.playVideo(playerReference);
  }

  static Future<void> previous(String playerReference) async {
    await TargetvideoFlutterPluginPlatform.instance.previous(playerReference);
  }

  static Future<void> next(String playerReference) async {
    await TargetvideoFlutterPluginPlatform.instance.next(playerReference);
  }

  static Future<void> mute(String playerReference) async {
    await TargetvideoFlutterPluginPlatform.instance.mute(playerReference);
  }

  static Future<void> unMute(String playerReference) async {
    await TargetvideoFlutterPluginPlatform.instance.unMute(playerReference);
  }

  static Future<void> setFullscreen(bool fullscreen, String playerReference) async {
    await TargetvideoFlutterPluginPlatform.instance.setFullscreen(fullscreen, playerReference);
  }

  static Future<void> showControls(String playerReference) async {
    await TargetvideoFlutterPluginPlatform.instance.showControls(playerReference);
  }

  static Future<void> hideControls(String playerReference) async {
    await TargetvideoFlutterPluginPlatform.instance.hideControls(playerReference);
  }

  static Future<bool?> isAdPlaying(String playerReference) async {
    return await TargetvideoFlutterPluginPlatform.instance.isAdPlaying(playerReference);
  }

  static Future<num?> getPlayerCurrentTime(String playerReference) async {
    return await TargetvideoFlutterPluginPlatform.instance.getPlayerCurrentTime(playerReference);
  }

  static Future<num?> getAdDuration(String playerReference) async {
    return await TargetvideoFlutterPluginPlatform.instance.getAdDuration(playerReference);
  }

  static Future<num?> getVideoDuration(String playerReference) async {
    return await TargetvideoFlutterPluginPlatform.instance.getVideoDuration(playerReference);
  }

  static Future<bool?> isPaused(String playerReference) async {
    return await TargetvideoFlutterPluginPlatform.instance.isPaused(playerReference);
  }

  static Future<bool?> isRepeated(String playerReference) async {
    return await TargetvideoFlutterPluginPlatform.instance.isRepeated(playerReference);
  }

  static Future<void> destroyPlayer(String playerReference) async {
    await TargetvideoFlutterPluginPlatform.instance.destroyPlayer(playerReference);
  }

  static Future<bool?> isAutoplay(String playerReference) async {
    return await TargetvideoFlutterPluginPlatform.instance.isAutoplay(playerReference);
  }

  static Stream<Map<String, dynamic>> get playerEvents {
    return TargetvideoFlutterPluginPlatform.instance.playerEvents;
  }
}
