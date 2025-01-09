import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const secureStorage = FlutterSecureStorage();

Future<void> saveToken(String token) async {
  await secureStorage.write(key: 'authToken', value: token);
}

Future<String?> getToken() async {
  return await secureStorage.read(key: 'authToken');
}

Future<void> deleteToken() async {
  await secureStorage.delete(key: 'authToken');
}
