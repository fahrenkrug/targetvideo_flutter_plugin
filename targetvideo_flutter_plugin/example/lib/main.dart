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
          title: const Text('Native Video Player'),
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
    double platformViewWidth = 320; // Example width
    double platformViewHeight = 180; // Maintain 16:9 aspect ratio

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Native video player view with 16:9 aspect ratio
        Container(
          width: platformViewWidth,
          height: platformViewHeight,
          child: UiKitView(
            viewType: 'targetvideo/player_video_view',
            creationParams: null,
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: (int id) {
              setState(() {
                _viewId = id; // Save the view ID for later use
              });
            },
          ),
        ),
        const SizedBox(height: 20),
        // Button to trigger video loading
        ElevatedButton(
          onPressed: _loadVideo,
          child: const Text('Load Video'),
        ),
      ],
    );
  }
}
