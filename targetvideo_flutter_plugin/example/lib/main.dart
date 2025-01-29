import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:targetvideo_flutter_plugin/targetvideo_flutter_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TargetVideo flutter plugin'),
        ),
        body: const NativeVideoWidget(),
      ),
    );
  }
}

class NativeVideoWidget extends StatefulWidget {
  const NativeVideoWidget({Key? key}) : super(key: key);

  @override
  State<NativeVideoWidget> createState() => _NativeVideoWidgetState();
}

class _NativeVideoWidgetState extends State<NativeVideoWidget> {
  int? _viewId;
  final String _playerRef = "player1";

  @override
  void initState() {
    super.initState();

    TargetvideoFlutterPlugin.playerEvents.listen((event) {
      if (event['event'] is String) {
        final eventValue = event['event'] as String;

        if (eventValue.contains('ref: $_playerRef')) {
          print(event);
        }
      }
    });
  }

  Future<void> _loadVideo() async {
    if (_viewId == null) {
      print("View ID is not available yet.");
      return;
    }

    try {
      await TargetvideoFlutterPlugin.loadPlaylist(45852, 24090, _viewId!, _playerRef);
    } on PlatformException catch (e) {
      print("Failed to load video: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set width and height for the video player (16:9 aspect ratio)
    double platformViewWidth = 320;
    double platformViewHeight = 180;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Video Player View
          Container(
            width: platformViewWidth,
            height: platformViewHeight,
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Platform.isIOS
                ? UiKitView(
              viewType: 'targetvideo/player_video_view',
              creationParams: null,
              creationParamsCodec: const StandardMessageCodec(),
              onPlatformViewCreated: (int id) {
                setState(() {
                  _viewId = id;
                });
              },
            )
                : AndroidView(
              viewType: 'targetvideo/player_video_view',
              creationParams: null,
              creationParamsCodec: const StandardMessageCodec(),
              onPlatformViewCreated: (int id) {
                setState(() {
                  _viewId = id;
                });
              },
            ),
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            children: [
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: _loadVideo,
                  child: const Text('Load video'),
                ),
              ),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await TargetvideoFlutterPlugin.playVideo(_playerRef);
                      print("Restarted video");
                    } on PlatformException catch (e) {
                      print("Failed to restart video: '${e.message}'.");
                    }
                  },
                  child: const Text('Play'),
                ),
              ),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await TargetvideoFlutterPlugin.previous(_playerRef);
                    } on PlatformException catch (e) {
                      print("Failed to play previous video: '${e.message}'.");
                    }
                  },
                  child: const Text('Previous'),
                ),

              ),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await TargetvideoFlutterPlugin.next(_playerRef);
                    } on PlatformException catch (e) {
                      print("Failed to play next video: '${e.message}'.");
                    }
                  },
                  child: const Text('Next'),
                ),
              ),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final duration = await TargetvideoFlutterPlugin.getVideoDuration(_playerRef);
                      print("Video duration: $duration");
                    } on PlatformException catch (e) {
                      print("Failed to unmute video: '${e.message}'.");
                    }
                  },
                  child: const Text('Get duration'),
                ),
              ),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await TargetvideoFlutterPlugin.mute(_playerRef);
                    } on PlatformException catch (e) {
                      print("Failed to mute: '${e.message}'.");
                    }
                  },
                  child: const Text('Mute'),
                ),
              ),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await TargetvideoFlutterPlugin.unMute(_playerRef);
                    } on PlatformException catch (e) {
                      print("Failed to unMute: '${e.message}'.");
                    }
                  },
                  child: const Text('unMute'),
                ),
              ),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await TargetvideoFlutterPlugin.pauseVideo(_playerRef);
                      print("Paused video");
                    } on PlatformException catch (e) {
                      print("Failed to pause video: '${e.message}'.");
                    }
                  },
                  child: const Text('Pause'),
                ),
              ),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await TargetvideoFlutterPlugin.playVideo(_playerRef);
                      print("Restarted video");
                    } on PlatformException catch (e) {
                      print("Failed to restart video: '${e.message}'.");
                    }
                  },
                  child: const Text('Play'),
                ),
              ),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await TargetvideoFlutterPlugin.destroyPlayer(_playerRef);
                    } on PlatformException catch (e) {
                      print("Failed to seek to destroy: '${e.message}'.");
                    }
                  },
                  child: const Text('Destroy'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
