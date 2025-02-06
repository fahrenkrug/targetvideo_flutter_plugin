import 'targetvideo_flutter_plugin_platform_interface.dart';

class TargetVideoPlayer {
  final String playerReference;
  final bool? controlAutoplay;
  final bool? scrollOnAd;
  final String? creditsLabelColor;
  final int? setCornerRadius;
  final String? localization;
  final int? doubleTapSeek;
  final int? seekPreview;

  // Constructor with nullable optional parameters
  TargetVideoPlayer({
    required this.playerReference,
    this.controlAutoplay,
    this.scrollOnAd,
    this.creditsLabelColor,
    this.setCornerRadius,
    this.localization,
    this.doubleTapSeek,
    this.seekPreview,
  });

  // Player methods
  Future<void> load({required int playerId, required int mediaId, required String typeOfPlayer, required int viewId}) async {
    await TargetvideoFlutterPluginPlatform.instance.load(
        playerId,
        mediaId,
        typeOfPlayer,
        controlAutoplay,
        scrollOnAd,
        creditsLabelColor,
        setCornerRadius,
        localization,
        doubleTapSeek,
        seekPreview,
        viewId,
        playerReference);
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
      if (event['playerReference'] == playerReference) {
        onEvent(event);
      }
    });
  }

  Stream<Map<String, dynamic>> get _playerEvents {
    return TargetvideoFlutterPluginPlatform.instance.playerEvents;
  }
}