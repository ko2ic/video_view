#import "VideoViewPlugin.h"
#import <video_view/video_view-Swift.h>

@implementation VideoViewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVideoViewPlugin registerWithRegistrar:registrar];
}
@end
