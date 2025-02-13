import 'dart:convert';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:universal_io/io.dart';

class HttpClientExt {
  final HttpClient client = newUniversalHttpClient();

  Future<HttpClientResponse> sendRequest({required Uri uri, String method = "GET", Object? payload}) async {
    final HttpClientRequest request = await initRequest(method, uri);

    await addToken(request);

    if (payload != null) {
      request.persistentConnection = false;
      request.headers.contentType = ContentType('application', 'json', charset: 'utf-8');
      request.write(jsonEncode(payload));
    }

    return await request.close();
  }

  addToken(HttpClientRequest request) async {
    var token = await getToken();
    if (token != null) {
      request.headers.add("Authorization", "bearer ${await getToken()}");
    }
  }

  Future<HttpClientRequest> initRequest(String method, Uri uri) async {
    final HttpClientRequest request;
    if (method == "POST") {
      request = await client.postUrl(uri);
    }
    else if (method == "PUT") {
      request = await client.putUrl(uri);
    }
    else if (method == "DELETE") {
      request = await client.deleteUrl(uri);
    }
    else {
      request = await client.getUrl(uri);
    }

    return request;
  }
}