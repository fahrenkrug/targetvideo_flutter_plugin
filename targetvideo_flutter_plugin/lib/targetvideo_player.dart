import 'targetvideo_flutter_plugin_platform_interface.dart';

class TargetVideoPlayer {
  final String playerReference;
  bool? _controlAutoplay;
  bool? _scrollOnAd;
  String? _creditsLabelColor;
  int? _setCornerRadius;
  String? _localization;
  int? _doubleTapSeek;
  int? _seekPreview;

  /// Constructor for creating a [TargetVideoPlayer] instance.
  /// All parameters except [playerReference] are optional and nullable.
  TargetVideoPlayer({
    required this.playerReference,
    bool? controlAutoplay,
    bool? scrollOnAd,
    String? creditsLabelColor,
    int? setCornerRadius,
    String? localization,
    int? doubleTapSeek,
    int? seekPreview,
  })  : _controlAutoplay = controlAutoplay,
        _scrollOnAd = scrollOnAd,
        _creditsLabelColor = creditsLabelColor,
        _setCornerRadius = setCornerRadius,
        _localization = localization,
        _doubleTapSeek = doubleTapSeek,
        _seekPreview = seekPreview;

  // Setters for private properties
  /// Sets the [controlAutoplay] property.
  /// This enables the client to take control over autoplay.
  set controlAutoplay(bool? value) {
    _controlAutoplay = value;
  }

  /// Sets the [scrollOnAd] property.
  /// This option enables scrolling during ad and is specific to the iOS platform. By default, Android has scrolling enabled during ads.
  set scrollOnAd(bool? value) {
    _scrollOnAd = value;
  }

  /// Sets the [creditsLabelColor] property.
  /// To achieve color modification for credits label, it is necessary to provide a sequence of six hexadecimal characters, excluding the '#' symbol.
  set creditsLabelColor(String? value) {
    _creditsLabelColor = value;
  }

  /// Sets the [setCornerRadius] property.
  /// This property enables setting the corner radius to the player itself. Its value is in pixels.
  set setCornerRadius(int? value) {
    _setCornerRadius = value;
  }

  /// Sets the [localization] property.
  /// This allows selecting the language in which the player and IMA will operate.
  set localization(String? value) {
    _localization = value;
  }

  /// Sets the [doubleTapSeek] property.
  /// This property set seek seconds for double tap seek player UI.
  set doubleTapSeek(int? value) {
    _doubleTapSeek = value;
  }

  /// Sets the [seekPreview] property.
  /// When set to 1, the feature is enabled and will be visible in all operational modes of the player. When set to 2 the thumbnail image preview during seeking will be available exclusively when the player is in fullscreen mode.
  set seekPreview(int? value) {
    _seekPreview = value;
  }

  /// Loads media into the player.
  ///
  /// - [playerId]: The unique ID of the player.
  /// - [mediaId]: The ID of the media to load.
  /// - [typeOfPlayer]: The type of player ("Single" or "Playlist").
  /// - [viewId]: The ID of the view where the player will be rendered.
  Future<void> load({
    required int playerId,
    required int mediaId,
    required String typeOfPlayer,
    required int viewId,
  }) async {
    await TargetvideoFlutterPluginPlatform.instance.load(
      playerId,
      mediaId,
      typeOfPlayer,
      _controlAutoplay,
      _scrollOnAd,
      _creditsLabelColor,
      _setCornerRadius,
      _localization,
      _doubleTapSeek,
      _seekPreview,
      viewId,
      playerReference,
    );
  }

  /// Pauses the currently playing video.
  Future<void> pauseVideo() async {
    await TargetvideoFlutterPluginPlatform.instance.pauseVideo(playerReference);
  }

  /// Resumes the paused video.
  Future<void> playVideo() async {
    await TargetvideoFlutterPluginPlatform.instance.playVideo(playerReference);
  }

