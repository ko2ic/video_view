package com.ko2ic.video_view

import android.content.Context
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

/**
 * Factory class of VideoPlayer for Android.
 */
class VideoViewFactory(private val registrar: PluginRegistry.Registrar) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {


    override fun create(context: Context, id: Int, parameter: Any?): PlatformView {
        return VideoView(context, id, registrar.messenger(), registrar.textures())
    }

}