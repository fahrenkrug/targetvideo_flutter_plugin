import 'package:targetvideo_flutter_plugin/common/image.dart';
import 'package:targetvideo_flutter_plugin/enums/media_metadata_type.dart';

/// Holds metadata type and images for a media item.
class GoogleCastMediaMetadata {
  /// The type of media metadata.
  final GoogleCastMediaMetadataType metadataType;

  /// List of images associated with the media.
  final List<GoogleCastImage>? images;

  /// Creates a new [GoogleCastMediaMetadata] instance.
  GoogleCastMediaMetadata({
    required this.metadataType,
    this.images,
  });

  /// Converts the object to a map for serialization.
  Map<String, dynamic> toMap() {
    return {
      'metadataType': metadataType.value,
      'images': images?.map((x) => x.toMap()).toList(),
    };
  }
}
