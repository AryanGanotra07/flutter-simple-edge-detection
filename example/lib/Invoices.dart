import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_edge_detection_example/models/invoice.dart';
import 'package:simple_edge_detection_example/providers/InvoiceProvider.dart';
import 'package:simple_edge_detection_example/result_view.dart';

class Invoices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceProvider>(builder: (context, data, child) {
      List<MyInvoice> _invoices = data.invoices;
      return ListView.builder(
        // Let the ListView know how many items it needs to build.
        itemCount: _invoices.length,
        // Provide a builder function. This is where the magic happens.
        // Convert each item into a widget based on the type of item it is.
        itemBuilder: (context, index) {
          final item = _invoices[index];

          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResultView(item)),
                );
              },
              child: Column(
                children: [
                  ListTile(
                    trailing: Image.memory(base64Decode(item.img64)),
                    title: Text(item.name),
                    subtitle: Text("Processed"),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
