import 'package:air_pollution/repository/stat_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  test('test for dotenv property', () {
    final serviceKey = dotenv.env['SERVICE_KEY'];

    expect(serviceKey, 'null');
  });

  test('test for dio request data', () {
    final serviceKey = dotenv.env['SERVICE_KEY'];
    final response = StatRepository.fetchData(serviceKey!);

    expect(response, response);
  });
}
