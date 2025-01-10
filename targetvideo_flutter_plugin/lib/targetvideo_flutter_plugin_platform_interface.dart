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
}
