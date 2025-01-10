
import 'targetvideo_flutter_plugin_platform_interface.dart';

class TargetvideoFlutterPlugin {
  Future<String?> getPlatformVersion() {
    return TargetvideoFlutterPluginPlatform.instance.getPlatformVersion();
  }
}
