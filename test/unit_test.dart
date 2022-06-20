import 'package:air_pollution/constants/data_config.dart';
import 'package:dio/dio.dart';
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
    final response = fetchData(serviceKey!);

    expect(response, 'null');
  });
}

Future<Response<dynamic>> fetchData(String serviceKey) async {
  return await Dio().get(apiUrl, queryParameters: {
    'serviceKey': serviceKey,
    'returnType': 'json',
    'numOfRows': 30,
    'pageNo': 1,
    'itemCode': 'PM10',
    'dataGubun': 'HOUR',
    'searchCondition': 'WEEK',
  });
}
