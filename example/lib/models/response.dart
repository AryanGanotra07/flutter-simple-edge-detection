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

  Map resp = {
    "sellergstin": ["07CIWPM1253M1ZM", "O7AABCL4985D1ZG"],
    "buyergstin": ["07CIWPM1253M1ZM", "O7AABCL4985D1ZG"],
    "invoiceDate": ["\u2014: 31/01/2018", "31/01/2018"],
    "invoiceNum": ["TT/17-18/113203"],
    "totalVal": 999,
    "itemList": [
      {
        "accurate": true,
        "raw": [
          "0.00",
          "0.00",
          "0.00",
          "0.00",
          "28 Yo:",
          "0.00",
          "0.00",
          "0.00"
        ],
        "gross": "0.00",
        "scheme": "0.00",
        "discount": "0.00",
        "taxableAmt": "0.00",
        "rate": "28 Yo:",
        "cgst": "0.00",
        "sgst": "0.00",
        "igst": "0.00"
      },
      {
        "accurate": true,
        "raw": [
          "168.81",
          "0.00",
          "6.75",
          "162.06",
          "18 %i",
          "14.59",
          "14.59",
          "=: 272"
        ],
        "gross": "168.81",
        "scheme": "0.00",
        "discount": "6.75",
        "taxableAmt": "162.06",
        "rate": "18 %i",
        "cgst": "14.59",
        "sgst": "14.59",
        "igst": "=: 272"
      },
      {
        "accurate": true,
        "raw": [
          "5932.49",
          "0.00",
          "237.30",
          "5695.19",
          "12 %",
          "341.72",
          "341.72",
          "0.00"
        ],
        "gross": "5932.49",
        "scheme": "0.00",
        "discount": "237.30",
        "taxableAmt": "5695.19",
        "rate": "12 %",
        "cgst": "341.72",
        "sgst": "341.72",
        "igst": "0.00"
      },
      {
        "accurate": false,
        "raw": ["0.00", "0.00", "0.00", "0.00", "o%", "0.60", "0.00"],
        "gross": null,
        "scheme": null,
        "discount": null,
        "taxableAmt": null,
        "rate": null,
        "cgst": null,
        "sgst": null,
        "igst": null
      },
      {
        "accurate": false,
        "raw": ["0.00", "0.00", "0.00", "0.00", "o%", "0.60", "0.00"],
        "gross": null,
        "scheme": null,
        "discount": null,
        "taxableAmt": null,
        "rate": null,
        "cgst": null,
        "sgst": null,
        "igst": null
      }
    ]
  };

  void mapRespose() {
    this.sellergstin = resp["sellergstin"];
    this.buyergstin = resp["buyergstin"];
    this.invoiceDate = resp["invoiceDate"];
    this.invoiceNum = resp["invoiceNum"];
    this.totalVal = resp["totalVal"];
  }

  factory MyResponse.fromJson(Map<String, dynamic> _json) {
    MyResponse myResponse = new MyResponse();
    myResponse.display = "Got the result";
    // myResponse.display = _json;
    // Map myjson = json.decode(_json);
    List sellergstin = _json["sellergstin"];
    myResponse.sellergstin = sellergstin.map((e) => e.toString()).toList();
    return myResponse;
  }
}
