import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simple_edge_detection_example/models/invoice.dart';
import 'package:simple_edge_detection_example/models/response.dart';
import 'package:simple_edge_detection_example/services/ImageService.dart';

class ResultView extends StatefulWidget {
  final MyInvoice _invoice;
  ResultView(this._invoice, {Key key}) : super(key: key);

  @override
  _ResultViewState createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  Future _fetchResult;

  @override
  void initState() {
    super.initState();
    _fetchResult = ImageService.fetchResponseFromName(widget._invoice.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice Details"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Image.memory(base64Decode(widget._invoice.img64)),
                ListTile(
                  title: Text(widget._invoice.name),
                  subtitle: Text("Processed"),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Seller GSTIN"),
                    Column(
                      children: [
                        ...widget._invoice.response.sellergstin
                            .map((e) => Text(e))
                      ],
                    )
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Buyer GSTIN"),
                    Column(
                      children: [
                        ...widget._invoice.response.buyergstin
                            .map((e) => Text(e))
                      ],
                    )
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Invoice Dates"),
                    Column(
                      children: [
                        ...widget._invoice.response.invoiceDate
                            .map((e) => Text(e))
                      ],
                    )
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Invoice Num"),
                    Column(
                      children: [
                        ...widget._invoice.response.invoiceNum
                            .map((e) => Text(e))
                      ],
                    )
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Value"),
                    Text(widget._invoice.response.totalVal.toString()),
                  ],
                ),

                FutureBuilder<MyResponse>(
                    future: _fetchResult,
                    builder: (BuildContext context,
                        AsyncSnapshot<MyResponse> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.hasData) {
                          MyResponse _response = snapshot.data;
                          return Text(_response.display);
                        }
                        print(snapshot.error);
                        return Text(
                            snapshot.error.toString());
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
