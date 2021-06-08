import 'package:flutter/material.dart';
import 'package:simple_edge_detection_example/components/ImageModeComponent.dart';


class ImageModeContainer extends StatelessWidget
{


  Widget _buildMainWidget() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           ImageModeComponent(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return  _buildMainWidget();

  }

}