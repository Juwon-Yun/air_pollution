import 'package:air_pollution/models/stat_model.dart';
import 'package:air_pollution/models/status_model.dart';

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
