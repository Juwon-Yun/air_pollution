import 'package:air_pollution/constants/custom_theme.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: primaryColor,
      expandedHeight: 500,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Column(
            children: [
              Text(
                '서울',
                style: defaultTestStyle,
              ),
              Text(
                DateTime.now().toString(),
                style: defaultTestStyle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'asset/img/mediocre.png',
                width: MediaQuery.of(context).size.width * 0.5,
              ),
              const SizedBox(height: 20),
              Text(
                '보통',
                style: defaultTestStyle.copyWith(
                    fontSize: 40, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                '나쁘지 않네요!',
                style: defaultTestStyle.copyWith(
                    fontSize: 20, fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ),
    );
  }
}
