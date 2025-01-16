import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
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

  Future<void> _loadVideo() async {
    if (_viewId == null) {
      print("View ID is not available yet.");
      return;
    }

    try {
      await TargetvideoFlutterPlugin.loadVideo(
        45852,
        1597191,
        _viewId!,
      );
    } on PlatformException catch (e) {
      print("Failed to load video: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set width and height for the video player (16:9 aspect ratio)
    double platformViewWidth = 320;
    double platformViewHeight = 180;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: platformViewWidth,
          height: platformViewHeight,
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
        ElevatedButton(
          onPressed: _loadVideo,
          child: const Text('Load Video'),
        ),
      ],
    );
  }
}
