import 'package:simple_edge_detection_example/models/response.dart';

class MyInvoice {
  String img64;
  String name;
  MyResponse response;
  String imgPath;
  bool isProcessing = false;
  DateTime createdAt = DateTime.now().toUtc();

  MyInvoice({this.name, this.img64, this.imgPath, this.isProcessing, this.createdAt});

  // MyInvoice() {
  //   this.response = new MyResponse();
  //   this.response.mapResponse();
  // }

  toJSONEncodable()  {
    Map json = Map();
    json["img64"] = img64;
    json["imgPath"] = imgPath;
    json["name"] = name;
    json["isProcessing"] = false;
    json["createdAt"] = createdAt;
    return json;
  }
}
