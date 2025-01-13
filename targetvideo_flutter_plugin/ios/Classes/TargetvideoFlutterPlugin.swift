import Flutter
import UIKit
import BridSDK

public class TargetvideoFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "targetvideo_flutter_plugin", binaryMessenger: registrar.messenger())
    let instance = TargetvideoFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "loadVideo":
          guard let args = call.arguments as? [String: Any],
          let playerId = args["playerId"] as? Int,
          let videoId = args["videoId"] as? Int else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
          return
           }
          debugPrint("Load Video called with playerId: \(playerId), videoId: \(videoId)")
          let videoView = UIView()
              videoView.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
              videoView.backgroundColor = .black // Optional: Set a placeholder background color

              // Add the view to the root view controller's view
              if let rootView = UIApplication.shared.keyWindow?.rootViewController?.view {
                  rootView.addSubview(videoView)

                  // Add constraints
                  NSLayoutConstraint.activate([
                      videoView.topAnchor.constraint(equalTo: rootView.safeAreaLayoutGuide.topAnchor),
                      videoView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
                      videoView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
                      videoView.heightAnchor.constraint(equalTo: videoView.widthAnchor, multiplier: 9.0/16.0)
                  ])
              }
          var player = BVPlayer()
          player = BVPlayer(data: BVData(playerID: Int32(playerId), forPlaylistID: Int32(videoId)), for: videoView)
          result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
