import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:simple_edge_detection/edge_detection.dart';
import 'package:simple_edge_detection_example/MyToast.dart';
import 'package:simple_edge_detection_example/final_view.dart';
import 'package:simple_edge_detection_example/image_view.dart';
import 'edge_detector.dart';
import 'cropping_preview.dart';

class CropView extends StatefulWidget {
  final EdgeDetectionResult _result;
  final String _imagePath;
  CropView(this._imagePath, this._result, { Key key }) : super(key: key);

  @override
  _CropViewState createState() => _CropViewState();
}

class _CropViewState extends State<CropView> {
  EdgeDetectionResult _result;
  String _imagePath;
  String _croppedImagePath;

  @override
  void initState() {
    super.initState();
    _imagePath = widget._imagePath;
    _result = widget._result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(_croppedImagePath == null ? Icons.check : Icons.save),
        onPressed: () async {
          if (_croppedImagePath == null ) {
            bool result = await EdgeDetector().processImage(
                _imagePath, _result);
            imageCache.clearLiveImages();
            imageCache.clear();
            setState(() {
              _croppedImagePath = _imagePath;
            });
          }
          else {
            MyToast.showToast("Saving to gallery..");
            GallerySaver.saveImage(_imagePath).then((value) => {
              MyToast.showToast("Saved to gallery!")
            });
          }
          }
      ),
      appBar: AppBar(
        title: Text("Edit"),
      ),
      body: _croppedImagePath != null ? ImageView(
        imagePath: _croppedImagePath,
      ) : ImagePreview(
      imagePath: _imagePath,
      edgeDetectionResult: _result,
    ),
    );
  }
}