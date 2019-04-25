import 'dart:math';

import 'package:flutter/material.dart';
import 'package:video_view/video_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _items = [];

  VideoViewController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: _items.length,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 100.0,
                child: Card(
                  child: Center(
                    child: VideoView(
                      url: _items[index],
                      onViewCreated: (controller) {
                        _controller = controller;
                      },
                    ),
                  ),
                ),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            //await _controller?.stop();
            var list = [
              "https://raw.githubusercontent.com/wiki/ko2ic/image_downloader/images/sample.mov",
              "https://raw.githubusercontent.com/wiki/ko2ic/image_downloader/images/sample.m4v",
              "https://raw.githubusercontent.com/wiki/ko2ic/image_downloader/images/sample.mp4",
              "https://raw.githubusercontent.com/wiki/ko2ic/image_downloader/images/sample2.MOV"
            ];
            var index = Random().nextInt(4);
            setState(() {
              _items.add(list[3]);
            });
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
