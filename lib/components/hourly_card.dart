import 'package:air_pollution/components/card_title.dart';
import 'package:air_pollution/components/main_card.dart';
import 'package:air_pollution/model/stat_model.dart';
import 'package:air_pollution/utils/data_utils.dart';
import 'package:flutter/material.dart';

class HourlyCard extends StatelessWidget {
  final Color darkColor;
  final Color lightColor;
  final String category;
  final List<StatModel> stats;
  final String region;

  const HourlyCard({
    Key? key,
    required this.darkColor,
    required this.lightColor,
    required this.category,
    required this.stats,
    required this.region,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainCard(
      backgroundColor: lightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardTitle(
            title: '시간별 $category',
            backgroundColor: darkColor,
          ),
          Column(
              children:
                  stats.map((stat) => renderRow(statModel: stat)).toList()),
        ],
      ),
    );
  }

  Widget renderRow({required StatModel statModel}) {
    final status = DataUtils.getCurrentStatusFromItemCodeAndValue(
        value: statModel.getLevelFromRegion(region),
        itemCode: statModel.itemCode);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text('${statModel.dataTime.hour}시')),
          Expanded(
            flex: 1,
            child: Image.asset(
              status.imagePath,
              height: 20,
            ),
          ),
          Expanded(
              flex: 1,
              child: Text(
                status.label,
                textAlign: TextAlign.right,
              ))
        ],
      ),
    );
  }
}
