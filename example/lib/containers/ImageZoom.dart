import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simple_edge_detection_example/models/invoice.dart';
import 'package:photo_view/photo_view.dart';



class ImageZoom extends StatelessWidget {
  final MyInvoice _invoice;
  ImageZoom(this._invoice);
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text(_invoice.name),
     ),
     body: Container(
     child: PhotoView(
    imageProvider: MemoryImage(base64Decode(_invoice.img64))
     ),
     )
   );
  }

}