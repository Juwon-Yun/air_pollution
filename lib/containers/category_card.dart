import 'package:air_pollution/components/card_title.dart';
import 'package:air_pollution/components/main_card.dart';
import 'package:air_pollution/components/main_stat.dart';
import 'package:air_pollution/constants/fade_animation.dart';
import 'package:air_pollution/models/stat_model.dart';
import 'package:air_pollution/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CategoryCard extends StatelessWidget {
  final String region;
  final Color darkColor;
  final Color lightColor;

  const CategoryCard({
    Key? key,
    required this.region,
    required this.darkColor,
    required this.lightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: FadeAnimation(
        delay: 1,
        child: MainCard(
          backgroundColor: lightColor,
          // LayoutBuilder의 constraint에 현재 ListBuilder의 너비와 높이값을 가져올수 있다.
          child: LayoutBuilder(
            builder: (context, constraint) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CardTitle(
                  title: '종류별 통계',
                  backgroundColor: darkColor,
                ),
                Expanded(
                  child: ListView(
                      // Horizontal viewport was given unbounded height. -> 높이 지정하지않음.
                      scrollDirection: Axis.horizontal,
                      physics: const PageScrollPhysics(),
                      children: ItemCode.values
                          .map((itemCode) => ValueListenableBuilder<Box>(
                              valueListenable:
                                  Hive.box<StatModel>(itemCode.name)
                                      .listenable(),
                              builder: (context, box, widget) {
                                final stat =
                                    box.values.toList().last as StatModel;
                                final status = DataUtils
                                    .getCurrentStatusFromItemCodeAndValue(
                                        value: stat.getLevelFromRegion(region),
                                        itemCode: itemCode);

                                return MainStat(
                                  category: DataUtils.getItemCodeToKrString(
                                      itemCode: itemCode),
                                  imgPath: status.imagePath,
                                  level: status.label,
                                  stat:
                                      '${stat.getLevelFromRegion(region)}${DataUtils.getUnitFromItemCode(itemCode: itemCode)}',
                                  width: constraint.maxWidth / 3,
                                );
                              }))
                          .toList()),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
