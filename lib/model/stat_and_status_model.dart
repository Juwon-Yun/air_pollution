import 'package:air_pollution/model/stat_model.dart';
import 'package:air_pollution/model/status_model.dart';

class StatAndStatusModel {
  final StatusModel statusModel;
  final StatModel statModel;
  final ItemCode itemCode;

  StatAndStatusModel({
    required this.statusModel,
    required this.statModel,
    required this.itemCode,
  });
}
