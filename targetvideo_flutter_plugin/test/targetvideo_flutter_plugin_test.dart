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
  Future<void> loadVideo(int playerId, int videoId, int viewId) {
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
  Future<void> playVideo() {
    // TODO: implement playVideo
    throw UnimplementedError();
  }

  @override
  Future<void> previous() {
    // TODO: implement previous
    throw UnimplementedError();
  }

  @override
  Future<void> next() {
    // TODO: implement next
    throw UnimplementedError();
  }

  @override
  Future<void> mute() {
    // TODO: implement mute
    throw UnimplementedError();
  }

  @override
  Future<void> unMute() {
    // TODO: implement unMute
    throw UnimplementedError();
  }

  @override
  Future<void> setFullscreen(bool fullscreen) {
    // TODO: implement setFullscreen
    throw UnimplementedError();
  }

  @override
  Future<void> showControls() {
    // TODO: implement showControls
    throw UnimplementedError();
  }

  @override
  Future<void> hideControls() {
    // TODO: implement hideControls
    throw UnimplementedError();
  }

  @override
  Future<bool> isAdPlaying() async {
    // TODO: implement isAdPlaying
    throw UnimplementedError();
  }

  @override
  Future<int?> getPlayerCurrentTime() async {
    // TODO: implement getPlayerCurrentTime
    throw UnimplementedError();
  }

  @override
  Future<int?> getAdDuration() async {
    // TODO: implement getAdDuration
    throw UnimplementedError();
  }

  @override
  Future<int?> getVideoDuration() async {
    // TODO: implement getVideoDuration
    throw UnimplementedError();
  }

  @override
  Future<bool> isPaused() async {
    // TODO: implement isPaused
    throw UnimplementedError();
  }

  @override
  Future<bool> isRepeated() async {
    // TODO: implement isRepeated
    throw UnimplementedError();
  }

  @override
  Future<void> destroyPlayer() {
    // TODO: implement destroyPlayer
    throw UnimplementedError();
  }

  @override
  Future<bool> isAutoplay() async {
    // TODO: implement isAutoplay
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
