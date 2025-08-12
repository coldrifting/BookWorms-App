import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
}