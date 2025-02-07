import Flutter
import UIKit
import BridSDK

public class TargetvideoFlutterPlugin: NSObject, FlutterPlugin {
    var listOfPlayers: [String: BVPlayer?] = [:]
    private var eventSink: FlutterEventSink?
    private let videoViewFactory: NativeVideoViewFactory
    
    public init(videoViewFactory: NativeVideoViewFactory) {
        self.videoViewFactory = videoViewFactory
        super.init()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "targetvideo_flutter_plugin", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "targetvideo_flutter_plugin/events", binaryMessenger: registrar.messenger())
        let videoViewFactory = NativeVideoViewFactory()
        let instance = TargetvideoFlutterPlugin(videoViewFactory: videoViewFactory)
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.register(videoViewFactory, withId: "targetvideo/player_video_view")
        eventChannel.setStreamHandler(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "load":
            load(call: call, result: result)
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

enum MediaType: String {
    case single = "Single"
    case playlist = "Playlist"
}

// MARK: - Private methods
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
    
    private func load(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let playerView = UIView()
        guard let args = call.arguments as? [String: Any],
              let playerReference = getPlayerReference(call: call),
              let viewId = args["viewId"] as? Int,
              let view = videoViewFactory.getView(byId: Int64(viewId)) else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments or view not found", details: nil))
            return
        }
        
        let playerId = args["playerId"] as? Int ?? 0
        let mediaId = args["mediaId"] as? Int ?? 0
        let typeOfPlayer = args["typeOfPlayer"] as? String ?? "Single"
        let controlAutoplay = args["controlAutoplay"] as? Bool ?? false
        let scrollOnAd = args["scrollOnAd"] as? Bool ?? false
        let creditsLabelColor = args["creditsLabelColor"] as? String
        let setCornerRadius = args["setCornerRadius"] as? Int ?? 0
        let localization = args["localization"] as? String
        let doubleTapSeek = args["doubleTapSeek"] as? Int ?? 0
        let seekPreview = args["seekPreview"] as? Int ?? 1
        
        if typeOfPlayer == MediaType.single.rawValue {
            loadSingle(view, playerView, playerId, mediaId, playerReference, controlAutoplay, scrollOnAd, creditsLabelColor, setCornerRadius, localization, doubleTapSeek, seekPreview)
        } else if typeOfPlayer == MediaType.playlist.rawValue {
            loadPlaylist(view, playerView, playerId, mediaId, playerReference, controlAutoplay, scrollOnAd, creditsLabelColor, setCornerRadius, localization, doubleTapSeek, seekPreview)
        } else {
            return
        }
    }
    
    private func loadSingle(_ view: UIView,
                            _ playerView: UIView,
                            _ playerId: Int,
                            _ videoId: Int,
                            _ playerReference: String,
                            _ controlAutoplay: Bool,
                            _ scrollOnAd: Bool,
                            _ creditsLabelColor: String?,
                            _ setCornerRadius: Int,
                            _ localization: String?,
                            _ doubleTapSeek: Int,
                            _ seekPreview: Int) {
        
        DispatchQueue.main.async {
            playerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(playerView)
            
            NSLayoutConstraint.activate([
                playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                playerView.topAnchor.constraint(equalTo: view.topAnchor),
                playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            let data = BVData(playerID: Int32(playerId), forVideoID: Int32(videoId))
            let player = BVPlayer(data: data, for: playerView)
            player?.setPlayerReferenceName(playerReference)
            player?.setPlayerLanguage(localization)
            player?.controlAutoplay(controlAutoplay)
            player?.scroll(onAd: scrollOnAd)
            player?.setCornerRadius(Int32(setCornerRadius))
            player?.setSeekSeconds(Int32(doubleTapSeek))
            player?.setSeekPreviewEnabled(Int32(seekPreview))
            if let creditsLabelColor {
                player?.creditsLabelColor(creditsLabelColor)
            }
            
            self.listOfPlayers[playerReference] = player
        }
    }
    
    private func loadPlaylist(_ view: UIView,
                              _ playerView: UIView,
                              _ playerId: Int,
                              _ playlistId: Int,
                              _ playerReference: String,
                              _ controlAutoplay: Bool,
                              _ scrollOnAd: Bool,
                              _ creditsLabelColor: String?,
                              _ setCornerRadius: Int,
                              _ localization: String?,
                              _ doubleTapSeek: Int,
                              _ seekPreview: Int) {
        
        DispatchQueue.main.async {
            playerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(playerView)
            
            NSLayoutConstraint.activate([
                playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                playerView.topAnchor.constraint(equalTo: view.topAnchor),
                playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            let data = BVData(playerID: Int32(playerId), forPlaylistID: Int32(playlistId))
            let player = BVPlayer(data: data, for: playerView)
            player?.setPlayerReferenceName(playerReference)
            player?.setPlayerLanguage(localization)
            player?.controlAutoplay(controlAutoplay)
            player?.scroll(onAd: scrollOnAd)
            player?.setCornerRadius(Int32(setCornerRadius))
            player?.setSeekSeconds(Int32(doubleTapSeek))
            player?.setSeekPreviewEnabled(Int32(seekPreview))
            if let creditsLabelColor {
                player?.creditsLabelColor(creditsLabelColor)
            }
            
            self.listOfPlayers[playerReference] = player
        }
    }
}

// Extension for event streaming
extension TargetvideoFlutterPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        setupEventNetworking()
        setupEventNetworkingForAd()
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
    private func setupEventNetworking() {
        NotificationCenter.default.addObserver(self, selector: #selector(eventWriter), name: NSNotification.Name(rawValue: "PlayerEvent"), object: nil)
    }
    
    private func setupEventNetworkingForAd() {
        NotificationCenter.default.addObserver(self, selector: #selector(eventWriter), name: NSNotification.Name(rawValue: "AdEvent"), object: nil)
    }
    
    @objc private func eventWriter(_ notification: NSNotification) {
        var eventDict: [String: Any] = [:]
        
        if let reference = notification.userInfo?["reference"] as? String {
            eventDict["playerReference"] = reference
        }
        
        if notification.name.rawValue == "PlayerEvent" {
            
            if let event = notification.userInfo?["event"] as? String {
                eventDict["type"] = "PlayerEvent"
                eventDict["event"] = event
            }
        }
        
        if notification.name.rawValue == "AdEvent" {
            if let ad = notification.userInfo?["ad"] as? String {
                eventDict["type"] = "AdEvent"
                eventDict["ad"] = ad
            }
        }
        
        if let eventSink = self.eventSink {
            eventSink(eventDict)
        }
    }
}
