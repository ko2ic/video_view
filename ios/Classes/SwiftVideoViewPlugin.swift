import Flutter
import UIKit

public class SwiftVideoViewPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        registrar.register(VideoViewFactory(messenger: registrar.messenger()), withId: "plugins.ko2ic.com/video_view/video_view")
    }
}
