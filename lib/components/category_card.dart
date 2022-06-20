import 'package:air_pollution/components/card_title.dart';
import 'package:air_pollution/components/main_card.dart';
import 'package:air_pollution/components/main_stat.dart';
import 'package:air_pollution/constants/custom_theme.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: MainCard(
        // LayoutBuilder의 constraint에 현재 ListBuilder의 너비와 높이값을 가져올수 있다.
        child: LayoutBuilder(
          builder: (context, constraint) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CardTitle(
                title: '종류별 통계',
              ),
              Expanded(
                child: ListView(
                    // Horizontal viewport was given unbounded height. -> 높이 지정하지않음.
                    scrollDirection: Axis.horizontal,
                    physics: PageScrollPhysics(),
                    children: List.generate(
                        20,
                        (index) => MainStat(
                              category: '미세먼지$index',
                              imgPath: 'asset/img/best.png',
                              level: '최고',
                              stat: '0㎍/㎥',
                              // LayoutBuilder의 최대 넓이를 이용해 보여줄 개수를 정한다.
                              width: constraint.maxWidth / 3,
                            ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
