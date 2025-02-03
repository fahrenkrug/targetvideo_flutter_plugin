import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:targetvideo_flutter_plugin/targetvideo_flutter_plugin_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelTargetvideoFlutterPlugin platform = MethodChannelTargetvideoFlutterPlugin();
  const MethodChannel channel = MethodChannel('targetvideo_flutter_plugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });
}
