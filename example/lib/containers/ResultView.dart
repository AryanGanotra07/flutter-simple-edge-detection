import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:simple_edge_detection_example/models/invoice.dart';
import 'package:simple_edge_detection_example/models/items.dart';
import 'package:simple_edge_detection_example/models/response.dart';
import 'package:simple_edge_detection_example/providers/InvoiceProvider.dart';
import 'package:simple_edge_detection_example/services/ImageService.dart';
import 'package:simple_edge_detection_example/utils/Helpers.dart';

import 'ImageZoom.dart';

class ResultView extends StatefulWidget {
  final MyInvoice _invoice;
  ResultView(this._invoice, {Key key}) : super(key: key);

  @override
  _ResultViewState createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  Future _fetchResult;
  MyResponse _response;
  final double _thickness = 2;
  final TextStyle _textStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold
  );
  final TextEditingController _sellerController = TextEditingController();
  final TextEditingController _buyerController = TextEditingController();
  final TextEditingController _datesController = TextEditingController();
  final TextEditingController _numsController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<TextEditingController> _itemListControllers = [];
  final List<TextEditingController> _grossControllers = [];
  final List<TextEditingController> _schemeControllers = [];
  final List<TextEditingController> _discountControllers = [];
  final List<TextEditingController> _taxableAmtControllers = [];
  final List<TextEditingController> _rateControllers = [];
  final List<TextEditingController> _cgstControllers = [];
  final List<TextEditingController> _sgstControllers = [];
  final List<TextEditingController> _igstControllers = [];
  bool isSwitched = false;
  var textValue = 'Switch is OFF';
  FocusNode switchFocusNode = new FocusNode();



  @override
  void initState() {
    super.initState();
    // if (!widget._invoice.isProcessing) {
    _fetchResult = ImageService.fetchResponseFromName(widget._invoice.name);
    // }
    _response = widget._invoice.response;
    // print(_response.sellergstin);
    // _sellerController.text = _response.sellergstin.length > 0 ? _response.sellergstin.first : "";
    // _buyerController.text = _response.buyergstin.length > 0 ? _response.buyergstin.first : "";
    // _datesController.text = _response.invoiceDate.length > 0 ? _response.invoiceDate.first : "";
    // _numsController.text = _response.invoiceNum.length > 0 ? _response.invoiceNum.first : "";
    // _totalController.text = _response.totalVal != null ? _response.totalVal.toString() : "";
    // for (Item _item in _response.itemList) {
    //   print(_item.discount);
    //   _itemListControllers.add(new TextEditingController());
    //   _grossControllers.add(new TextEditingController(text: _item.gross != null ? _item.gross : "null"));
    //   _schemeControllers.add(new TextEditingController(text: _item.scheme != null ? _item.scheme : "null"));
    //   _discountControllers.add(new TextEditingController(text: _item.discount != null ? _item.discount : "null"));
    //   _taxableAmtControllers.add(new TextEditingController(text: _item.taxableAmt != null ? _item.taxableAmt : "null"));
    //   _rateControllers.add(new TextEditingController(text: _item.rate != null ? _item.rate : "null"));
    //   _cgstControllers.add(new TextEditingController(text: _item.cgst != null ? _item.cgst : "null"));
    //   _sgstControllers.add(new TextEditingController(text: _item.sgst != null ? _item.sgst : "null"));
    //   _igstControllers.add(new TextEditingController(text: _item.igst != null ? _item.igst : "null"));
    // }
  }

  void _updateInvoice() {
    _response.sellergstin = [_sellerController.text ?? "null"];
    _response.buyergstin = [_buyerController.text ?? "null"];
    _response.invoiceDate = [_datesController.text ?? "null"];
    _response.invoiceNum = [_numsController.text ?? "null"];
    _response.totalVal = int.parse(_totalController.text) ?? 999;

    for (var i = 0 ; i < _response.itemList.length ; i++) {
      final item = _response.itemList[i];
      item.gross = _grossControllers[i].text ?? "null";
      item.scheme = _schemeControllers[i].text ?? "null";
      item.discount = _discountControllers[i].text ?? "null";
      item.taxableAmt = _taxableAmtControllers[i].text ?? "null";
      item.rate = _rateControllers[i].text ?? "null";
      item.cgst = _cgstControllers[i].text ?? "null";
      item.sgst = _sgstControllers[i].text ?? "null";
      item.igst = _igstControllers[i].text ?? "null";
      _response.itemList[i] = item;
    }
    widget._invoice.response = _response;

    Provider.of<InvoiceProvider>(context, listen: false).editInvoice(widget._invoice);
    Navigator.of(context).pop();

  }

  void _assignValues(MyResponse _response) {
    print(_response.sellergstin);
    _sellerController.text = _response.sellergstin.length > 0 ? _response.sellergstin.first : "";
    _buyerController.text = _response.buyergstin.length > 0 ? _response.buyergstin.first : "";
    _datesController.text = _response.invoiceDate.length > 0 ? _response.invoiceDate.first : "";
    _numsController.text = _response.invoiceNum.length > 0 ? _response.invoiceNum.first : "";
    _totalController.text = _response.totalVal != null ? _response.totalVal.toString() : "";
    for (Item _item in _response.itemList) {
      print(_item.discount);
      _itemListControllers.add(new TextEditingController());
      _grossControllers.add(new TextEditingController(text: _item.gross != null ? _item.gross : "null"));
      _schemeControllers.add(new TextEditingController(text: _item.scheme != null ? _item.scheme : "null"));
      _discountControllers.add(new TextEditingController(text: _item.discount != null ? _item.discount : "null"));
      _taxableAmtControllers.add(new TextEditingController(text: _item.taxableAmt != null ? _item.taxableAmt : "null"));
      _rateControllers.add(new TextEditingController(text: _item.rate != null ? _item.rate : "null"));
      _cgstControllers.add(new TextEditingController(text: _item.cgst != null ? _item.cgst : "null"));
      _sgstControllers.add(new TextEditingController(text: _item.sgst != null ? _item.sgst : "null"));
      _igstControllers.add(new TextEditingController(text: _item.igst != null ? _item.igst : "null"));
    }
  }
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = MaterialButton(
      child: Text("Discard"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = MaterialButton(
      child: Text("Yes"),
      onPressed:  () {
        Provider.of<InvoiceProvider>(context, listen: false).deleteInvoice(widget._invoice);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Would you like to delete Invoice ${widget._invoice.name}?"),
      actions: [
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice Details"),
        actions: [
          IconButton(icon: Icon(Icons.preview_rounded), onPressed: () {
            Helpers.navigateTo(context, ImageZoom(widget._invoice));
          }),
          IconButton(icon: Icon(Icons.delete), onPressed: () {
            showAlertDialog(context);
          }),
          // IconButton(icon: Icon(Icons.save_rounded), onPressed: () {
          //   Helpers.showToast("Saving..(To be done)");
          // }),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Helpers.showToast("To be implemented...");
          return;
          if (_response != null ) {
            Helpers.showToast("Updating...");
            _updateInvoice();
          }
        },
        child: Icon(Icons.done_rounded),
      ),
      body:
      SingleChildScrollView(
        physics: ScrollPhysics(),
        controller: _scrollController,
        child: Container(
          margin: EdgeInsets.only(bottom: 64),
          child: Column(
            children: [
          ListTile(
          // trailing: Image.memory(base64Decode(widget._invoice.img64)),
          //   subtitle: Text(widget._invoice.isProcessing == null  || widget._invoice.isProcessing ? "Processing..." : "Processed"),
    title: Text(widget._invoice.name), ),

              InkWell(
                onTap: () => {
                Helpers.navigateTo(context, ImageZoom(widget._invoice))
                },
                  child: Image.memory(base64Decode(widget._invoice.img64))),

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
                        _response = snapshot.data;
                       widget._invoice.response = _response;
                        _assignValues(_response);
                        return Container(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  // Image.memory(base64Decode(widget._invoice.img64)),
                                  ListTile(
                                    title: Text(widget._invoice.name),
                                    subtitle: Text("Processed"),
                                  ),
                                  Divider(thickness: _thickness),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Seller GSTIN", style: _textStyle,),
                                          IntrinsicWidth(
                                            child: TextField(
                                              textAlign: TextAlign.right,
                                              controller: _sellerController,
                                              decoration: InputDecoration(
                                                hintText: "Enter seller GSTIN"
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                      // _response.buyergstin.length>0 ? SizedBox(
                                      //   height: 80,
                                      //   child: ListView(
                                      //     scrollDirection: Axis.horizontal,
                                      //     children: [
                                      //
                                      //       ..._response.sellergstin
                                      //           .map((e) => Container(
                                      //         margin: EdgeInsets.symmetric(horizontal: 8),
                                      //         child: InkWell(
                                      //           borderRadius: BorderRadius.circular(40),
                                      //           onTap: () {
                                      //             _sellerController.text = e;
                                      //           },
                                      //           child : Chip(
                                      //             label: Text(e),),
                                      //         ),
                                      //       ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ) : Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: Text("No suggestions found"),
                                      // )
                                    ],
                                  ),
                                  Divider(thickness: _thickness),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Buyer GSTIN", style: _textStyle,),
                                          IntrinsicWidth(
                                            child: TextField(
                                              textAlign: TextAlign.right,
                                              controller: _buyerController,
                                              decoration: InputDecoration(
                                                  hintText: "Enter buyer GSTIN"
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                      // _response.buyergstin.length>0 ?
                                      // SizedBox(
                                      //   height: 80,
                                      //   child: ListView(
                                      //     scrollDirection: Axis.horizontal,
                                      //     children: [
                                      //
                                      //       ..._response.buyergstin
                                      //           .map((e) => Container(
                                      //         margin: EdgeInsets.symmetric(horizontal: 8),
                                      //         child: InkWell(
                                      //           borderRadius: BorderRadius.circular(40),
                                      //           onTap: () {
                                      //             _buyerController.text = e;
                                      //           },
                                      //           child : Chip(
                                      //             label: Text(e),),
                                      //         ),
                                      //       ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ) : Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: Text("No suggestions found"),
                                      // )
                                    ],
                                  ),
                                  Divider(thickness: _thickness),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Invoice Date(DD/MM/YYY)", style: _textStyle,),
                                          IntrinsicWidth(
                                            child: TextField(
                                              textAlign: TextAlign.right,
                                              controller: _datesController,
                                              decoration: InputDecoration(
                                                  hintText: "Enter Invoice Dates"
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                      // _response.invoiceDate.length > 0 ?
                                      // SizedBox(
                                      //   height: 80,
                                      //   child: ListView(
                                      //     scrollDirection: Axis.horizontal,
                                      //     children: [
                                      //
                                      //       ..._response.invoiceDate
                                      //           .map((e) => Container(
                                      //         margin: EdgeInsets.symmetric(horizontal: 8),
                                      //         child: InkWell(
                                      //           borderRadius: BorderRadius.circular(40),
                                      //           onTap: () {
                                      //             _datesController.text = e;
                                      //           },
                                      //           child : Chip(
                                      //             label: Text(e),),
                                      //         ),
                                      //       ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ) : Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: Text("No suggestions found"),
                                      // )
                                    ],
                                  ),
                                  Divider(thickness: _thickness),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Invoice Numbers", style: _textStyle,),
                                          IntrinsicWidth(
                                            child: TextField(
                                              textAlign: TextAlign.right,
                                              controller: _numsController,
                                              decoration: InputDecoration(
                                                  hintText: "Enter Invoice Numbers"
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                      // _response.invoiceNum.length > 0 ?
                                      // SizedBox(
                                      //   height: 80,
                                      //   child: ListView(
                                      //     scrollDirection: Axis.horizontal,
                                      //     children: [
                                      //
                                      //       ..._response.invoiceNum
                                      //           .map((e) => Container(
                                      //         margin: EdgeInsets.symmetric(horizontal: 8),
                                      //         child: InkWell(
                                      //           borderRadius: BorderRadius.circular(40),
                                      //           onTap: () {
                                      //             _numsController.text = e;
                                      //           },
                                      //           child : Chip(
                                      //             label: Text(e),),
                                      //         ),
                                      //       ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ) : Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: Text("No suggestions found"),
                                      // )
                                    ],
                                  ),
                                  Divider(thickness: _thickness),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Total Value", style: _textStyle,),
                                      IntrinsicWidth(
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.right,
                                          controller: _totalController,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(thickness: _thickness),
                                  _response.itemList.length > 0 ?
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Show Items List", style: _textStyle,),
                                          Switch(
                                              focusNode: switchFocusNode,
                                              value: isSwitched, onChanged:toggleSwitch)
                                        ],
                                      ),
                                      isSwitched? _renderItemView() : Container(),

                                    ],
                                  ) : Container(),


                                ],
                              ),
                            ),

                        );
                      }
                      print(snapshot.error);
                      return Center(
                        child: Text(
                            snapshot.error.toString()),
                      );
                    }
                  }),
            ],
          ),
        ),
      )
    );
  }
  void toggleSwitch(bool value) {
    FocusScope.of(context).requestFocus(switchFocusNode);

    if(isSwitched == false)
    {
      setState(() {
        isSwitched = true;
        textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
      _scrollController.animateTo(_scrollController.position.pixels + 120, duration :Duration(milliseconds: 1000),
          curve: Curves.ease);
    }
    else
    {
      setState(() {
        isSwitched = false;
        textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
      _scrollController.animateTo(_scrollController.position.pixels - 120, duration :Duration(milliseconds: 1000),
          curve: Curves.ease);
    }

  }

  Widget _renderItemView() {
    print(_response.itemList.length);
    return ListView.builder(
      itemCount: _response.itemList.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        Item _item = _response.itemList[index];
        return Container(
          child: Column(
           children : [ Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Accurate", style: _textStyle,),
                Text(_item.accurate.toString())
              ],
            ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text("Gross", style: _textStyle,),
                 IntrinsicWidth(
                   child: TextField(
                     keyboardType: TextInputType.number,
                     textAlign: TextAlign.right,
                     controller: _grossControllers[index],
                   ),
                 ),
               ],
             ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text("Scheme", style: _textStyle,),
                 IntrinsicWidth(
                   child: TextField(
                     keyboardType: TextInputType.number,
                     textAlign: TextAlign.right,
                     controller: _schemeControllers[index],
                   ),
                 ),
               ],
             ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text("Discount", style: _textStyle,),
                 IntrinsicWidth(
                   child: TextField(
                     keyboardType: TextInputType.number,
                     textAlign: TextAlign.right,
                     controller: _discountControllers[index],
                   ),
                 ),
               ],
             ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text("Taxable Amount", style: _textStyle,),
                 IntrinsicWidth(
                   child: TextField(
                     keyboardType: TextInputType.number,
                     textAlign: TextAlign.right,
                     controller: _taxableAmtControllers[index],
                   ),
                 ),
               ],
             ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text("Rate", style: _textStyle,),
                 IntrinsicWidth(
                   child: TextField(
                     keyboardType: TextInputType.number,
                     textAlign: TextAlign.right,
                     controller: _rateControllers[index],
                   ),
                 ),
               ],
             ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text("CGST", style: _textStyle,),
                 IntrinsicWidth(
                   child: TextField(
                     keyboardType: TextInputType.number,
                     textAlign: TextAlign.right,
                     controller: _cgstControllers[index],
                   ),
                 ),
               ],
             ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text("SGST", style: _textStyle,),
                 IntrinsicWidth(
                   child: TextField(
                     keyboardType: TextInputType.number,
                     textAlign: TextAlign.right,
                     controller: _sgstControllers[index],
                   ),
                 ),
               ],
             ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text("IGST", style: _textStyle,),
                 IntrinsicWidth(
                   child: TextField(
                     keyboardType: TextInputType.number,
                     textAlign: TextAlign.right,
                     controller: _igstControllers[index],
                   ),
                 ),
               ],
             ),
             Divider(),
              ]
          ),
        );
      },
    );
  }


}
