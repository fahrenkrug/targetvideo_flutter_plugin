import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:targetvideo_flutter_plugin/targetvideo_player.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('TargetVideo Flutter Plugin')),
        body: const NativeVideoWidget(),
      ),
    );
  }
}

class NativeVideoWidget extends StatefulWidget {
  const NativeVideoWidget({super.key});

  @override
  State<NativeVideoWidget> createState() => _NativeVideoWidgetState();
}

class _NativeVideoWidgetState extends State<NativeVideoWidget> {
  int? _viewId1;
  int? _viewId2;
  final TargetVideoPlayer _player1 = TargetVideoPlayer(playerReference: "player1");
  final TargetVideoPlayer _player2 = TargetVideoPlayer(playerReference: "player2");

  static const _playerSize = Size(320, 180);

  @override
  void initState() {
    super.initState();
    _player1.handleAllPlayerEvents((event) => print(event));
    _player2.handleAllPlayerEvents((event) => print(event));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildVideoPlayer1(),
          const SizedBox(height: 16),
          _buildVideoPlayer2(),
          const SizedBox(height: 16),
          _buildControlButtons(),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer1() {
    return PlatformVideoView(
      onCreated: (id) => setState(() => _viewId1 = id),
    );
  }

  Widget _buildVideoPlayer2() {
    return PlatformVideoView(
      onCreated: (id) => setState(() => _viewId2 = id),
    );
  }

  Widget _buildControlButtons() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.center,
      children: [
        PlayerControlButton(
          label: 'Load Video 1',
          onPressed: () => _loadVideo(_player1, _viewId1, localization: "it", doubleTapSeek: 11),
        ),
        PlayerControlButton(
          label: 'Load Video 2',
          onPressed: () => _loadVideo(_player2, _viewId2),
        ),
        PlayerControlButton(
          label: 'Play/Pause 1',
          onPressed: () => _togglePlayPause(_player1),
        ),
        PlayerControlButton(
          label: 'Play/Pause 2',
          onPressed: () => _togglePlayPause(_player2),
        ),
      ],
    );
  }

  Future<void> _loadVideo(TargetVideoPlayer player, int? viewId, {String? localization, int? doubleTapSeek}) async {
    if (viewId == null) return;

    try {
      await player.load(
        playerId: 45852,
        mediaId: 24090,
        typeOfPlayer: "Playlist",
        viewId: viewId,
        localization: localization,
        doubleTapSeek: doubleTapSeek,
      );
    } on PlatformException catch (e) {
      print('Error loading video: ${e.message}');
    }
  }

  Future<void> _togglePlayPause(TargetVideoPlayer player) async {
    try {
      final isPaused = await player.isPaused();
      isPaused == true ? player.playVideo() : player.pauseVideo();
    } on PlatformException catch (e) {
      print('Error toggling play/pause: ${e.message}');
    }
  }
}

class PlatformVideoView extends StatelessWidget {
  final ValueChanged<int>? onCreated;

  const PlatformVideoView({
    super.key,
    this.onCreated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _NativeVideoWidgetState._playerSize.width,
      height: _NativeVideoWidgetState._playerSize.height,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Platform.isIOS
          ? UiKitView(
        viewType: 'targetvideo/player_video_view',
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: onCreated,
      )
          : AndroidView(
        viewType: 'targetvideo/player_video_view',
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: onCreated,
      ),
    );
  }
}

class PlayerControlButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PlayerControlButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}