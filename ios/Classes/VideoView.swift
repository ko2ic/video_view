
import AVFoundation
import AVKit
import Flutter
import Foundation

class VideoView: NSObject, FlutterPlatformView {
    private var container: UIView!
    private let channel: FlutterMethodChannel!

    private var player: AVPlayer!

    init(frame: CGRect, viewIdentifier viewId: Int64, messenger: FlutterBinaryMessenger) {
        container = UIView(frame: frame)
        channel = FlutterMethodChannel(name: "plugins.ko2ic.com/video_view/video_view/\(viewId)", binaryMessenger: messenger)

        super.init()

        container.backgroundColor = UIColor.clear
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            self.handle(call, result: result)
        })
    }

    func view() -> UIView {
        return container!
    }

    private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "load":
            load(call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func load(_ call: FlutterMethodCall, result _: @escaping FlutterResult) {
        let argument = call.arguments as! Dictionary<String, Any>
        let url = argument["url"] as! String

        let parentWidth = argument["parentWidth"] as! Double
        let parentHeight = argument["parentHeight"] as! Double

        player = AVPlayer(url: URL(string: url)!)

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: parentWidth, height: parentHeight)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view().layer.addSublayer(playerLayer)

        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        view().addGestureRecognizer(tap)
    }

    @objc func onClick(gesture _: UITapGestureRecognizer) {
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }

    var isPlaying: Bool {
        return player.rate != 0 && player.error == nil
    }
}
