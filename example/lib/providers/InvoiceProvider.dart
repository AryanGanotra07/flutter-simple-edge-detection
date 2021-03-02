import 'package:flutter/material.dart';
import 'package:simple_edge_detection_example/models/invoice.dart';

class InvoiceProvider extends ChangeNotifier {
  List<MyInvoice> _invoices = [];

  List<MyInvoice> get invoices => _invoices;

  void addInvoice(MyInvoice _invoice) {
    _invoices.add(_invoice);
    print("Added invoice - " + _invoice.name);
    notifyListeners();
  }

  void deleteInvoice(MyInvoice _invoice) {
    _invoices.remove(_invoice);
    notifyListeners();
  }
}
