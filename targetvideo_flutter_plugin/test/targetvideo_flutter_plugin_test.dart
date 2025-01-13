import 'package:flutter_test/flutter_test.dart';
import 'package:targetvideo_flutter_plugin/targetvideo_flutter_plugin.dart';
import 'package:targetvideo_flutter_plugin/targetvideo_flutter_plugin_platform_interface.dart';
import 'package:targetvideo_flutter_plugin/targetvideo_flutter_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTargetvideoFlutterPluginPlatform
    with MockPlatformInterfaceMixin
    implements TargetvideoFlutterPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> loadVideo(int playerId, int videoId) {
    // TODO: implement loadVideo
    throw UnimplementedError();
  }
}

void main() {
  final TargetvideoFlutterPluginPlatform initialPlatform = TargetvideoFlutterPluginPlatform.instance;

  test('$MethodChannelTargetvideoFlutterPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTargetvideoFlutterPlugin>());
  });

  test('getPlatformVersion', () async {
    TargetvideoFlutterPlugin targetvideoFlutterPlugin = TargetvideoFlutterPlugin();
    MockTargetvideoFlutterPluginPlatform fakePlatform = MockTargetvideoFlutterPluginPlatform();
    TargetvideoFlutterPluginPlatform.instance = fakePlatform;

    expect(await targetvideoFlutterPlugin.getPlatformVersion(), '42');
  });
}
