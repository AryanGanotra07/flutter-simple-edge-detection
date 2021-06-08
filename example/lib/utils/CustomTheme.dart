

import 'package:flutter/material.dart';
import 'package:simple_edge_detection_example/utils/CustomStyles.dart';

class CustomTheme {
  static final ThemeData getTheme = ThemeData(
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: CustomStyles.textButtonStyle
      ),
    ),
      );
}