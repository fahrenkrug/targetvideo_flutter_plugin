import Flutter
import UIKit
import BridSDK

public class TargetvideoFlutterPlugin: NSObject, FlutterPlugin {
    var listOfPlayers: [String: BVPlayer?] = [:]
    private let videoViewFactory: NativeVideoViewFactory
    
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
            if let playerReference = getPlayerReference(call: call) {
                listOfPlayers[playerReference] = nil
            }
            result(nil)
        case "loadPlaylist":
            handleLoadPlaylist(call: call, result: result)
        case "pauseVideo":
            if let player = getPlayerWithReference(call: call) {
                player.pause()
            }
            result(nil)
        case "playVideo":
            if let player = getPlayerWithReference(call: call) {
                player.play()
            }
            result(nil)
        case "previous":
            if let player = getPlayerWithReference(call: call) {
                player.previous()
            }
            result(nil)
        case "next":
            if let player = getPlayerWithReference(call: call) {
                player.next()
            }
            result(nil)
        case "mute":
            if let player = getPlayerWithReference(call: call) {
                player.mute()
            }
            result(nil)
        case "unMute":
            if let player = getPlayerWithReference(call: call) {
                player.unmute()
            }
            result(nil)
        case "setFullscreen":
            if let args = call.arguments as? [String: Any],
               let fullscreen = args["fullscreen"] as? Bool,
               let player = getPlayerWithReference(call: call) {
                if fullscreen {
                    player.setFullscreenON()
                } else {
                    player.setFullscreenOFF()
                }
            }
            result(nil)
        case "showControls":
            if let player = getPlayerWithReference(call: call) {
                player.showControls()
            }
            result(nil)
        case "hideControls":
            if let player = getPlayerWithReference(call: call) {
                player.hideControls()
            }
            result(nil)
        case "isAdPlaying":
            if let player = getPlayerWithReference(call: call) {
                let isAdPlaying = player.isAdInProgress()
                result(isAdPlaying)
            } else {
                result(nil)
            }
        case "getPlayerCurrentTime":
            if let player = getPlayerWithReference(call: call) {
                let currentTime = player.getCurrentTime()
                result(currentTime)
            } else {
                result(nil)
            }
        case "getAdDuration":
            if let player = getPlayerWithReference(call: call) {
                let adDuration = player.getAdDuration()
                result(adDuration)
            } else {
                result(nil)
            }
        case "getVideoDuration":
            if let player = getPlayerWithReference(call: call) {
                let duration = player.getDuration()
                result(duration)
            } else {
                result(nil)
            }
        case "isPaused":
            if let player = getPlayerWithReference(call: call) {
                let isPaused = player.isPaused()
                result(isPaused)
            } else {
                result(nil)
            }
        case "isRepeated":
            if let player = getPlayerWithReference(call: call) {
                let isRepeated = player.isRepeated()
                result(isRepeated)
            } else {
                result(nil)
            }
        case "destroyPlayer":
            if let player = getPlayerWithReference(call: call) {
                player.destroy()
            }
            result(nil)
        case "isAutoplay":
            if let player = getPlayerWithReference(call: call) {
                let isAutoplay = player.isAutoplay()
                result(isAutoplay)
            } else {
                result(nil)
            }
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
    
    private func getPlayerReference(call: FlutterMethodCall) -> String? {
        guard let args = call.arguments as? [String: Any],
              let playerReference = args["playerReference"] as? String else { return nil }
        return playerReference
    }
    
    private func getPlayerWithReference(call: FlutterMethodCall) -> BVPlayer? {
        guard let args = call.arguments as? [String: Any],
              let playerReference = args["playerReference"] as? String,
              let player = listOfPlayers[playerReference] else { return nil }
        return player
    }
    
    private func handleLoadVideo(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let playerView = UIView()
        guard let args = call.arguments as? [String: Any],
              let viewId = args["viewId"] as? Int64,
              let playerId = args["playerId"] as? Int,
              let videoId = args["videoId"] as? Int,
              let playerReference = getPlayerReference(call: call),
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
            self.listOfPlayers[playerReference] = BVPlayer(data: data, for: playerView)
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
