import 'package:bookworms_app/models/child/child.dart';
import 'package:http/http.dart' as http;
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';

class ChildDetailsEditService {
  final http.Client client;

  ChildDetailsEditService({http.Client? client}) : client = client ?? http.Client();

  // Modifies the name or icon index of the account.
  Future<Child> setAccountDetails(Child child, {String? newName, int? iconIndex}) async {
    final response = await client.sendRequest(
        uri: childEditDetailsUri(child.id),
        method: "PUT",
        payload: {
          "newName": newName,
          "childIcon": iconIndex
        }
      );

    if (response.ok) {
      return Child.fromJson(readResponse(response));
    }
    else {
      throw Exception("An error occurred when editing the child profile information.");
    }
  }
}