import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_edge_detection_example/providers/InvoiceProvider.dart';

import 'home.dart';
import 'scan.dart';

void main() {
  runApp(EdgeDetectionApp());
}

class EdgeDetectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<InvoiceProvider>(
          create: (_) => InvoiceProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Invoice Parser',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Home(),
      ),
    );
  }
}
