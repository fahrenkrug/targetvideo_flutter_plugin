package com.targetvideo.flutter_plugin

import android.app.Activity
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import tv.brid.sdk.api.BridPlayer
import tv.brid.sdk.api.BridPlayerBuilder
import tv.brid.sdk.player.listeners.BridPlayerListener
import java.lang.ref.WeakReference

class TargetvideoFlutterPlugin : FlutterPlugin,
  MethodChannel.MethodCallHandler,
  EventChannel.StreamHandler,
  ActivityAware {

  private lateinit var methodChannel: MethodChannel
  private lateinit var eventChannel: EventChannel
  private lateinit var viewFactory: NativeVideoViewFactory
  private var eventSink: EventChannel.EventSink? = null
  private var activityRef: WeakReference<Activity>? = null

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

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) = when (call.method) {
    "load" -> load(call, result)
    "pauseVideo" -> invokeOnPlayer(call, result) { it.pause() }
    "playVideo" -> invokeOnPlayer(call, result) { it.play() }
    "previous" -> invokeOnPlayer(call, result) { it.previous() }
    "next" -> invokeOnPlayer(call, result) { it.next() }
    "mute" -> invokeOnPlayer(call, result) { it.setMute(true) }
    "unMute" -> invokeOnPlayer(call, result) { it.setMute(false) }
    "setFullscreen" -> setFullscreen(call, result)
    "showControls" -> invokeOnPlayer(call, result) { it.showControls() }
    "hideControls" -> invokeOnPlayer(call, result) { it.hideControls() }
    "isAdPlaying" -> queryPlayer(call, result) { it.isPlayingAd }
    "getPlayerCurrentTime" -> queryPlayer(call, result) { it.currentPosition }
    "getVideoDuration" -> queryPlayer(call, result) { it.duration }
    "isPaused" -> queryPlayer(call, result) { it.isPaused }
    "isRepeated" -> queryPlayer(call, result) { it.isRepeated }
    "destroyPlayer" -> destroyPlayer(call, result)
    "isAutoplay" -> queryPlayer(call, result) { it.isAutoplayEnabled }
    else -> result.notImplemented()
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
    eventSink = events
  }

  override fun onCancel(arguments: Any?) {
    eventSink = null
  }

  private fun load(call: MethodCall, result: MethodChannel.Result) {
    val args = call.arguments as? Map<*, *>
      ?: return result.error("ARG_ERROR", "Arguments must be a map", null)

    val activity = activityRef?.get()
      ?: return result.error("CTX_ERROR", "Activity context not available", null)

    val viewId = (args["viewId"] as? Number)?.toInt()
      ?: return result.error("ARG_ERROR", "viewId missing or not an int", null)

    val container = viewFactory.getViewHolder(viewId)
      ?: return result.error("VIEW_ERROR", "Native view not found", null)

    val playerRef = args["playerReference"] as? String
      ?: return result.error("ARG_ERROR", "playerReference missing", null)

    val playerId = (args["playerId"] as? Number)?.toInt()
      ?: return result.error("ARG_ERROR", "playerId missing or not an int", null)

    val typeOfPlayer = (args["typeOfPlayer"] as? String)?.ifBlank { "Single" } ?: "Single"
    val mediaId = (args["mediaId"] as? Number)?.toInt()
      ?: return result.error("ARG_ERROR", "mediaId missing or not an int", null)



    val localization = args["localization"] as? String ?: "en"
    val controlAutoplay = args["controlAutoplay"] as? Boolean ?: false
    val scrollOnAd = args["scrollOnAd"] as? Boolean ?: false
    val creditsColor = args["creditsLabelColor"] as? String
    val cornerRadius = (args["setCornerRadius"] as? Number)?.toInt() ?: 0
    val doubleTapSeek = (args["doubleTapSeek"] as? Number)?.toInt() ?: 10
    val seekPreview = (args["seekPreview"] as? Number)?.toInt() ?: 1

    val bridPlayer = BridPlayerBuilder(activity, container)
      .fullscreen(false)
      .setPlayerLanguage(localization)
      .setCornerRadius(cornerRadius)
      .setSeekSeconds(doubleTapSeek)
      .useVpaidSupport(false)
      .build().apply {
        setPlayerReference(playerRef)
        enableAutoplay(controlAutoplay)
        setCreditsLabelColor(creditsColor)
        enableAdControls(!scrollOnAd)
        setSeekPreview(seekPreview)
        setBridListener(createListener())
      }

    if (typeOfPlayer.equals("Playlist", ignoreCase = true)) {
      bridPlayer.loadPlaylist(playerId, mediaId)
    } else {
      bridPlayer.loadVideo(playerId, mediaId)
    }

    players[playerRef] = bridPlayer
    result.success(null)
  }

  private fun setFullscreen(call: MethodCall, result: MethodChannel.Result) =
    invokeOnPlayer(call, result) {
      val fullscreen = call.argument<Boolean>("fullscreen") ?: false
      it.setFullScreen(fullscreen)
    }

  private fun destroyPlayer(call: MethodCall, result: MethodChannel.Result) {
    getPlayer(call)?.apply {
      release()
      players.remove(call.argument<String>("playerReference"))
    }
    result.success(null)
  }

  private inline fun invokeOnPlayer(
    call: MethodCall,
    result: MethodChannel.Result,
    crossinline action: (BridPlayer) -> Unit
  ) {
    getPlayer(call)?.let { action(it) }
    result.success(null)
  }

  private inline fun <T> queryPlayer(
    call: MethodCall,
    result: MethodChannel.Result,
    crossinline query: (BridPlayer) -> T
  ) {
    result.success(getPlayer(call)?.let { query(it) })
  }

  private fun getPlayer(call: MethodCall): BridPlayer? =
    players[call.argument<String>("playerReference")]

  private fun BridPlayer.createListener(): BridPlayerListener = BridPlayerListener { status, ref ->
    val type = if (isAdEvent(status)) "AdEvent" else "PlayerEvent"
    val map = HashMap<String, Any>().apply {
      put("playerReference", ref ?: "")
      put("type", type)
      if (type == "AdEvent") put("ad", status) else put("event", status)
    }
    eventSink?.success(map)
    Log.d("BridPlayerEvent", "$type -> $status ($ref)")
  }

  private fun isAdEvent(code: String): Boolean =
    code.startsWith("ad") || code in setOf("r", "i", "v", "s", "ae", "adbstart")

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
    players.values.forEach { it.release() }
    players.clear()
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activityRef = WeakReference(binding.activity)
  }

  override fun onDetachedFromActivity() {
    activityRef = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activityRef = WeakReference(binding.activity)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activityRef = null
  }
}
