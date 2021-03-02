import 'dart:convert';

import 'package:simple_edge_detection_example/constants/contant.dart';
import 'package:simple_edge_detection_example/models/response.dart';
import 'package:http/http.dart' as http;

class ImageService {
  static Future<MyResponse> fetchResponse(String name, String img64) async {
    Map data = {"name": name, "image": img64};

    var body = json.encode(data);

    final response = await http.post(BASE_URL, body: body);
    print(response.body);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return MyResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  static Future<MyResponse> fetchResponseFromName(String name) async {
    final response = await http.get(BASE_URL + "?name=" + name + ".json");
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      return MyResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
