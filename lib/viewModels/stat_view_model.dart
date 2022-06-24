import 'package:air_pollution/models/stat_model.dart';
import 'package:air_pollution/repositories/stat_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StatViewModel {
  static Future<void> fetchPollution(
      {required String serviceKey, required BuildContext context}) async {
    try {
      final now = DateTime.now();
      final fetchTime = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
      );

      final box = Hive.box<StatModel>(ItemCode.PM10.name);

      if (box.values.isNotEmpty &&
          box.values.last.dataTime.isAtSameMomentAs(fetchTime)) return;

      List<Future> futures = [];

      //병렬로 비동기 요청하기
      for (ItemCode itemCode in ItemCode.values) {
        futures.add(StatRepository().getPollutionWithItemCode(
            serviceKey: serviceKey, itemCode: itemCode));
      }

      // 요청은 한번에 다 보낸뒤
      // 모든 응답이 도착할때까지 block operation한다.
      // goroutine -> channel 같음
      final results = await Future.wait(futures);

      for (int i = 0; i < results.length; i++) {
        final itemCode = ItemCode.values[i];
        final statModel = results[i];

        final box = Hive.box<StatModel>(itemCode.name);

        for (StatModel stat in statModel) {
          box.put(stat.dataTime.toString(), stat);
        }

        final allKeys = box.keys.toList();

        if (allKeys.length > 24) {
          final deleteKeys = allKeys.sublist(0, allKeys.length - 24);
          box.deleteAll(deleteKeys);
        }
      }
    } on DioError catch (error) {
      // 요청이 안들어갔을 떄 snack bar
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        '인터넷 연결이 원활하지 않습니다.',
        textAlign: TextAlign.center,
      )));
    }
  }
}
