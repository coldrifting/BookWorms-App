import 'dart:convert';
import 'package:universal_io/io.dart';

import 'package:bookworms_app/models/book_summary.dart';
import 'package:bookworms_app/models/child.dart';

extension StatusOk on HttpClientResponse {
  bool get ok => statusCode ~/ 100 == 2;
}

// TODO - Replace with generics?
Future<List<Child>> fromResponseListChild(HttpClientResponse response) async {
  final String responseString = await readResponseString(response);

  final List list = json.decode(responseString.toString());
  List<Child> listObjects = list.map((val) => Child.fromJson(val)).toList();

  return listObjects;
}

Future<List<BookSummary>> fromResponseListBookSummary(HttpClientResponse response) async {
  final String responseString = await readResponseString(response);

  final List list = json.decode(responseString.toString());
  List<BookSummary> listObjects = list.map((val) => BookSummary.fromJson(val)).toList();

  return listObjects;
}

Future<List<Map<String, dynamic>>> readResponseList(HttpClientResponse response) async {
  final contents = StringBuffer();
  await for (var data in response.transform(utf8.decoder)) {
    contents.write(data);
  }
  return await jsonDecode(contents.toString());
}

Future<String> readResponseString(HttpClientResponse response) async {
  return await response.transform(utf8.decoder).join();
}

Future<Map<String, dynamic>> readResponse(HttpClientResponse response) async {
  return jsonDecode(await readResponseString(response));
}

String getChildId(HttpClientResponse response) {
  return response.headers["Location"]?.first.toString().replaceFirst("/children/","") ?? "";
}