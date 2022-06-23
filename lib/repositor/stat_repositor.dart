import 'package:air_pollution/models/stat_model.dart';

abstract class StatRepositor {
  Future<List<StatModel>> getPollutionWithServiceKey(
      {required String serviceKey, required ItemCode itemCode});
}
