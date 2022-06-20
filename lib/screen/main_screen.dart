import 'package:air_pollution/components/category_card.dart';
import 'package:air_pollution/components/hourly_card.dart';
import 'package:air_pollution/components/main_app_bar.dart';
import 'package:air_pollution/components/main_drawer.dart';
import 'package:air_pollution/constants/custom_theme.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      drawer: MainDrawer(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            MainAppBar(),
            // Sliver 안에 일반 Widget도 사용하게 해준다.
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CategoryCard(),
                  const SizedBox(height: 16),
                  HourlyCard(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
