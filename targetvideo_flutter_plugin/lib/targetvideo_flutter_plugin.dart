
import 'targetvideo_flutter_plugin_platform_interface.dart';

class TargetvideoFlutterPlugin {
  Future<String?> getPlatformVersion() {
    return TargetvideoFlutterPluginPlatform.instance.getPlatformVersion();
  }

  static Future<void> createPlayer(String playerReference) async {
    await TargetvideoFlutterPluginPlatform.instance.createPlayer(playerReference);
  }

  static Future<void> loadVideo(int playerId, int videoId, int viewId) async {
    await TargetvideoFlutterPluginPlatform.instance.loadVideo(playerId, videoId, viewId);
  }

  static Future<void> loadPlaylist(int playerId, int playlistId, int viewId, String playerReference) async {
    await TargetvideoFlutterPluginPlatform.instance.loadPlaylist(playerId, playlistId, viewId, playerReference);
  }

  static Future<void> pauseVideo(String playerReference) async {
    await TargetvideoFlutterPluginPlatform.instance.pauseVideo(playerReference);
  }

  static Future<void> playVideo() async {
    await TargetvideoFlutterPluginPlatform.instance.playVideo();
  }

  static Future<void> previous() async {
    await TargetvideoFlutterPluginPlatform.instance.previous();
  }

  static Future<void> next() async {
    await TargetvideoFlutterPluginPlatform.instance.next();
  }

  static Future<void> mute() async {
    await TargetvideoFlutterPluginPlatform.instance.mute();
  }

  static Future<void> unMute() async {
    await TargetvideoFlutterPluginPlatform.instance.unMute();
  }

  static Future<void> setFullscreen(bool fullscreen) async {
    await TargetvideoFlutterPluginPlatform.instance.setFullscreen(fullscreen);
  }

  static Future<void> showControls() async {
    await TargetvideoFlutterPluginPlatform.instance.showControls();
  }

  static Future<void> hideControls() async {
    await TargetvideoFlutterPluginPlatform.instance.hideControls();
  }

  static Future<bool> isAdPlaying() async {
    return await TargetvideoFlutterPluginPlatform.instance.isAdPlaying();
  }

  static Future<num?> getPlayerCurrentTime() async {
    return await TargetvideoFlutterPluginPlatform.instance.getPlayerCurrentTime();
  }

  static Future<num?> getAdDuration() async {
    return await TargetvideoFlutterPluginPlatform.instance.getAdDuration();
  }

  static Future<num?> getVideoDuration() async {
    return await TargetvideoFlutterPluginPlatform.instance.getVideoDuration();
  }

  static Future<bool> isPaused() async {
    return await TargetvideoFlutterPluginPlatform.instance.isPaused();
  }

  static Future<bool> isRepeated() async {
    return await TargetvideoFlutterPluginPlatform.instance.isRepeated();
  }

  static Future<void> destroyPlayer() async {
    await TargetvideoFlutterPluginPlatform.instance.destroyPlayer();
  }

  static Future<bool> isAutoplay() async {
    return await TargetvideoFlutterPluginPlatform.instance.isAutoplay();
  }
}
