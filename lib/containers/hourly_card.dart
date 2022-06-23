import 'package:air_pollution/components/card_title.dart';
import 'package:air_pollution/components/main_card.dart';
import 'package:air_pollution/constants/fade_animation.dart';
import 'package:air_pollution/models/stat_model.dart';
import 'package:air_pollution/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HourlyCard extends StatelessWidget {
  final Color darkColor;
  final Color lightColor;
  final String region;
  final ItemCode itemCode;

  const HourlyCard({
    Key? key,
    required this.darkColor,
    required this.lightColor,
    required this.region,
    required this.itemCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      delay: 1,
      child: ValueListenableBuilder<Box>(
          valueListenable: Hive.box<StatModel>(itemCode.name).listenable(),
          builder: (context, box, widget) {
            return MainCard(
              backgroundColor: lightColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CardTitle(
                    title:
                        '시간별 ${DataUtils.getItemCodeToKrString(itemCode: itemCode)}',
                    backgroundColor: darkColor,
                  ),
                  Column(
                      children: box.values
                          .toList()
                          .reversed
                          .map((stat) => renderRow(statModel: stat))
                          .toList()),
                ],
              ),
            );
          }),
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
