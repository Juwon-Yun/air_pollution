import 'package:air_pollution/components/main_app_bar.dart';
import 'package:air_pollution/components/main_drawer.dart';
import 'package:air_pollution/components/main_stat.dart';
import 'package:air_pollution/constants/custom_theme.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      drawer: MainDrawer(),
      body: CustomScrollView(
        slivers: [
          MainAppBar(),
          // Sliver 안에 일반 Widget도 사용하게 해준다.
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  color: lightColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0)),
                          color: darkColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            '종류별 통계',
                            style: defaultTextStyle.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          MainStat(
                              category: '미세먼지',
                              imgPath: 'asset/img/best.png',
                              level: '최고',
                              stat: '0㎍/㎥'),
                          MainStat(
                              category: '미세먼지',
                              imgPath: 'asset/img/best.png',
                              level: '최고',
                              stat: '0㎍/㎥'),
                          MainStat(
                              category: '미세먼지',
                              imgPath: 'asset/img/best.png',
                              level: '최고',
                              stat: '0㎍/㎥')
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
