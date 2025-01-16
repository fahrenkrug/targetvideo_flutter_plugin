import Flutter
import UIKit
import BridSDK

public class TargetvideoFlutterPlugin: NSObject, FlutterPlugin {
    private let videoViewFactory: NativeVideoViewFactory
    
    // Ensure the initializer is internal to avoid the access level issue
    public init(videoViewFactory: NativeVideoViewFactory) {
        self.videoViewFactory = videoViewFactory
        super.init()
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "targetvideo_flutter_plugin", binaryMessenger: registrar.messenger())
        let videoViewFactory = NativeVideoViewFactory()
        let instance = TargetvideoFlutterPlugin(videoViewFactory: videoViewFactory)

        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.register(videoViewFactory, withId: "targetvideo/player_video_view")
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "loadVideo":
            let playerView = UIView()
            var player = BVPlayer()
            guard let args = call.arguments as? [String: Any],
                  let viewId = args["viewId"] as? Int64,
                  let playerId = args["playerId"] as? Int,
                  let videoId = args["videoId"] as? Int,
                  let view = videoViewFactory.getView(byId: viewId) else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments or view not found", details: nil))
                return
            }

            playerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(playerView)

            NSLayoutConstraint.activate([
                playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                playerView.topAnchor.constraint(equalTo: view.topAnchor),
                playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])

            let data = BVData(playerID: Int32(playerId), forVideoID: Int32(videoId))
            player = BVPlayer(data: data, for: playerView)

            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

public class NativeVideoViewFactory: NSObject, FlutterPlatformViewFactory {
    private var views: [Int64: NativeVideoView] = [:]

    public override init() {
        super.init()
    }

    public func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        let view = NativeVideoView(frame: frame)
        views[viewId] = view
        return view
    }

    public func getView(byId viewId: Int64) -> UIView? {
        return views[viewId]?.view()
    }
}

public class NativeVideoView: NSObject, FlutterPlatformView {
    private let containerView: UIView

    public init(frame: CGRect) {
        self.containerView = UIView(frame: frame)
        super.init()
        setupView()
    }

    private func setupView() {
        containerView.backgroundColor = .lightGray
    }

    public func view() -> UIView {
        return containerView
    }
}
