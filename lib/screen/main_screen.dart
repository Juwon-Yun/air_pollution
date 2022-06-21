import 'package:air_pollution/components/category_card.dart';
import 'package:air_pollution/components/hourly_card.dart';
import 'package:air_pollution/components/main_app_bar.dart';
import 'package:air_pollution/components/main_drawer.dart';
import 'package:air_pollution/constants/custom_theme.dart';
import 'package:air_pollution/constants/status_level.dart';
import 'package:air_pollution/model/stat_model.dart';
import 'package:air_pollution/repository/stat_repository.dart';
import 'package:air_pollution/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String? serviceKey = dotenv.env['SERVICE_KEY'];

  Future<List<StatModel>> fetchData(String serviceKey) async {
    return await StatRepository.fetchData(serviceKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      drawer: MainDrawer(),
      body: SafeArea(
        child: FutureBuilder<List<StatModel>>(
            future: fetchData(serviceKey!),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('에러가 있습니다.'),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<StatModel> stats = snapshot.data!;
              StatModel recentStat = stats[0];

              final status = DataUtils.getCurrentStatusFromItemCodeAndValue(
                  value: recentStat.seoul, itemCode: ItemCode.PM10);

              return CustomScrollView(
                slivers: [
                  MainAppBar(
                    stat: recentStat,
                    status: status,
                  ),
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
              );
            }),
      ),
    );
  }
}
