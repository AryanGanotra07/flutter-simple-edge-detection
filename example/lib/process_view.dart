import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_edge_detection_example/models/response.dart';
import 'package:simple_edge_detection_example/services/ImageService.dart';

import 'image_view.dart';

class ProcessView extends StatefulWidget {
  final String _imagePath;
  ProcessView(this._imagePath, {Key key}) : super(key: key);
  @override
  _ProcessViewState createState() => _ProcessViewState();
}

class _ProcessViewState extends State<ProcessView> {
  Future<MyResponse> call;
  @override
  void initState() {
    super.initState();
    // call = ImageService.fetchResponse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Process"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ImageView(
                imagePath: widget._imagePath,
              ),
            ),
            FutureBuilder<MyResponse>(
              future: call,
              builder:
                  (BuildContext context, AsyncSnapshot<MyResponse> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text('Loading....');
                  default:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    else
                      return Text('Result: ${snapshot.data}');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
