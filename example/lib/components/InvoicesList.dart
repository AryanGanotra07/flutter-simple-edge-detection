import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_edge_detection_example/components/ImageView.dart';
import 'package:simple_edge_detection_example/containers/Invoices.dart';
import 'package:simple_edge_detection_example/containers/ResultView.dart';
import 'package:simple_edge_detection_example/models/invoice.dart';
import 'package:simple_edge_detection_example/providers/InvoiceProvider.dart';
import 'package:simple_edge_detection_example/utils/CustomStyles.dart';
import 'package:simple_edge_detection_example/utils/Helpers.dart';



class InvoicesList extends StatefulWidget {


  @override
  _InvoicesListState createState() => _InvoicesListState();
}

class _InvoicesListState extends State<InvoicesList> {
  Widget _buildNoInvoiceWidget() {
    return Container(
      alignment: Alignment.center,
      child :    Text("No Invoices Found!"),
          // TextButton(onPressed: () {
          //
          // }, child: Text("Add Now")),
        // ],
    );
  }

  Map<String, Widget> _imageCached;

  Widget _buildInvoicesList(List<MyInvoice> _invoices) {
    if (_invoices.length > 6) {
      _invoices = _invoices.getRange(0,5).toList();
    }

    return Flexible(
      child: ListView.builder(

          // Let the ListView know how many items it needs to build.
          itemCount: _invoices.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = _invoices[index];

            return Card(
              child: InkWell(
                onTap: () {
                  Helpers.navigateTo(context, ResultView(item));
                },
                child: Column(
                  children: [
                    ListTile(
                      leading: _imageCached != null ? _imageCached.containsKey(item.name) ? _imageCached[item.name] : Icon(Icons.insert_drive_file_sharp) : Icon(Icons.insert_drive_file_sharp),
                      title: Text(item.name),
                      subtitle: Text("Processed on ${Helpers.dateToString(Helpers.convertToLocal(item.createdAt?? DateTime.now().toUtc()))}") ,
                    ),
                  ],
                ),
              ),
            );
          },
      ),
    );
  }

  Future<void> _cacheImages(List<MyInvoice> _invoices) async {
    _imageCached = Map();
    _invoices.forEach((element) async {
      bool exists = await Helpers.pathExists(element.imgPath);
      if (exists) {
        _imageCached[element.name] = Image.file(File(element.imgPath));
      }
      else {
        _imageCached[element.name] = Image.memory(base64Decode(element.img64));
      }
    });
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceProvider>(builder: (context, data, child) {
      List<MyInvoice> _invoices = data.invoices;
      if (_imageCached == null) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _cacheImages(_invoices));
        // _imageCached = [];
        // _invoices.forEach((element) {
        //   _imageCached.add(Image.file(File(element.imgPath)));
        // });
      }
      return Container(
        width: double.infinity,
        height: 320,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(

              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    child:
                      ListTile(
                        title: Text("Recently Scanned", style: CustomStyles.cardTitleStyle,),
                        trailing: TextButton(
                          onPressed: () {
                              Helpers.navigateTo(context, Invoices(withAppBar: true,title: "Invoices",));
                          },
                          child: Text("See all"),
                        ),
                    )),
                Divider(),
                _invoices.length == 0 ? _buildNoInvoiceWidget() : _buildInvoicesList(_invoices),
              ],
            ),
          ),
        ),
      );
    });
  }
}