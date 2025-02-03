import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:targetvideo_flutter_plugin/targetvideo_player.dart';

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
  int? _viewId2;
  TargetVideoPlayer player1 = TargetVideoPlayer(playerReference: "player1");
  TargetVideoPlayer player2 = TargetVideoPlayer(playerReference: "player2");

  @override
  void initState() {
    super.initState();
    player1.handleAllPlayerEvents((event) {
      print(event);
      // Add your custom event handling logic here
    });
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
                  _viewId2 = id;
                });
              },
            )
                : AndroidView(
              viewType: 'targetvideo/player_video_view',
              creationParams: null,
              creationParamsCodec: const StandardMessageCodec(),
              onPlatformViewCreated: (int id) {
                setState(() {
                  _viewId2 = id;
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
                  onPressed: () async {
                    try {
                      await player1.loadPlaylist(45852, 24090, _viewId!);
                    } on PlatformException catch (e) {
                      print({e.message});
                    }
                  },
                  child: const Text('load video'),
                ),
                ),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await player2.loadPlaylist(45852, 24090, _viewId2!);
                    } on PlatformException catch (e) {
                      print({e.message});
                    }
                  },
                  child: const Text('load video 2'),
                ),
              ),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      bool? isPaused = await player1.isPaused();
                      if (isPaused == true) {
                        player1.playVideo();
                      } else {
                        player1.pauseVideo();
                      }
                    } on PlatformException catch (e) {
                      print({e.message});
                    }
                  },
                  child: const Text('play/pause 1'),
                ),
              ),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      bool? isPaused = await player2.isPaused();
                      isPaused == true ? player2.playVideo() : player2.pauseVideo();
                    } on PlatformException catch (e) {
                      print({e.message});
                    }
                  },
                  child: const Text('play/pause 2'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
