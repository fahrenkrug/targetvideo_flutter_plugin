
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TargetVideoPlayerView extends StatelessWidget {
  final ValueChanged<int>? onCreated;
  final Size? size;

  const TargetVideoPlayerView({
    super.key,
    this.onCreated, this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size?.width ?? 320,
      height: size?.height ?? 180,
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