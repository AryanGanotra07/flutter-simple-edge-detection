import 'package:flutter/material.dart';
import 'package:simple_edge_detection_example/Application.dart';
import 'package:simple_edge_detection_example/constants/contant.dart';
import 'package:simple_edge_detection_example/models/invoice.dart';

class InvoiceProvider extends ChangeNotifier {
  List<MyInvoice> _invoices = [];
  
  static final Application _application = Application();

  List<MyInvoice> get invoices => _invoices;


  static MyInvoice getInvoiceByName(String invoiceName) {
    print("Fetching invoice from db.. " + invoiceName);
    List items =  _application.storage.getItem(Constants.STORAGE_NAME);
    print(items[0]["imgPath"]);
    var item = items.where((element) => element["name"] == invoiceName).first;
    if (item != null) {
      MyInvoice _invoice = MyInvoice(
        name: item["name"],
        img64: item["img64"],
        imgPath: item["imgPath"],
        isProcessing: item["isProcessing"],
      );
      print("Recieved invoice from db.. ");
      print(_invoice);
      return _invoice;
    }
    return null;
  }

  void editInvoice(MyInvoice _invoice) {
    invoices[invoices.indexWhere((element) => element.name == _invoice.name)] = _invoice;
    updateStorage();
    notifyListeners();
  }


  void fetchFromLocal() {
   List items =  _application.storage.getItem(Constants.STORAGE_NAME);
   print("items");
   print(items);
   if (items != null && items.length > 0) {
     _invoices = List<MyInvoice>.from(
       (items as List).map(
             (item) => MyInvoice(
               name: item["name"],
               img64: item["img64"],
               imgPath: item["imgPath"],
               isProcessing: item["isProcessing"],
               createdAt : item["createdAt"],
             ),
       ),
     );
   }
   notifyListeners();
  }

  void addInvoice(MyInvoice _invoice) {
    _invoices.insert(0, _invoice);
    updateStorage();
    print("Added invoice - " + _invoice.name);
    notifyListeners();
  }


  List _listToJsonList(List<MyInvoice> _myInvoices) {
    return _myInvoices.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }

  void updateStorage() {
    _application.storage.setItem(Constants.STORAGE_NAME, _listToJsonList(_invoices));
  }

  void deleteInvoice(MyInvoice _invoice) {
    _invoices.remove(_invoice);
    updateStorage();
    notifyListeners();
  }

}
