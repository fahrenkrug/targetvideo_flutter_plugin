package com.targetvideo.flutter_plugin

import android.content.Context
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import tv.brid.sdk.BridPlayer
import tv.brid.sdk.BridPlayerBuilder
import tv.brid.sdk.listeners.BridPlayerListener

/** Main plugin class – bridges Flutter <-> Android. */
class TargetvideoFlutterPlugin : FlutterPlugin,
  MethodChannel.MethodCallHandler,
  EventChannel.StreamHandler {

  private lateinit var methodChannel: MethodChannel
  private lateinit var eventChannel: EventChannel
  private lateinit var viewFactory: NativeVideoViewFactory
  private var eventSink: EventChannel.EventSink? = null

  /** Keeps strong references to all active players by user-defined reference. */
  private val players: MutableMap<String, BridPlayer> = HashMap()

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    val messenger = binding.binaryMessenger
    methodChannel = MethodChannel(messenger, "targetvideo_flutter_plugin").also {
      it.setMethodCallHandler(this)
    }
    eventChannel = EventChannel(messenger, "targetvideo_flutter_plugin/events").also {
      it.setStreamHandler(this)
    }
    viewFactory = NativeVideoViewFactory(messenger)
    binding.platformViewRegistry.registerViewFactory(
      "targetvideo/player_video_view",
      viewFactory
    )
  }

  // ---------- MethodChannel ----------

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) = when (call.method) {
    "load" -> load(call, result)
    "pauseVideo"        -> invokeOnPlayer(call, result) { it.pause() }
    "playVideo"         -> invokeOnPlayer(call, result) { it.play() }
    "previous"          -> invokeOnPlayer(call, result) { it.previous() }
    "next"              -> invokeOnPlayer(call, result) { it.next() }
    "mute"              -> invokeOnPlayer(call, result) { it.setMute(true) }
    "unMute"            -> invokeOnPlayer(call, result) { it.setMute(false) }
    "setFullscreen"     -> setFullscreen(call, result)
    "showControls"      -> invokeOnPlayer(call, result) { it.showControls() }
    "hideControls"      -> invokeOnPlayer(call, result) { it.hideControls() }
    "isAdPlaying"       -> queryPlayer(call, result) { it.isPlayingAd }
    "getPlayerCurrentTime" -> queryPlayer(call, result) { it.currentPosition }
    "getAdDuration"     -> queryPlayer(call, result) { it.getAdDuration() }
    "getVideoDuration"  -> queryPlayer(call, result) { it.duration }
    "isPaused"          -> queryPlayer(call, result) { it.isPaused }
    "isRepeated"        -> queryPlayer(call, result) { it.isRepeated }
    "destroyPlayer"     -> destroyPlayer(call, result)
    "isAutoplay"        -> queryPlayer(call, result) { it.isAutoplayEnabled }
    else -> result.notImplemented()
  }

  // ---------- EventChannel ----------

  override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
    eventSink = events
  }
  override fun onCancel(arguments: Any?) { eventSink = null }

  // ---------- Private helpers ----------

  private fun load(call: MethodCall, result: MethodChannel.Result) {
    val args = call.arguments as? Map<*, *> ?: return result.error(
      "ARG_ERROR", "Arguments must be a map", null
    )

    val context = (viewFactory
      .getViewHolder(args["viewId"] as Int)
      ?: return result.error("VIEW_ERROR", "Native view not found", null)
            ).context

    val playerRef = args["playerReference"] as? String
      ?: return result.error("ARG_ERROR", "playerReference missing", null)

    val playerId           = (args["playerId"] as Number).toInt()
    val mediaIdOrPlaylist  = (args["mediaId"]  as Number).toInt()
    val typeOfPlayer       = args["typeOfPlayer"] as? String ?: "Single"
    val container          = viewFactory.getViewHolder(args["viewId"] as Int)!!

    // Build player
    val bridPlayer = BridPlayerBuilder(context as Context, container)
      .fullscreen(false)
      .setPlayerLanguage(args["localization"] as? String ?: "")
      .setCornerRadius((args["setCornerRadius"] as Number).toInt())
      .setSeekSeconds((args["doubleTapSeek"] as Number).toInt())
      .useVpaidSupport(false)
      .build().apply {
        setPlayerReference(playerRef)
        enableAutoplay(args["controlAutoplay"] as Boolean)
        setCreditsLabelColor(args["creditsLabelColor"] as? String)
        enableAdControls(!(args["scrollOnAd"] as Boolean))
        setSeekPreview((args["seekPreview"] as Number).toInt())
        setBridListener(createListener())
      }

    // Load content
    if (typeOfPlayer == "Playlist")
      bridPlayer.loadPlaylist(playerId, mediaIdOrPlaylist)
    else
      bridPlayer.loadVideo(playerId, mediaIdOrPlaylist)

    players[playerRef] = bridPlayer
    result.success(null)
  }

  private fun setFullscreen(call: MethodCall, result: MethodChannel.Result) =
    invokeOnPlayer(call, result) { player ->
      val fullscreen = (call.argument<Boolean>("fullscreen") ?: false)
      player.setFullScreen(fullscreen)
    }

  private fun destroyPlayer(call: MethodCall, result: MethodChannel.Result) {
    getPlayer(call)?.apply {
      release()
      players.remove(call.argument<String>("playerReference"))
    }
    result.success(null)
  }

  /** Executes [action] on the player and returns success(null). */
  private inline fun invokeOnPlayer(
    call: MethodCall,
    result: MethodChannel.Result,
    crossinline action: (BridPlayer) -> Unit
  ) {
    getPlayer(call)?.let { action(it) }
    result.success(null)
  }

  /** Executes [query] and returns its value through [result]. */
  private inline fun <T> queryPlayer(
    call: MethodCall,
    result: MethodChannel.Result,
    crossinline query: (BridPlayer) -> T
  ) {
    result.success(getPlayer(call)?.let { query(it) })
  }

  private fun getPlayer(call: MethodCall): BridPlayer? =
    players[call.argument<String>("playerReference")]

  /** Generates listener that forwards both player and ad events to Flutter. */
  private fun BridPlayer.createListener(): BridPlayerListener = BridPlayerListener { status, ref ->
    val type = if (isAdEvent(status)) "AdEvent" else "PlayerEvent"
    val map  = HashMap<String, Any>().apply {
      put("playerReference", ref ?: "")
      put("type", type)
      if (type == "AdEvent") put("ad", status) else put("event", status)
    }
    eventSink?.success(map)
    Log.d("BridPlayerEvent", "$type -> $status ($ref)")
  }

  /** Simple heuristic – all ad event codes start with "ad" or are in known set. */
  private fun isAdEvent(code: String): Boolean =
    code.startsWith("ad") || code in setOf("r","i","v","s","ae","adbstart")

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
    players.values.forEach { it.release() }
    players.clear()
  }
}
