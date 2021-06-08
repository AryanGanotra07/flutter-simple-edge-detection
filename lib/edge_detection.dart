import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

class Coordinate extends Struct {
  @Double()
  double x;

  @Double()
  double y;

  factory Coordinate.allocate(double x, double y) =>
      calloc<Coordinate>().ref
        ..x = x
        ..y = y;
}

class NativeDetectionResult extends Struct {
  Pointer<Coordinate> topLeft;
  Pointer<Coordinate> topRight;
  Pointer<Coordinate> bottomLeft;
  Pointer<Coordinate> bottomRight;

  factory NativeDetectionResult.allocate(
      Pointer<Coordinate> topLeft,
      Pointer<Coordinate> topRight,
      Pointer<Coordinate> bottomLeft,
      Pointer<Coordinate> bottomRight) =>
      calloc<NativeDetectionResult>().ref
        ..topLeft = topLeft
        ..topRight = topRight
        ..bottomLeft = bottomLeft
        ..bottomRight = bottomRight;
}

class EdgeDetectionResult {
  EdgeDetectionResult({
    @required this.topLeft,
    @required this.topRight,
    @required this.bottomLeft,
    @required this.bottomRight,
  });

  Offset topLeft;
  Offset topRight;
  Offset bottomLeft;
  Offset bottomRight;
}

typedef DetectEdgesFunction = Pointer<NativeDetectionResult> Function(
  Pointer<Utf8> imagePath
);

typedef RotateImageFunction = Pointer<NativeDetectionResult> Function(
    Pointer<Utf8> imagePath
    );



typedef process_image_function = Int8 Function(
  Pointer<Utf8> imagePath,
    Pointer<Utf8> tempPath,
  Double topLeftX,
  Double topLeftY,
  Double topRightX,
  Double topRightY,
  Double bottomLeftX,
  Double bottomLeftY,
  Double bottomRightX,
  Double bottomRightY
);

typedef ProcessImageFunction = int Function(
  Pointer<Utf8> imagePath,
    Pointer<Utf8> tempPath,
  double topLeftX,
  double topLeftY,
  double topRightX,
  double topRightY,
  double bottomLeftX,
  double bottomLeftY,
  double bottomRightX,
  double bottomRightY
);

// https://github.com/dart-lang/samples/blob/master/ffi/structs/structs.dart

class EdgeDetection {
  static Future<EdgeDetectionResult> detectEdges(String path) async {
    DynamicLibrary nativeEdgeDetection = _getDynamicLibrary();

    final detectEdges = nativeEdgeDetection
        .lookup<NativeFunction<DetectEdgesFunction>>("detect_edges")
        .asFunction<DetectEdgesFunction>();

    NativeDetectionResult detectionResult = detectEdges(StringUtf8Pointer(path).toNativeUtf8()).ref;

    return EdgeDetectionResult(
        topLeft: Offset(
            detectionResult.topLeft.ref.x, detectionResult.topLeft.ref.y
        ),
        topRight: Offset(
            detectionResult.topRight.ref.x, detectionResult.topRight.ref.y
        ),
        bottomLeft: Offset(
            detectionResult.bottomLeft.ref.x, detectionResult.bottomLeft.ref.y
        ),
        bottomRight: Offset(
            detectionResult.bottomRight.ref.x, detectionResult.bottomRight.ref.y
        )
    );
  }

  static Future<bool> rotateImage(String path) async {
    print("Reached here");
    DynamicLibrary nativeEdgeDetection = _getDynamicLibrary();
    final rotateImagee = nativeEdgeDetection
        .lookup<NativeFunction<RotateImageFunction>>("rotate_image")
        .asFunction<RotateImageFunction>();
    print("Returning true");
    return rotateImagee(StringUtf8Pointer(path).toNativeUtf8()) == 1;

    return true;
  }

  static Future<bool> processImage(String path, String tempPath, EdgeDetectionResult result) async {
    DynamicLibrary nativeEdgeDetection = _getDynamicLibrary();


    final processImage = nativeEdgeDetection
        .lookup<NativeFunction<process_image_function>>("process_image")
        .asFunction<ProcessImageFunction>();


    return processImage(
        StringUtf8Pointer(path).toNativeUtf8(),
        StringUtf8Pointer(tempPath).toNativeUtf8(),
        result.topLeft.dx,
        result.topLeft.dy,
        result.topRight.dx,
        result.topRight.dy,
        result.bottomLeft.dx,
        result.bottomLeft.dy,
        result.bottomRight.dx,
        result.bottomRight.dy
    ) == 1;
  }

  static DynamicLibrary _getDynamicLibrary() {
    final DynamicLibrary nativeEdgeDetection = Platform.isAndroid
        ? DynamicLibrary.open("libnative_edge_detection.so")
        : DynamicLibrary.process();
    return nativeEdgeDetection;
  }
}