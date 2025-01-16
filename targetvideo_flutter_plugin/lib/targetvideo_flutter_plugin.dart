
import 'targetvideo_flutter_plugin_platform_interface.dart';

class TargetvideoFlutterPlugin {
  Future<String?> getPlatformVersion() {
    return TargetvideoFlutterPluginPlatform.instance.getPlatformVersion();
  }

  static Future<void> loadVideo(int playerId, int videoId, int viewId) async {
    await TargetvideoFlutterPluginPlatform.instance.loadVideo(playerId, videoId, viewId);
  }
}
