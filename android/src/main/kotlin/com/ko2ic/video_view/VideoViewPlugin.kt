package com.ko2ic.video_view

import io.flutter.plugin.common.PluginRegistry.Registrar

class VideoViewPlugin {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            registrar
                .platformViewRegistry()
                .registerViewFactory(
                    "plugins.ko2ic.com/video_view/video_view", VideoViewFactory(registrar)
                )
        }
    }
}
