import Flutter
import UIKit
import BridSDK

public class TargetvideoFlutterPlugin: NSObject, FlutterPlugin {
    var player: BVPlayer?
    var listOfPlayers: [String: BVPlayer?] = [:]
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
            handleLoadVideo(call: call, result: result)
        case "createPlayer":
            guard let args = call.arguments as? [String: Any],
                  let playerReference = args["playerReference"] as? String else { return }
            listOfPlayers[playerReference] = nil
            result(nil)
        case "loadPlaylist":
            handleLoadPlaylist(call: call, result: result)
        case "pauseVideo":
            guard let args = call.arguments as? [String: Any],
                  let playerReference = args["playerReference"] as? String else { return }
            
            if let playerr = listOfPlayers[playerReference] {
                playerr?.pause()
            }
            result(nil)
        case "playVideo":
            player?.play()
            result(nil)
        case "previous":
            player?.previous()
            result(nil)
        case "next":
            player?.next()
            result(nil)
        case "mute":
            player?.mute()
            result(nil)
        case "unMute":
            player?.unmute()
            result(nil)
        case "setFullscreen":
            player?.setFullscreenON()
            result(nil)
        case "showControls":
            player?.showControls()
            result(nil)
        case "hideControls":
            player?.hideControls()
            result(nil)
        case "isAdPlaying":
            result(player?.isAdInProgress())
        case "getPlayerCurrentTime":
            result(player?.getCurrentTime())
        case "getAdDuration":
            result(player?.getAdDuration())
        case "getVideoDuration":
            result(player?.getDuration())
        case "isPaused":
            result(player?.isPaused())
        case "isRepeated":
            result(player?.isRepeated())
        case "destroyPlayer":
            player?.destroy()
            result(nil)
        case "isAutoplay":
            result(player?.isAutoplay())
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

extension TargetvideoFlutterPlugin {
    private func handleLoadVideo(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let playerView = UIView()
        guard let args = call.arguments as? [String: Any],
              let viewId = args["viewId"] as? Int64,
              let playerId = args["playerId"] as? Int,
              let videoId = args["videoId"] as? Int,
              let view = videoViewFactory.getView(byId: viewId) else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments or view not found", details: nil))
            return
        }
        
        DispatchQueue.main.async {
            playerView.translatesAutoresizingMaskIntoConstraints = false
            playerView.backgroundColor = .red
            view.addSubview(playerView)
            
            NSLayoutConstraint.activate([
                playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                playerView.topAnchor.constraint(equalTo: view.topAnchor),
                playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            let data = BVData(playerID: Int32(playerId), forVideoID: Int32(videoId))
            self.player = BVPlayer(data: data, for: playerView)
        }
        result(nil)
    }
    
    private func handleLoadPlaylist(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let playerView = UIView()
        guard let args = call.arguments as? [String: Any],
              let viewId = args["viewId"] as? Int64,
              let playerId = args["playerId"] as? Int,
              let playlistId = args["playlistId"] as? Int,
              let playerReference = args["playerReference"] as? String,
              let view = videoViewFactory.getView(byId: viewId) else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments or view not found", details: nil))
            return
        }
        
        DispatchQueue.main.async {
            playerView.translatesAutoresizingMaskIntoConstraints = false
            playerView.backgroundColor = .red
            view.addSubview(playerView)
            
            NSLayoutConstraint.activate([
                playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                playerView.topAnchor.constraint(equalTo: view.topAnchor),
                playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            let data = BVData(playerID: Int32(playerId), forPlaylistID: Int32(playlistId))
            self.listOfPlayers[playerReference] = BVPlayer(data: data, for: playerView)
        }
        result(nil)
    }
}
