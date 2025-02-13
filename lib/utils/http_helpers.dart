import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:bookworms_app/models/book_summary.dart';
import 'package:bookworms_app/models/child.dart';

import '../services/auth_storage.dart';

extension StatusOk on http.Response {
  bool get ok => statusCode ~/ 100 == 2;
}

extension SendRequest on http.Client {
  Future<http.Response> sendRequest(
      {required Uri uri, String method = "GET", Object? payload}) async {

    Map<String, String> headers = {"Accept": "application/json"};

    var token = await getToken();
    if (token != null) {
      headers["Authorization"] = "bearer ${await getToken()}";
    }

    if (payload != null) {
      headers["Content-Type"] = "application/json";
    }

    switch (method) {
      case "POST":
        if (payload != null) {
          return await post(
              uri, headers: headers, body: jsonEncode(payload));
        }
        return await post(uri, headers: headers);
      case "PUT":
        if (payload != null) {
          return await put(
              uri, headers: headers, body: jsonEncode(payload));
        }
        return await put(uri, headers: headers);
      case "DELETE":
        return await delete(uri, headers: headers);
      case "GET":
      default:
        return await get(uri, headers: headers);
    }
  }
}

extension StatusBadRequest on http.Response {
  bool get badRequest => statusCode == 400;
}

String getChildId(http.Response response) {
  return response.headers["Location"]?.toString().replaceFirst("/children/","") ?? "";
}

Map<String, dynamic> readResponse(http.Response response) {
  return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
}

// Unfortunately we are unable to replace these two methods with a generic one
Future<List<Child>> fromResponseListChild(http.Response response) async {
  List<dynamic> parsedListJson = jsonDecode(utf8.decode(response.bodyBytes));
  return List<Child>.from(parsedListJson.map<Child>((dynamic i) => Child.fromJson(i)));
}

Future<List<BookSummary>> fromResponseListBookSummary(http.Response response) async {
  List<dynamic> parsedListJson = jsonDecode(utf8.decode(response.bodyBytes));
  return List<BookSummary>.from(parsedListJson.map<BookSummary>((dynamic i) => BookSummary.fromJson(i)));
}