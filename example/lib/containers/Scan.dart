import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:simple_edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_edge_detection_example/components/CroppingPreview.dart';
import 'package:simple_edge_detection_example/components/ImageView.dart';
import 'package:simple_edge_detection_example/utils/EdgeDetector.dart';
import 'package:simple_edge_detection_example/utils/Helpers.dart';
import 'CropView.dart';



class Scan extends StatefulWidget {
  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  CameraController controller;
  List<CameraDescription> cameras;
  String imagePath;
  String croppedImagePath;
  EdgeDetectionResult edgeDetectionResult;
  bool detectingEdges = false;


  @override
  void initState() {
    super.initState();
    checkForCameras().then((value) {
      _initializeController();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.transparent,
      body: Stack(
          children: <Widget>[
            _getMainWidget(),
            _getBottomBar(),
          ],
      ),
    );
  }

  Widget _getMainWidget() {

    if (controller == null) {
      return Container();
    }

    if (croppedImagePath != null) {
      return ImageView(imagePath: croppedImagePath);
    }


    if (imagePath == null && edgeDetectionResult == null) {
      final size = MediaQuery.of(context).size;
      final deviceRatio = size.width / size.height;
      final xScale = controller.value.aspectRatio / deviceRatio;
// Modify the yScale if you are in Landscape
      final yScale = 1.0;
      return Container(
        child: AspectRatio(
          aspectRatio: deviceRatio,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.diagonal3Values(xScale, yScale, 1),
            child: Stack(
              fit: StackFit.loose,
              children: [


                CameraPreview(
                controller
              ),

                Positioned.fill(
                  child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        // margin: EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white)
                        ),
                        width: controller != null ? controller.value.previewSize.width/4.0 : 100,
                        height: controller != null ? controller.value.previewSize.height/1.35 : 200,

                      )
                  ),
                ),
                Positioned.fill(
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(left: 35, top: 50),
                        child: IconButton(
                          color: Colors.white,
                          icon: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                              Navigator.of(context).pop();
                          },
                        ),
                      )
                  ),
                ),


    ],
            ),
          ),
        ),
      );
    }

    if (detectingEdges) {
      return  ImagePreview(
        imagePath: imagePath,
      );
    }

    return
        ImagePreview(
          imagePath: imagePath,
          edgeDetectionResult: edgeDetectionResult,
    );
  }

  Future<void> checkForCameras() async {
    cameras = await availableCameras();
  }

  void _initializeController() {
    checkForCameras();
    if (cameras.length == 0) {
      log('No cameras detected');
      return;
    }

    controller = CameraController(
        cameras[0],
        ResolutionPreset.max,
        enableAudio: false
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget _getButtonRow() {
    if (imagePath != null) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            if (croppedImagePath == null) {
              return _processImage(
                imagePath, edgeDetectionResult
              );
            }

            setState(() {
              imagePath = null;
              edgeDetectionResult = null;
              croppedImagePath = null;
            });
          },
        ),
      );
    }
    return FloatingActionButton(
        foregroundColor: Colors.white,
        child: Icon(Icons.camera_alt),
        onPressed: onTakePictureButtonPressed,
      );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          foregroundColor: Colors.white,
          child: Icon(Icons.camera_alt),
          onPressed: onTakePictureButtonPressed,
        ),
        SizedBox(width: 16),
        FloatingActionButton(
          foregroundColor: Colors.white,
          child: Icon(Icons.image),
          onPressed: _onGalleryButtonPressed,
        ),
      ]
    );
  }

  // String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      log('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getTemporaryDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${Helpers.timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      log(e.toString());
      return null;
    }
    return filePath;
  }
  
  

  Future _detectEdges(String filePath) async {
    if (!mounted || filePath == null) {
      return;
    }

    // setState(() {
    //   imagePath = filePath;
    // });

    EdgeDetectionResult result = await EdgeDetector().detectEdges(filePath);


    


    // setState(() {
    //   edgeDetectionResult = result;
    // });
  }

  Future _processImage(String filePath, EdgeDetectionResult edgeDetectionResult) async {
    if (!mounted || filePath == null) {
      return;
    }

    // bool result = await EdgeDetector().processImage(filePath, edgeDetectionResult);

    // if (result == false) {
    //   return;
    // }

    setState(() {

      imageCache.clearLiveImages();
      imageCache.clear();
      croppedImagePath = imagePath;
    });
  }

//   Future<String> createCopy(String _temp) async {
//     final File image = new File(_temp);
//
//     final Directory extDir = await getTemporaryDirectory();
//     final String dirPath = '${extDir.path}/Pictures/flutter_test';
//     await Directory(dirPath).create(recursive: true);
//     final String filePath = '$dirPath/${timestamp()}-temp.jpg';
// // copy the file to a new path
//     final File newImage = await image.copy(filePath);
//     return filePath;
//   }

  void onTakePictureButtonPressed() async {
    String filePath = await takePicture();

    String  tempPath = await Helpers.createCopy(filePath);


    log('Picture saved to $filePath');

    Helpers.navigateTo(context, CropView(filePath, tempPath));

    // setState(() {
    //   imagePath = filePath;
    //   detectingEdges = true;
    // });
    //
    // await _detectEdges(filePath);
  }

  void _onGalleryButtonPressed() async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    final filePath = pickedFile.path;

    log('Picture saved to $filePath');

    _detectEdges(filePath);
  }

  Padding _getBottomBar() {
    return Padding(
      padding: EdgeInsets.all(18.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: _getButtonRow()
      )
    );
  }
}