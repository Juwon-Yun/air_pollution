import 'package:air_pollution/models/stat_model.dart';

abstract class StatRepositor {
  Future<List<StatModel>> getPollutionWithItemCode(
      {required String serviceKey, required ItemCode itemCode});
}
