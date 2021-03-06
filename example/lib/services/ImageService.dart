import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:simple_edge_detection_example/constants/contant.dart';
import 'package:simple_edge_detection_example/models/response.dart';
import 'package:http/http.dart' as http;

class ImageService {
  static Future<bool> fetchResponse(String name, String img64) async {
    String deviceid = await FirebaseMessaging.instance.getToken();
    Map data = {"name": name + ".jpeg", "image": img64, "deviceid" : deviceid };

    var body = json.encode(data);

    final response = await http.post(Uri.parse(BASE_URL), body: body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print("Successfully sent - " + name);
      Map<String, dynamic> _json = jsonDecode(response.body);
      if (_json.containsKey("Error")) {
        print("Bad Quality Image");
        return false;
        // throw Exception("Bad Quality Image");
      }
      print("Good Quality Image");
      return true;

      // return MyResponse.fromJson(_json);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print("Failed to post invoice");
      return false;
      throw Exception('Failed to post invoice');
    }
  }

  static Future<MyResponse> fetchResponseFromName(String name) async {
    final response = await http.get(Uri.parse(BASE_URL + "?name=" + name + ".json"));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      Map<String, dynamic> _json = jsonDecode(jsonDecode(response.body));
      if (_json.containsKey("Error") || _json.containsKey("Status")) {
        throw Exception("Bad Quality Image");
      }
      print("status code - 200");
      return MyResponse.fromJson(_json);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print(response.body);
      throw Exception('Invoice not processed yet. Please try again in 2-3 mins.');
    }
  }
}
