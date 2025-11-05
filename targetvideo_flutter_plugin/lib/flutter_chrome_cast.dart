/// TargetVideo Flutter Plugin
///
/// A comprehensive library for integrating video playback and Google Cast functionality into Flutter apps.
///
/// ## Main Import
/// ```dart
/// import 'package:targetvideo_flutter_plugin/flutter_chrome_cast.dart';
/// ```
///
/// ## Selective Imports
/// For better performance and cleaner code, you can import only what you need:
///
/// ```dart
/// // Core casting functionality
/// import 'package:targetvideo_flutter_plugin/cast_context.dart';
/// import 'package:targetvideo_flutter_plugin/discovery.dart';
/// import 'package:targetvideo_flutter_plugin/session.dart';
/// import 'package:targetvideo_flutter_plugin/media.dart';
///
/// // UI Widgets
/// import 'package:targetvideo_flutter_plugin/widgets.dart';
///
/// // Models and Entities
/// import 'package:targetvideo_flutter_plugin/models.dart';
/// import 'package:targetvideo_flutter_plugin/entities.dart';
///
/// // Enums and Constants
/// import 'package:targetvideo_flutter_plugin/enums.dart';
/// ```
library targetvideo_flutter_plugin;

// Core functionality
export 'cast_context.dart';
export 'discovery.dart';
export 'session.dart';
export 'media.dart';

// UI Components
export 'widgets.dart';

// Data structures
export 'models.dart';
export 'entities.dart';
export 'enums.dart';

// Utilities
export 'utils.dart';

// Common types
export 'common.dart';

export 'themes.dart';
