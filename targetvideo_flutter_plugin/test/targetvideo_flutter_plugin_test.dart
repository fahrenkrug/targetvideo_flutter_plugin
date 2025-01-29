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
  Future<void> createPlayer(String playerReference) {
    throw UnimplementedError();
  }

  @override
  Future<void> loadVideo(int playerId, int videoId, int viewId, String playerReference) {
    // TODO: implement loadVideo
    throw UnimplementedError();
  }

  @override
  Future<void> loadPlaylist(int playerId, int playlistId, int viewId, String playerReference) {
    // TODO: implement loadVideo
    throw UnimplementedError();
  }

  @override
  Future<void> pauseVideo(String playerReference) {
    throw UnimplementedError();
  }

  @override
  Future<void> playVideo(String playerReference) {
    // TODO: implement playVideo
    throw UnimplementedError();
  }

  @override
  Future<void> previous(String playerReference) {
    // TODO: implement previous
    throw UnimplementedError();
  }

  @override
  Future<void> next(String playerReference) {
    // TODO: implement next
    throw UnimplementedError();
  }

  @override
  Future<void> mute(String playerReference) {
    // TODO: implement mute
    throw UnimplementedError();
  }

  @override
  Future<void> unMute(String playerReference) {
    // TODO: implement unMute
    throw UnimplementedError();
  }

  @override
  Future<void> setFullscreen(bool fullscreen, String playerReference) {
    // TODO: implement setFullscreen
    throw UnimplementedError();
  }

  @override
  Future<void> showControls(String playerReference) {
    // TODO: implement showControls
    throw UnimplementedError();
  }

  @override
  Future<void> hideControls(String playerReference) {
    // TODO: implement hideControls
    throw UnimplementedError();
  }

  @override
  Future<bool> isAdPlaying(String playerReference) async {
    // TODO: implement isAdPlaying
    throw UnimplementedError();
  }

  @override
  Future<int?> getPlayerCurrentTime(String playerReference) async {
    // TODO: implement getPlayerCurrentTime
    throw UnimplementedError();
  }

  @override
  Future<int?> getAdDuration(String playerReference) async {
    // TODO: implement getAdDuration
    throw UnimplementedError();
  }

  @override
  Future<int?> getVideoDuration(String playerReference) async {
    // TODO: implement getVideoDuration
    throw UnimplementedError();
  }

  @override
  Future<bool> isPaused(String playerReference) async {
    // TODO: implement isPaused
    throw UnimplementedError();
  }

  @override
  Future<bool> isRepeated(String playerReference) async {
    // TODO: implement isRepeated
    throw UnimplementedError();
  }

  @override
  Future<void> destroyPlayer(String playerReference) {
    // TODO: implement destroyPlayer
    throw UnimplementedError();
  }

  @override
  Future<bool> isAutoplay(String playerReference) async {
    // TODO: implement isAutoplay
    throw UnimplementedError();
  }

  @override
  Stream<Map<String, dynamic>> get playerEvents {
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
