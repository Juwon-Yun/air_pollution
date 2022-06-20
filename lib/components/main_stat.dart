import 'package:air_pollution/constants/custom_theme.dart';
import 'package:flutter/material.dart';

class MainStat extends StatelessWidget {
  // 미세먼지, 초미세먼지
  final String category;
  // 아이콘
  final String imgPath;
  // 오염 정도
  final String level;
  // 오염 수치
  final String stat;

  // 너비
  final double width;

  const MainStat(
      {Key? key,
      required this.category,
      required this.imgPath,
      required this.level,
      required this.stat,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            category,
            style: cardTextStyle,
          ),
          const SizedBox(height: 8),
          Image.asset(
            imgPath,
            width: 50,
          ),
          const SizedBox(height: 8),
          Text(
            level,
            style: cardTextStyle,
          ),
          Text(
            stat,
            style: cardTextStyle,
          ),
        ],
      ),
    );
  }
}
