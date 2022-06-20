import 'package:air_pollution/constants/data_config.dart';
import 'package:air_pollution/model/stat_model.dart';
import 'package:dio/dio.dart';

class StatRepository {
  static Future<List<StatModel>> fetchData(String serviceKey) async {
    final response = await Dio().get(apiUrl, queryParameters: {
      'serviceKey': serviceKey,
      'returnType': 'json',
      'numOfRows': 30,
      'pageNo': 1,
      'itemCode': 'PM10',
      'dataGubun': 'HOUR',
      'searchCondition': 'WEEK',
    });
    return response.data['response']['body']['items']
        .map<StatModel>((item) => StatModel.fromJson(json: item))
        .toList();
  }
}
