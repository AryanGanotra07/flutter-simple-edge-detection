class Item {
  bool accurate;
  List<String> raw;
  String gross;
  String scheme;
  String discount;
  String taxableAmt;
  String rate;
  String cgst;
  String sgst;
  String igst;

  Item();

  factory Item.fromJson(Map<String, dynamic> json) {
    Item item = new Item();
    item.accurate = json["accurate"];
    List raw = json["raw"];
    item.raw = raw.map((e) => e.toString()).toList();
    item.gross = json["gross"];
    item.scheme = json["scheme"];
    item.discount = json["discound"];
    item.taxableAmt = json["taxableAmt"];
    item.rate = json["rate"];
    item.cgst = json["cgst"];
    item.igst = json["igst"];
    return item;
  }
}
