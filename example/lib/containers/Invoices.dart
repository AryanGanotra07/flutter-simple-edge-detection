import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_edge_detection_example/models/invoice.dart';
import 'package:simple_edge_detection_example/providers/InvoiceProvider.dart';
import 'package:simple_edge_detection_example/utils/CustomStyles.dart';
import 'package:simple_edge_detection_example/utils/Helpers.dart';


import 'ResultView.dart';

class Invoices extends StatefulWidget {
  final bool withAppBar;
  final bool export;
  final String title;
  Invoices({this.withAppBar = false, this.export = false, this.title = ""});
  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  List<bool> _exports;
  Map<String, Widget> _imageCached;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  Widget _buildMainWidget() {
    return Consumer<InvoiceProvider>(builder: (context, data, child) {
      List<MyInvoice> _invoices = data.invoices;
      if (_exports == null && widget.export ?? false) {
        _exports = List<bool>.filled(_invoices.length, false);
      }
      if (_imageCached == null) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _cacheImages(_invoices));

        // _imageCached = [];
        // _invoices.forEach((element) {
        //   _imageCached.add(Image.file(File(element.imgPath)));
        // });
      }
      if (_invoices.length == 0) return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("No Invoices Found!"),
              // TextButton(onPressed: () {
              //
              // }, child: Text("Add Now")),
            ],
          ),
        ),
      );
      return ListView.builder(
        // Let the ListView know how many items it needs to build.
        addAutomaticKeepAlives: true,
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
              child:
              ListTile(
                leading: _imageCached != null ? _imageCached.containsKey(item.name) ? _imageCached[item.name] : Icon(Icons.insert_drive_file_sharp) : Icon(Icons.insert_drive_file_sharp),
                title: Text(item.name),
                subtitle: Text("Processed on ${Helpers.dateToString(
                    Helpers.convertToLocal(item.createdAt ?? DateTime.now()
                        .toUtc()))}"),
                trailing: widget.export ?? false ? Checkbox(
                  value: _exports[index], onChanged: (val) {
                  if (val == true && _getCheckedCount() >= _allowed)
                    _showCheckedExceededSnackbar();
                  else
                    setState(() {
                      _exports[index] = val;
                    });
                },) : null,
              ),

            ),
          );
        },
      );
    });
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

  final int _allowed = 5;

  int _getCheckedCount() {
    if (_exports != null) return _exports
        .where((element) => element == true)
        .toList()
        .length;
    return 0;
  }

  String _getExportsCount() {
    int count = 0;
    if (_exports != null) {
      count = _getCheckedCount();
    }
    return "$count/$_allowed";
  }

  Widget _getExportButtonWidget() {
    if (_exports != null) {
      if (_getCheckedCount() > 0) {
        return FloatingActionButton(onPressed: () {

        }, child: Text("CSV"),);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.withAppBar != null && widget.withAppBar) {
      return Scaffold(
        key: _scaffoldKey,
        floatingActionButton: _getExportButtonWidget(),
        appBar: AppBar(
          title: Text(widget.title ?? ""),
          actions: [

            Container(
                margin: EdgeInsets.only(right: 16),
                child: Center(child: Text(
                  _exports != null ? _getExportsCount() : "",
                  style: CustomStyles.textButtonStyle,))),

          ],
        ),
        body: _buildMainWidget(),
      );
    }
    return _buildMainWidget();
  }

  void _showCheckedExceededSnackbar() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("You can export up to $_allowed invoices at a time")));
  }

}

