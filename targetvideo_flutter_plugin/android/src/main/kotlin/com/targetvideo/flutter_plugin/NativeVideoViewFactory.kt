package com.targetvideo.flutter_plugin

import android.content.Context
import android.view.View
import android.widget.FrameLayout
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec
import java.util.concurrent.ConcurrentHashMap

/** Factory that creates native Android views for Flutter. */
class NativeVideoViewFactory(
  private val messenger: BinaryMessenger
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

  private val viewRegistry: ConcurrentHashMap<Long, NativeVideoView> = ConcurrentHashMap()

  override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
    val platformView = NativeVideoView(context)
    viewRegistry[viewId.toLong()] = platformView
    return platformView
  }

  /** Returns the underlying FrameLayout for a given viewId. */
  fun getViewHolder(viewId: Int): FrameLayout? =
    viewRegistry[viewId.toLong()]?.view
}

/** Lightweight PlatformView wrapping a simple FrameLayout. */
class NativeVideoView(context: Context) : PlatformView {
  val view: FrameLayout = FrameLayout(context)

  override fun getView(): View = view

  override fun dispose() = Unit   // No-op – real cleanup happens in plugin.release()
}
