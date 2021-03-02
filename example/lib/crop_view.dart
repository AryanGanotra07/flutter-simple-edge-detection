import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:simple_edge_detection/edge_detection.dart';
import 'package:simple_edge_detection_example/MyToast.dart';
import 'package:simple_edge_detection_example/final_view.dart';
import 'package:simple_edge_detection_example/image_view.dart';
import 'package:simple_edge_detection_example/models/invoice.dart';
import 'package:simple_edge_detection_example/providers/InvoiceProvider.dart';
import 'package:simple_edge_detection_example/services/ImageService.dart';
import 'edge_detector.dart';
import 'cropping_preview.dart';
import 'dart:convert';
import 'dart:io' as Io;
import 'package:simple_edge_detection_example/process_view.dart';

class CropView extends StatefulWidget {
  final EdgeDetectionResult _result;
  final String _imagePath;
  CropView(this._imagePath, this._result, {Key key}) : super(key: key);

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
            if (_croppedImagePath == null) {
              bool result =
                  await EdgeDetector().processImage(_imagePath, _result);
              imageCache.clearLiveImages();
              imageCache.clear();
              setState(() {
                _croppedImagePath = _imagePath;
              });
            } else {
              //              Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ProcessView(_imagePath)),
              // );
              final bytes = Io.File(_imagePath).readAsBytesSync();
              String img64 = base64Encode(bytes);
              String name = DateTime.now().toString();
              ImageService.fetchResponse(name, img64);
              MyToast.showToast("Sent for processing. Scan next.");
              MyInvoice _invoice = new MyInvoice();
              _invoice.name = name;
              _invoice.img64 = img64;
              Provider.of<InvoiceProvider>(context, listen: false)
                  .addInvoice(_invoice);
              Navigator.pop(context);
              // print(img64);
              // MyToast.showToast("Saving to gallery..");
              // GallerySaver.saveImage(_imagePath).then((value) => {
              //   MyToast.showToast("Saved to gallery!")
              // });
            }
          }),
      appBar: AppBar(
        title: Text("Edit"),
      ),
      body: _croppedImagePath != null
          ? ImageView(
              imagePath: _croppedImagePath,
            )
          : ImagePreview(
              imagePath: _imagePath,
              edgeDetectionResult: _result,
            ),
    );
  }
}
