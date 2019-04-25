import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class VideoView extends StatelessWidget {
  final String url;
  final void Function(VideoViewController controller) onViewCreated;

  VideoView({
    @required this.url,
    this.onViewCreated,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      return ClipRect(
        child: OverflowBox(
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.cover,
            alignment: Alignment.center,
            child: _VideoView(
                parentWidth: constraints.maxWidth,
                parentHeight: constraints.maxHeight,
                url: url,
                onViewCreated: onViewCreated,
                onPlatformCompleted: (VideoViewController controller) {
                  controller.load();
                  if (onViewCreated != null) {
                    onViewCreated(controller);
                  }
                }),
          ),
        ),
      );
    });
  }
}

typedef void _VideoViewCreatedCallback(VideoViewController controller);

class _VideoView extends StatefulWidget {
  final double parentWidth;
  final double parentHeight;
  final String url;
  final void Function(VideoViewController controller) onViewCreated;
  final _VideoViewCreatedCallback onPlatformCompleted;

  _VideoView({
    @required this.parentWidth,
    @required this.parentHeight,
    @required this.url,
    this.onViewCreated,
    this.onPlatformCompleted,
  });

  @override
  State<StatefulWidget> createState() {
    return _VideoViewState();
  }
}

class _VideoViewState extends State<_VideoView> {
  var _playerWidth = 1.0;
  var _playerHeight = 1.0;

  var _quarterTurns = 0;

  VideoViewController _controller;

  @override
  void initState() {
    super.initState();
    _playerWidth = widget.parentWidth;
    _playerHeight = widget.parentHeight;
  }

  @override
  Widget build(BuildContext context) {
    Widget platformView;
    if (Platform.isAndroid) {
      platformView = AndroidView(
        viewType: 'plugins.ko2ic.com/video_view/video_view',
        onPlatformViewCreated: _onPlatformViewCreated,
        gestureRecognizers: Set()
          ..add(Factory<OneSequenceGestureRecognizer>(
            () => TapGestureRecognizer(),
          )),
      );
    } else if (Platform.isIOS) {
      platformView = UiKitView(
        viewType: 'plugins.ko2ic.com/video_view/video_view',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else {
      throw UnsupportedError('Only android and ios are supported.');
    }

    return Visibility(
      visible: true,
      child: Container(
        color: Color(0x00000),
        width: _playerWidth,
        height: _playerHeight,
        child: RotatedBox(
          quarterTurns: _quarterTurns,
          child: platformView,
        ),
      ),
    );
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onPlatformCompleted == null) {
      return;
    }
    _controller = VideoViewController(
        id: id,
        url: widget.url,
        onReady: (width, height, rotationDegrees) {
          if (rotationDegrees == 90 || rotationDegrees == 270) {
            setState(() {
              _quarterTurns = 1;
            });
          }
        });
    widget.onPlatformCompleted(_controller);
  }
}

class VideoViewController {
  final String url;
  final void Function(dynamic, dynamic, int) onReady;

  VideoViewController({
    @required int id,
    @required this.url,
    this.onReady,
  }) : _channel = new MethodChannel('plugins.ko2ic.com/video_view/video_view/$id');

  final MethodChannel _channel;

  Future<void> stop() async {
    return _channel.invokeMethod('stop', null);
  }

  Future<void> load() async {
//    _channel.setMethodCallHandler((call) {
//      switch (call.method) {
//        case "onReady":
//          var movieWidth = call.arguments["width"];
//          var movieHeight = call.arguments["height"];
//          var rotationDegrees = call.arguments["rotationDegrees"] as int;
//          onReady(movieWidth, movieHeight, rotationDegrees);
//      }
//    });

    return _channel.invokeMethod('load', {
      "url": this.url,
    });
  }
}
