import 'package:flutter/material.dart';
import 'package:simple_edge_detection_example/components/ImageModeComponent.dart';
import 'package:simple_edge_detection_example/components/InvoicesList.dart';

import 'ImageModeContainer.dart';



class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ImageModeComponent(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InvoicesList(),
          ),
        ],
      ),
    );
  }

}