  /// Skips to the previous media item in the playlist.
  Future<void> previous() async {
    await TargetvideoFlutterPluginPlatform.instance.previous(playerReference);
  }

  /// Skips to the next media item in the playlist.
  Future<void> next() async {
    await TargetvideoFlutterPluginPlatform.instance.next(playerReference);
  }

  /// Mutes the player's audio.
  Future<void> mute() async {
    await TargetvideoFlutterPluginPlatform.instance.mute(playerReference);
  }

  /// Unmutes the player's audio.
  Future<void> unMute() async {
    await TargetvideoFlutterPluginPlatform.instance.unMute(playerReference);
  }

  /// Toggles fullscreen mode for the player.
  ///
  /// - [fullscreen]: Whether to enable or disable fullscreen mode.
  Future<void> setFullscreen(bool fullscreen) async {
    await TargetvideoFlutterPluginPlatform.instance.setFullscreen(fullscreen, playerReference);
  }

  /// Displays the player's controls.
  Future<void> showControls() async {
    await TargetvideoFlutterPluginPlatform.instance.showControls(playerReference);
  }

  /// Hides the player's controls.
  Future<void> hideControls() async {
    await TargetvideoFlutterPluginPlatform.instance.hideControls(playerReference);
  }

  /// Checks if an ad is currently playing.
  ///
  /// Returns `true` if an ad is playing, otherwise `false`.
  Future<bool?> isAdPlaying() async {
    return await TargetvideoFlutterPluginPlatform.instance.isAdPlaying(playerReference);
  }

  /// Gets the current playback time of the player.
  ///
  /// Returns the current time in seconds.
  Future<num?> getPlayerCurrentTime() async {
    return await TargetvideoFlutterPluginPlatform.instance.getPlayerCurrentTime(playerReference);
  }

  /// Gets the duration of the currently playing ad.
  ///
  /// Returns the ad duration in seconds.
  Future<num?> getAdDuration() async {
    return await TargetvideoFlutterPluginPlatform.instance.getAdDuration(playerReference);
  }

  /// Gets the duration of the currently loaded video.
  ///
  /// Returns the video duration in seconds.
  Future<num?> getVideoDuration() async {
    return await TargetvideoFlutterPluginPlatform.instance.getVideoDuration(playerReference);
  }

  /// Checks if the player is currently paused.
  ///
  /// Returns `true` if the player is paused, otherwise `false`.
  Future<bool?> isPaused() async {
    return await TargetvideoFlutterPluginPlatform.instance.isPaused(playerReference);
  }

  /// Checks if the player is in repeat mode.
  ///
  /// Returns `true` if the player is repeating, otherwise `false`.
  Future<bool?> isRepeated() async {
    return await TargetvideoFlutterPluginPlatform.instance.isRepeated(playerReference);
  }

  /// Destroys the player instance and releases associated resources.
  Future<void> destroyPlayer() async {
    await TargetvideoFlutterPluginPlatform.instance.destroyPlayer(playerReference);
  }

  /// Checks if the player is in autoplay mode.
  ///
  /// Returns `true` if autoplay is enabled, otherwise `false`.
  Future<bool?> isAutoplay() async {
    return await TargetvideoFlutterPluginPlatform.instance.isAutoplay(playerReference);
  }

  /// Listens to all player events and triggers the provided [onEvent] callback
  /// Returns dictionary with ['playerReference'], ['type'] and ['event'] or ['ad'] keys.
  ///
  /// - [onEvent]: A callback function that handles the event.
  void handleAllPlayerEvents(Function(dynamic event) onEvent) {
    _playerEvents.listen((event) {
      if (event['playerReference'] == playerReference) {
        onEvent(event);
      }
    });
  }

  /// A stream of player events.
  ///
  /// This stream provides events such as playback state changes, ad events, etc.
  Stream<Map<String, dynamic>> get _playerEvents {
    return TargetvideoFlutterPluginPlatform.instance.playerEvents;
  }
}