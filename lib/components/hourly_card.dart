import 'package:air_pollution/components/card_title.dart';
import 'package:air_pollution/components/main_card.dart';
import 'package:flutter/material.dart';

class HourlyCard extends StatelessWidget {
  const HourlyCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardTitle(title: '시간별 미세먼지'),
          Column(
            children: List.generate(
              24,
              (index) {
                final now = DateTime.now();
                final hour = now.hour;
                int currentHour = hour - index;

                if (currentHour < 0) {
                  currentHour += 24;
                }

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Row(
                    // mainAxisAlignment:
                    //     MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 1, child: Text('$currentHour시')),
                      Expanded(
                        flex: 1,
                        child: Image.asset(
                          'asset/img/good.png',
                          height: 20,
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Text(
                            '좋음',
                            textAlign: TextAlign.right,
                          ))
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
