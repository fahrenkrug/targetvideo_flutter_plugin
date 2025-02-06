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
  int? _viewId;
  final TargetVideoPlayer _player = TargetVideoPlayer(playerReference: "player1", localization: "it");
  final List<String> _eventLogs = [];
  final ScrollController _scrollController = ScrollController();
  static const _playerSize = Size(320, 180);

  @override
  void initState() {
    super.initState();
    // Listening to player events
    listenForPlayerEvents();
  }

  void listenForPlayerEvents() {
    _player.handleAllPlayerEvents((event) {
      String? playerEvent = event['event']; // Event dictionary key for player events
      String? adEvent = event['ad']; // Event dictionary key for ad events
      if (playerEvent != null) {
        if (event['event'] == 'playerVideoLoad') {
          /// Handle playerVideoLoad event
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
            onCreated: (id) => setState(() => _viewId = id), size: _playerSize,
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
          label: 'Load player',
          onPressed: () async {
          if (_viewId == null) return;
          try {
            await _player.load(
              playerId: 45852,
              mediaId: 24090,
              typeOfPlayer: "Playlist",
              viewId: _viewId!
            );
          } on PlatformException catch (e) {
            print('Error loading video: ${e.message}');
          }
        }
        ),
        PlayerControlButton(
          label: 'Play/Pause',
          onPressed: () async => _togglePlayPause(_player),
        ),
        PlayerControlButton(
          label: 'Previous',
          onPressed: () async => _player.previous(),
        ),
        PlayerControlButton(
          label: 'Next',
          onPressed: () async => _player.next(),
        ),
        PlayerControlButton(
          label: 'Mute',
          onPressed: () async => _player.mute(),
        ),
        PlayerControlButton(
          label: 'Unmute',
          onPressed: () async => _player.unMute(),
        ),
        PlayerControlButton(
          label: 'setFullScreen',
          onPressed: () async => _player.setFullscreen(true),
        ),
        PlayerControlButton(
          label: 'showControls',
          onPressed: () async => _player.showControls(),
        ),
        PlayerControlButton(
          label: 'hideControls',
          onPressed: () async => _player.hideControls(),
        ),
        PlayerControlButton(
          label: 'Get current time',
          onPressed: (() async {
            num? time = await _player.getPlayerCurrentTime();
            print("Current time: $time");
          }),
        ),
        PlayerControlButton(
          label: 'Get ad duration',
          onPressed: (() async {
            num? time = await _player.getAdDuration();
            print("Ad duration: $time");
          }),
        ),
        PlayerControlButton(
          label: 'Get video duration',
          onPressed: (() async {
            num? time = await _player.getVideoDuration();
            print("Video duration: $time");
          }),
        ),
        PlayerControlButton(
          label: 'Destroy',
          onPressed: () => _player.destroyPlayer(),
        ),
      ],
    );
  }

  // Play/pause the loaded player
  Future<void> _togglePlayPause(TargetVideoPlayer player) async {
    try {
      final isPaused = await player.isPaused();
      isPaused == true ? player.playVideo() : player.pauseVideo();
    } on PlatformException catch (e) {
      print('Error toggling play/pause: ${e.message}');
    }
  }
}

// Event log widget
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

// Action button
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