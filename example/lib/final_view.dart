import 'package:flutter/material.dart';
import 'package:simple_edge_detection/edge_detection.dart';

import 'cropping_preview.dart';
import 'image_view.dart';


class FinalView extends StatelessWidget {
  final String _imagePath;
  final EdgeDetectionResult _result;
  FinalView(this._imagePath, this._result, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: ImageView(imagePath: _imagePath),
   );
  }
}