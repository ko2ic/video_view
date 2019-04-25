package com.ko2ic.video_view

import android.content.ComponentName
import android.content.Context
import android.net.Uri
import android.support.v4.media.session.MediaSessionCompat
import android.support.v4.media.session.PlaybackStateCompat
import android.view.MotionEvent
import android.view.ViewGroup
import android.widget.LinearLayout
import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.ExoPlayerFactory
import com.google.android.exoplayer2.Player
import com.google.android.exoplayer2.SimpleExoPlayer
import com.google.android.exoplayer2.source.ExtractorMediaSource
import com.google.android.exoplayer2.trackselection.DefaultTrackSelector
import com.google.android.exoplayer2.ui.AspectRatioFrameLayout.RESIZE_MODE_ZOOM
import com.google.android.exoplayer2.ui.PlayerView
import com.google.android.exoplayer2.upstream.DefaultDataSourceFactory
import com.google.android.exoplayer2.util.Util
import com.google.android.exoplayer2.video.VideoListener
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import io.flutter.view.TextureRegistry
import io.flutter.view.TextureRegistry.SurfaceTextureEntry
import android.view.GestureDetector.SimpleOnGestureListener as SimpleOnGestureListener1


class VideoView(
    private val context: Context,
    id: Int,
    messenger: BinaryMessenger,
    private val textures: TextureRegistry
) : PlatformView,
    MethodChannel.MethodCallHandler {

    private var container: ViewGroup?

    private var player: ExoPlayer? = null

    private val channel = MethodChannel(messenger, "plugins.ko2ic.com/video_view/video_view/$id")

    init {
        channel.setMethodCallHandler(this)

        container = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
            descendantFocusability = ViewGroup.FOCUS_BLOCK_DESCENDANTS
        }
    }


    override fun getView() = container

    override fun dispose() {
        val playerView = view as PlayerView
        val expoPlayer = playerView.player as SimpleExoPlayer
        container?.removeAllViews()
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            "load" -> load(methodCall, result)
            "play" -> play(result)
            "stop" -> stop(result)
            else -> result.notImplemented()
        }
    }

    private fun load(call: MethodCall, result: MethodChannel.Result) {
        val arguments: Map<String, Any> = call.arguments()

        val url = arguments["url"] as String

        val textureEntry: SurfaceTextureEntry = textures.createSurfaceTexture()

        val trackSelector = DefaultTrackSelector()
        val exoPlayer = ExoPlayerFactory.newSimpleInstance(context, trackSelector)
        exoPlayer.playWhenReady = false
        exoPlayer.repeatMode = Player.REPEAT_MODE_OFF

        this.player = exoPlayer

        val view = PlayerView(context)
        view.useController = false
        view.player = exoPlayer
        view.resizeMode = RESIZE_MODE_ZOOM

        container?.addView(view)

        container?.setOnTouchListener { _, event ->
            if (event.action == MotionEvent.ACTION_DOWN) {
                exoPlayer.playWhenReady = true
                exoPlayer.playbackState
            }
            true
        }


        val componentName = ComponentName(context, "video_view")
        val mediaSession = MediaSessionCompat(context, "video_view", componentName, null)

        val playbackStateCompactBuilder = PlaybackStateCompat.Builder()
        playbackStateCompactBuilder.setActions(
            PlaybackStateCompat.ACTION_PLAY and
                    PlaybackStateCompat.ACTION_PAUSE and
                    PlaybackStateCompat.ACTION_FAST_FORWARD
        )
        mediaSession.setPlaybackState(playbackStateCompactBuilder.build())
        mediaSession.isActive = true

        val uri = Uri.parse(url)
        val dataSourceFactory = DefaultDataSourceFactory(context, Util.getUserAgent(context, "video_view"), null)
        val mediaSource = ExtractorMediaSource.Factory(dataSourceFactory).createMediaSource(uri)

        exoPlayer.addVideoListener(object : VideoListener {
            override fun onSurfaceSizeChanged(width: Int, height: Int) {
                super.onSurfaceSizeChanged(width, height)
            }

            override fun onVideoSizeChanged(
                width: Int,
                height: Int,
                unappliedRotationDegrees: Int,
                pixelWidthHeightRatio: Float
            ) {
                super.onVideoSizeChanged(width, height, unappliedRotationDegrees, pixelWidthHeightRatio)
            }

            override fun onRenderedFirstFrame() {
                super.onRenderedFirstFrame()

                Thread.sleep(2000)
                exoPlayer.release()
            }
        })

        exoPlayer.prepare(mediaSource)
        result.success(null)
    }


    private fun play(result: MethodChannel.Result) {
        this.player?.playWhenReady = true
        this.player?.playbackState
        result.success(null)
    }

    private fun stop(result: MethodChannel.Result) {
        this.player?.stop()

        result.success(null)
    }

}