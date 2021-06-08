import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;


class Helpers {

  static Future<String> createCopy(String oldPath) async {
    final File image = new File(oldPath);
    final Directory extDir = await getTemporaryDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String newPath = '$dirPath/${timestamp()}-temp.jpg';
// copy the file to a new path
    final File newImage = await image.copy(newPath);
    return newPath;
  }

  static String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  static navigateTo(BuildContext context, Widget widget) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));
  }

  static void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.deepPurple,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static DateTime convertToLocal(DateTime utc) {
    return utc.toLocal();
  }

  static String dateToString(DateTime time) {
    DateFormat format = new DateFormat("MMMM dd, yyyy hh:mm a");
    return format.format(time);
  }

  static Future<bool> pathExists(String path) async {
    return io.File(path).exists();
  }


}