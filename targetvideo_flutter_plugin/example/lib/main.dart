import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:targetvideo_flutter_plugin/targetvideo_player.dart';
import 'package:targetvideo_flutter_plugin/targetvideo_player_platform_view.dart';

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
  final TargetVideoPlayer _player1 = TargetVideoPlayer(playerReference: "player1", localization: "it");
  final TargetVideoPlayer _player2 = TargetVideoPlayer(playerReference: "player2");
  final List<String> _eventLogs = [];
  final ScrollController _scrollController = ScrollController();
  static const _playerSize = Size(320, 180);

  @override
  void initState() {
    super.initState();
    _player1.handleAllPlayerEvents((event) {
      String? playerEvent = event['event'];
      if (playerEvent != null) {
        if (event['event'] == 'playerVideoLoad') {
          /// Handle playerVideoLoad event
          print("Video Loaded");
        }
        setState(() {
          _eventLogs.add(
              "${event['playerReference']}: $playerEvent");

          Future.delayed(Duration(milliseconds: 100), () {
            _scrollController.jumpTo(
                _scrollController.position.maxScrollExtent);
          });
        });
      }
    });

    _player2.handleAllPlayerEvents((event) {
      String? adEvent = event['ad'];
      if (adEvent != null) {
        setState(() {
          _eventLogs.add(
              "${event['playerReference']}: $adEvent"); // Ad events

          Future.delayed(Duration(milliseconds: 100), () {
            _scrollController.jumpTo(
                _scrollController.position.maxScrollExtent);
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 16,
        children: [
          _buildControlButtons(),
          // Video Player 1
          TargetVideoPlayerView(
            onCreated: (id) => setState(() => _viewId1 = id), size: _playerSize,
          ),
          const SizedBox(height: 16),
          // Video Player 2
          TargetVideoPlayerView(
            onCreated: (id) => setState(() => _viewId2 = id), size: _playerSize,
          ),
          const SizedBox(height: 16),
          // Display latest event
          Column(
            children: [
              Text('Events:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              EventLogListView(eventLogs: _eventLogs, scrollController: _scrollController),
            ],
          ),
        ],
      ),
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
          onPressed: () async {
          if (_viewId1 == null) return;
          try {
            await _player1.load(
              playerId: 45852,
              mediaId: 24090,
              typeOfPlayer: "Playlist",
              viewId: _viewId1!
            );
          } on PlatformException catch (e) {
            print('Error loading video 1: ${e.message}');
          }
        }
        ),
        PlayerControlButton(
          label: 'Load Video 2',
          onPressed: () async {
          if (_viewId2 == null) return;
          try {
            await _player2.load(
              playerId: 45852,
              mediaId: 24090,
              typeOfPlayer: "Playlist",
              viewId: _viewId2!,
            );
          } on PlatformException catch (e) {
            print('Error loading video 2: ${e.message}');
          }
        }
        ),
        PlayerControlButton(
          label: 'Play/Pause 1',
          onPressed: () async => _togglePlayPause(_player1),
        ),
        PlayerControlButton(
          label: 'Play/Pause 2',
          onPressed: () async => _togglePlayPause(_player2),
        ),
        PlayerControlButton(
          label: 'Previous',
          onPressed: () async => _player1.previous(),
        ),
        PlayerControlButton(
          label: 'Next',
          onPressed: () async => _player1.next(),
        ),
        PlayerControlButton(
          label: 'Mute',
          onPressed: () async => _player1.mute(),
        ),
        PlayerControlButton(
          label: 'Unmute',
          onPressed: () async => _player1.unMute(),
        ),
        PlayerControlButton(
          label: 'setFullScreen',
          onPressed: () async => _player1.setFullscreen(true),
        ),
        PlayerControlButton(
          label: 'showControls',
          onPressed: () async => _player1.showControls(),
        ),
        PlayerControlButton(
          label: 'hideControls',
          onPressed: () async => _player1.hideControls(),
        ),
        PlayerControlButton(
          label: 'Get current time',
          onPressed: (() async {
            num? time = await _player1.getPlayerCurrentTime();
            print("Current time: $time");
          }),
        ),
        PlayerControlButton(
          label: 'Get ad duration',
          onPressed: (() async {
            num? time = await _player1.getAdDuration();
            print("Ad duration: $time");
          }),
        ),
        PlayerControlButton(
          label: 'Get video duration',
          onPressed: (() async {
            num? time = await _player1.getVideoDuration();
            print("Video duration: $time");
          }),
        ),
        PlayerControlButton(
          label: 'Destroy',
          onPressed: () => _player1.destroyPlayer(),
        ),
      ],
    );
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

class EventLogListView extends StatelessWidget {
  final List<String> eventLogs;
  final ScrollController scrollController;

  const EventLogListView({
    Key? key,
    required this.eventLogs,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16), // Horizontal padding
      child: Container(
        height: 200, // Adjust height as needed
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1), // Thin black border
          borderRadius: BorderRadius.circular(8), // Optional rounded corners
        ),
        child: Scrollbar(
          child: ListView.builder(
            controller: scrollController,
            itemCount: eventLogs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  eventLogs[index],
                  style: const TextStyle(fontSize: 14),
                ),
              );
            },
          ),
        ),
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