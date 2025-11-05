import 'package:targetvideo_flutter_plugin/lib.dart';

/// Android-specific extension for track type.
extension GoogleCastTrackTypeAndroid on TrackType {
  /// Creates a track type from a map value.
  static TrackType fromMap(String value) {
    return TrackType.values.firstWhere(
      (element) => element.name.toUpperCase() == value.toUpperCase(),
      orElse: () => TrackType.unknown,
    );
  }
}
