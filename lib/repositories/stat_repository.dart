import 'package:air_pollution/constants/data_config.dart';
import 'package:air_pollution/models/stat_model.dart';
import 'package:air_pollution/repositor/stat_repositor.dart';
import 'package:dio/dio.dart';

class StatRepository extends StatRepositor {
  @override
  Future<List<StatModel>> getPollutionWithServiceKey(
      {required String serviceKey, required ItemCode itemCode}) async {
    final response = await Dio().get(apiUrl, queryParameters: {
      'serviceKey': serviceKey,
      'returnType': 'json',
      'numOfRows': 30,
      'pageNo': 1,
      'itemCode': itemCode.name,
      'dataGubun': 'HOUR',
      'searchCondition': 'WEEK',
    });
    return response.data['response']['body']['items']
        .map<StatModel>((item) => StatModel.fromJson(json: item))
        .toList();
  }
}
