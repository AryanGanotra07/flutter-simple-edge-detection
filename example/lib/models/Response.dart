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

  String _sResp = "{\n    \"sellergstin\":[\n        \"07CIWPM1253M1ZM\",\n        \"O7AABCL4985D1ZG\"\n    ],\n    \"buyergstin\":[\n        \"07CIWPM1253M1ZM\",\n        \"O7AABCL4985D1ZG\"\n    ],\n    \"invoiceDate\":[\n        \"\\u2014: 31/01/2018\",\n        \"31/01/2018\"\n    ],\n    \"invoiceNum\":[\n        \"TT/17-18/113203\"\n    ],\n    \"totalVal\":999,\n    \"itemList\":[\n        {\n            \"accurate\":true,\n            \"raw\":[\n                \"0.00\",\n                \"0.00\",\n                \"0.00\",\n                \"0.00\",\n                \"28 Yo:\",\n                \"0.00\",\n                \"0.00\",\n                \"0.00\"\n            ],\n            \"gross\":\"0.00\",\n            \"scheme\":\"0.00\",\n            \"discount\":\"0.00\",\n            \"taxableAmt\":\"0.00\",\n            \"rate\":\"28 Yo:\",\n            \"cgst\":\"0.00\",\n            \"sgst\":\"0.00\",\n            \"igst\":\"0.00\"\n        },\n        {\n            \"accurate\":true,\n            \"raw\":[\n                \"168.81\",\n                \"0.00\",\n                \"6.75\",\n                \"162.06\",\n                \"18 %i\",\n                \"14.59\",\n                \"14.59\",\n                \"=: 272\"\n            ],\n            \"gross\":\"168.81\",\n            \"scheme\":\"0.00\",\n            \"discount\":\"6.75\",\n            \"taxableAmt\":\"162.06\",\n            \"rate\":\"18 %i\",\n            \"cgst\":\"14.59\",\n            \"sgst\":\"14.59\",\n            \"igst\":\"=: 272\"\n        },\n        {\n            \"accurate\":true,\n            \"raw\":[\n                \"5932.49\",\n                \"0.00\",\n                \"237.30\",\n                \"5695.19\",\n                \"12 %\",\n                \"341.72\",\n                \"341.72\",\n                \"0.00\"\n            ],\n            \"gross\":\"5932.49\",\n            \"scheme\":\"0.00\",\n            \"discount\":\"237.30\",\n            \"taxableAmt\":\"5695.19\",\n            \"rate\":\"12 %\",\n            \"cgst\":\"341.72\",\n            \"sgst\":\"341.72\",\n            \"igst\":\"0.00\"\n        },\n        {\n            \"accurate\":false,\n            \"raw\":[\n                \"0.00\",\n                \"0.00\",\n                \"0.00\",\n                \"0.00\",\n                \"o%\",\n                \"0.60\",\n                \"0.00\"\n            ],\n            \"gross\":null,\n            \"scheme\":null,\n            \"discount\":null,\n            \"taxableAmt\":null,\n            \"rate\":null,\n            \"cgst\":null,\n            \"sgst\":null,\n            \"igst\":null\n        },\n        {\n            \"accurate\":false,\n            \"raw\":[\n                \"0.00\",\n                \"0.00\",\n                \"0.00\",\n                \"0.00\",\n                \"o%\",\n                \"0.60\",\n                \"0.00\"\n            ],\n            \"gross\":null,\n            \"scheme\":null,\n            \"discount\":null,\n            \"taxableAmt\":null,\n            \"rate\":null,\n            \"cgst\":null,\n            \"sgst\":null,\n            \"igst\":null\n        }\n    ]\n}";

  Map _resp = {
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

  void mapResponse() {
    var resp = jsonDecode(_sResp);

    List sellergstin = resp["sellergstin"];
    this.sellergstin = sellergstin.map((e) => e.toString()).toList();
    List buyergstin = resp["buyergstin"];
    this.buyergstin = buyergstin.map((e) => e.toString()).toList();
    List invoiceDate = resp["invoiceDate"];
    this.invoiceDate = invoiceDate.map((e) => e.toString()).toList();
    List invoiceNum = resp["invoiceNum"];
    this.invoiceNum = invoiceNum.map((e) => e.toString()).toList();
    this.totalVal = resp["totalVal"];
    List items = resp["itemList"];
    this.itemList = items.map((e) => Item.fromJson(e)).toList();
  }

  factory MyResponse.fromJson(Map<String, dynamic> resp) {
    print("here");
    MyResponse myResponse = new MyResponse();
    myResponse.display = "Got the result";
    List sellergstin = resp["sellergstin"];
    myResponse.sellergstin = sellergstin.map((e) => e.toString()).toList();
    List buyergstin = resp["buyergstin"];
    myResponse.buyergstin = buyergstin.map((e) => e.toString()).toList();
    List invoiceDate = resp["invoiceDate"];
    myResponse.invoiceDate = invoiceDate.map((e) => e.toString()).toList();
    List invoiceNum = resp["invoiceNum"];
    myResponse.invoiceNum = invoiceNum.map((e) => e.toString()).toList();
    myResponse.totalVal = resp["totalVal"];
    List items = resp["itemList"];
    if (items!= null) {
      myResponse.itemList = items.map((e) => Item.fromJson(e)).toList();
    }
    else myResponse.itemList = [];
    print("there");
    return myResponse;
  }
}
