import 'dart:io';
import 'package:flutter/material.dart';

class ImageViewSmall extends StatefulWidget {
  ImageViewSmall({this.imagePath});

  final String imagePath;

  @override
  _ImageViewSmallState createState() => _ImageViewSmallState();
}

class _ImageViewSmallState extends State<ImageViewSmall> {
  GlobalKey imageWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext mainContext) {
    return Container(
      height: 200,
      child: Center(
          child: Image.file(File(widget.imagePath), fit: BoxFit.contain)),
    );
  }
}
