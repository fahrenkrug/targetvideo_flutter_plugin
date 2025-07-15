package com.targetvideo.flutter_plugin

import android.content.Context
import android.view.View
import android.widget.FrameLayout
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
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
    viewRegistry[viewId.toLong()]?.container
}

/** PlatformView wrapper that ensures SurfaceView stays within Flutter layout bounds. */
class NativeVideoView(context: Context) : PlatformView {

  // This FrameLayout will hold the SurfaceView and enforce its layout
  val container: FrameLayout = object : FrameLayout(context) {
    override fun onLayout(changed: Boolean, l: Int, t: Int, r: Int, b: Int) {
      super.onLayout(changed, l, t, r, b)
      for (i in 0 until childCount) {
        val child = getChildAt(i)
        child.layout(0, 0, width, height)
      }
    }
  }

  init {
    container.layoutParams = FrameLayout.LayoutParams(
      FrameLayout.LayoutParams.MATCH_PARENT,
      FrameLayout.LayoutParams.MATCH_PARENT
    )
  }

  override fun getView(): View = container

  override fun dispose() = Unit
}
