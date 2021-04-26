import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:simple_edge_detection/edge_detection.dart';
import 'package:simple_edge_detection_example/MyToast.dart';
import 'package:simple_edge_detection_example/constants/contant.dart';
import 'package:simple_edge_detection_example/final_view.dart';
import 'package:simple_edge_detection_example/image_view.dart';
import 'package:simple_edge_detection_example/image_view_small.dart';
import 'package:simple_edge_detection_example/models/invoice.dart';
import 'package:simple_edge_detection_example/providers/InvoiceProvider.dart';
import 'package:simple_edge_detection_example/services/ImageService.dart';
import 'edge_detector.dart';
import 'cropping_preview.dart';
import 'dart:convert';
import 'dart:io' as Io;
import 'package:simple_edge_detection_example/process_view.dart';

//
// class ProcessedResult {
//   bool _processing = true;
//   bool _success = false;
// }

class CropView extends StatefulWidget {
  // final EdgeDetectionResult _result;
  final String _imagePath;
  final String _tempPath;

  CropView(this._imagePath, this._tempPath, {Key key}) : super(key: key);

  @override
  _CropViewState createState() => _CropViewState();
}

class _CropViewState extends State<CropView> {
  EdgeDetectionResult _result;
  String _imagePath;
  String _croppedImagePath;
  String _tempPath;
  Future<EdgeDetectionResult> _edgesCall;
  EdgeDetectionResult _tempResult;
  bool _editLayout = false;
  // ProcessedResult _processedResult = new ProcessedResult();
  bool _processing;
  bool _success = false;

  @override
  void initState() {
    super.initState();
    _imagePath = widget._imagePath;
    // _result = widget._result;
    _nameController.text = timestamp();
    _tempPath = widget._tempPath;

    _edgesCall = EdgeDetector().detectEdges(_imagePath);
  }

