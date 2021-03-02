import 'dart:convert';

import 'package:simple_edge_detection_example/models/items.dart';

class MyResponse {
  List<String> sellergstin;
  List<String> buyergstin;
  List<String> invoiceDate;
  List<String> invoiceNum;
  int totalVal;
  List<Item> itemList;
  String display;

  MyResponse();

  factory MyResponse.fromJson(String _json) {
    MyResponse myResponse = new MyResponse();
    myResponse.display = _json;
    Map myjson = json.decode(_json);
    List sellergstin = myjson["sellergstin"];
    myResponse.sellergstin = sellergstin.map((e) => e.toString()).toList();
    return myResponse;
  }
}