  Future<String> createCopy(String _temp) async {
    final File image = new File(_temp);

    final Directory extDir = await getTemporaryDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}-temp.jpg';
// copy the file to a new path
    final File newImage = await image.copy(filePath);
    return filePath;
  }

  String timestamp() =>
      DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();
  final _nameController = TextEditingController();

  Widget _getMain() {
    return FutureBuilder<EdgeDetectionResult>(
      future: _edgesCall, // async work
      builder: (BuildContext context,
          AsyncSnapshot<EdgeDetectionResult> snapshot) {
        print(snapshot);
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return ImagePreview(
              imagePath: _imagePath,
            );
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else {
              if (_tempResult == null) {
                _tempResult = snapshot.data;
              }
              _result = snapshot.data;
              print("resetting...");
              return
                ImagePreview(
                  imagePath: _imagePath,
                  edgeDetectionResult: snapshot.data,
                );
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //     child: IconButton(
      //
      //     icon : Icon(_croppedImagePath == null ? Icons.check : Icons.check),
      //     onPressed: () async {
      //
      //       //
      //       // showModalBottomSheet<void>(
      //       //   context: context,
      //       //   builder: (BuildContext context) {
      //       //     return Container(
      //       //       height: 400,
      //       //       child: Center(
      //       //         child: Column(
      //       //           mainAxisAlignment: MainAxisAlignment.center,
      //       //           mainAxisSize: MainAxisSize.min,
      //       //           children: <Widget>[
      //       //             ImageViewSmall(
      //       //               imagePath: _croppedImagePath,
      //       //             ),
      //       //             // const Text('Modal BottomSheet'),
      //       //             // ElevatedButton(
      //       //             //   child: const Text('Close BottomSheet'),
      //       //             //   onPressed: () => Navigator.pop(context),
      //       //             // )
      //       //           ],
      //       //         ),
      //       //       ),
      //       //     );
      //       //   },
      //       // );
      //       if (_croppedImagePath == null) {
      //
      //         bool result =
      //         await EdgeDetector().processImage(_imagePath, _result);
      //         imageCache.clearLiveImages();
      //         imageCache.clear();
      //         setState(() {
      //           _croppedImagePath = _imagePath;
      //           _editLayout = false;
      //           // _imagePath = _tempPath;
      //         });
      //       } else {
      //         //              Navigator.push(
      //         //   context,
      //         //   MaterialPageRoute(builder: (context) => ProcessView(_imagePath)),
      //         // );
      //         final bytes = Io.File(_imagePath).readAsBytesSync();
      //         String img64 = base64Encode(bytes);
      //         String name = _nameController.text;
      //         // ImageService.fetchResponse(name, img64);
      //         MyToast.showToast("Sent for processing. Scan next.");
      //         MyInvoice _invoice = new MyInvoice();
      //         _invoice.name = name;
      //         _invoice.img64 = img64;
      //         Provider.of<InvoiceProvider>(context, listen: false)
      //             .addInvoice(_invoice);
      //         Navigator.pop(context);
      //         // print(img64);
      //         // MyToast.showToast("Saving to gallery..");
      //         // GallerySaver.saveImage(_imagePath).then((value) => {
      //         //   MyToast.showToast("Saved to gallery!")
      //         // });
      //       }
      //     })),
      appBar: AppBar(
          title: Text("Edit"),
          actions: [
      IconButton(
      icon: Icon(Icons.undo_rounded),
      onPressed: () async {
        // _imagePath = await createCopy(_tempPath);
        setState(() {
          _croppedImagePath = null;
          _result = _tempResult;
          _editLayout = true;
        });
      },
    ),
    // IconButton(
    //   icon: Icon(Icons.rotate_right_rounded),
    //   onPressed: () async {
    //     bool result = await EdgeDetector().rotateImage(_imagePath);
    //     imageCache.clearLiveImages();
    //     imageCache.clear();
    //     _edgesCall = EdgeDetector().detectEdges(_imagePath);
    //     // setState(() {
    //     //
    //     // });
    //   },
    // ),
    IconButton(

    icon : Icon(_croppedImagePath == null ? Icons.check_rounded : Icons.upload_rounded),
    onPressed: () async {

    //
    // showModalBottomSheet<void>(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return Container(
    //       height: 400,
    //       child: Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           mainAxisSize: MainAxisSize.min,
    //           children: <Widget>[
    //             ImageViewSmall(
    //               imagePath: _croppedImagePath,
    //             ),
    //             // const Text('Modal BottomSheet'),
    //             // ElevatedButton(
    //             //   child: const Text('Close BottomSheet'),
    //             //   onPressed: () => Navigator.pop(context),
    //             // )
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
    if (_croppedImagePath == null) {

    bool result =
    await EdgeDetector().processImage(_imagePath, _tempPath, _result);
    imageCache.clearLiveImages();
    imageCache.clear();
    // setState(() {
    // _croppedImagePath = _tempPath;
    // // _editLayout = false;
    // // _imagePath = _tempPath;
    // });
    final  width = MediaQuery.of(context). size. width;
      showModalBottomSheet<void>(
        isDismissible: false,
      enableDrag: false,
      context: context,
          builder: (context) {
            bool _processingM;
            bool _successM;
            final bytes = Io.File(_tempPath).readAsBytesSync();
            String img64 = base64Encode(bytes);
            String name = _nameController.text;
            MyInvoice _invoice = new MyInvoice();
            _invoice.name = name;
            _invoice.img64 = img64;

            return StatefulBuilder(

              builder: (BuildContext context, StateSetter setModalState /*You can rename this!*/) {

              return Container(
          height: 240,
          color: Colors.blueAccent,
          child: Container(
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.file(
                    File(_tempPath),
                    width: width/2.2,

                ),
                Expanded(
                  child: _processingM == null ?
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                  const Text('Send Invoice For Processing', style: TextStyle(color: Colors.white),),
                            RaisedButton(onPressed: () async {
                                setModalState(() {
                                  _processingM = true;
    });
                              bool success = await ImageService.fetchResponse(name, img64);
                              setModalState(() {
                                _processingM = false;
                                _successM = success;
                              });
                            } , child: Text("Process"),),
                          ],
                        ),
                      ) : _processingM?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const CircularProgressIndicator(backgroundColor: Colors.white,),
                      const Text('Processing Invoice Quality', style: TextStyle(color: Colors.white),),
                    ],
                  ) : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(_successM? "Invoice Quality Passed" : "Invoice Quality Failed", style: TextStyle(color: Colors.white),),
                      RaisedButton(onPressed: () {
                        if (_successM) {

                          Provider.of<InvoiceProvider>(context, listen: false)
                              .addInvoice(_invoice);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                        else {
                          Provider.of<InvoiceProvider>(context, listen: false)
                              .addInvoice(_invoice);
                          Navigator.of(context).pop();
                        }

                      }, child: Text(_successM? "Scan Next" : "Scan Again"),),
                      RaisedButton(onPressed: () async {
                        MyToast.showToast("Saving to gallery..");
                        GallerySaver.saveImage(_tempPath).then((value) => {
                          MyToast.showToast("Saved to gallery!")
                        });

                      }, child: Text("Save to device"),),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
            );
        });


    } else {
    //              Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ProcessView(_imagePath)),
    // );
    final bytes = Io.File(_tempPath).readAsBytesSync();
    String img64 = base64Encode(bytes);
    String name = _nameController.text;
    // MyToast.showToast("Processing the image quality.");
    MyInvoice _invoice = new MyInvoice();

    setState(() {
      _processing = true;
    });
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Dialog Title'),
          content: _processing? Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const CircularProgressIndicator(backgroundColor: Colors.white,),
              const Text('Processing Invoice Quality'),
            ],
          ) : Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text('Processing Invoice Quality',),
              RaisedButton(onPressed: () {
                print("hello");
              }, child: Text(_success? "Scan Next" : "Scan Again"),),
            ],
          ),

        )
    );

    // bool success = await ImageService.fetchResponse(name, img64);
    // setState(() {
    //   _processing = false;
    //   _success = success;
    // });
    // ImageService.fetchResponse(name, img64).then((value) => {
    //
    // _invoice.name = name,
    // _invoice.img64 = img64,
    // Provider.of<InvoiceProvider>(context, listen: false)
    //     .addInvoice(_invoice),
    // Navigator.pop(context),
    // });
    //
    // print(img64);
    // MyToast.showToast("Saving to gallery..");
    // GallerySaver.saveImage(_imagePath).then((value) => {
    //   MyToast.showToast("Saved to gallery!")
    // });
    }
    }),
    ],
    ),
    body: _croppedImagePath == null && _editLayout == false
    ?_getMain() : _editLayout? ImagePreview(
    imagePath: _imagePath,
    edgeDetectionResult: _result,
    ) : _showProcessing(),
    //   body: _croppedImagePath != null
    //       ? Column(
    //       children : [
    //   Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: TextFormField(
    //       controller: _nameController ,
    //
    //     decoration: InputDecoration(
    //     labelText: 'Enter Name',
    //
    //     ),
    // ),
    //   ),
    //
    // Expanded(
    //   child: ImageView(
    //             imagePath: _croppedImagePath,
    //           ),
    // )])
    //       :ImagePreview(
    //     imagePath: _imagePath,
    //     edgeDetectionResult: _result,
    //   ),
    );
    }
  Widget _showProcessing() {
      return Container(
        child: Column(
          children:[
            Expanded(
              child: ImagePreview(
                imagePath: _croppedImagePath,
              ),
            ),
        // _processing == null ? Container() : _processing? Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //           children: <Widget>[
        //             const CircularProgressIndicator(backgroundColor: Colors.white,),
        //             const Text('Processing Invoice Quality'),
        //           ],
        //         ) : Column(
        //           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //           children: [
        //             const Text('Processing Invoice Quality',),
        //             RaisedButton(onPressed: () {
        //               print("hello");
        //             }, child: Text(_success? "Scan Next" : "Scan Again"),),
        //           ],
        //         ),
          ]
         
        ),
      );
  }
  }
  
 

// _croppedImagePath != null
//           ? ImageView(
//               imagePath: _croppedImagePath,
//             )
//           :
