import 'package:air_pollution/components/category_card.dart';
import 'package:air_pollution/components/hourly_card.dart';
import 'package:air_pollution/components/main_app_bar.dart';
import 'package:air_pollution/components/main_drawer.dart';
import 'package:air_pollution/constants/data_config.dart';
import 'package:air_pollution/model/stat_and_status_model.dart';
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
  String region = regions[0];

  Future<Map<ItemCode, List<StatModel>>> fetchData(String serviceKey) async {
    Map<ItemCode, List<StatModel>> stats = {};

    List<Future> futures = [];

    //병렬로 비동기 요청하기
    for (ItemCode itemCode in ItemCode.values) {
      futures.add(StatRepository.fetchData(serviceKey, itemCode: itemCode));

      // final statModels =
      //     await StatRepository.fetchData(serviceKey, itemCode: itemCode);
      //
      // stats.addAll({itemCode: statModels});
    }

    // 요청은 한번에 다 보내고
    // 모든 응답이 도착할때까지 block operation한다.
    // goroutine -> channel 같음
    final results = await Future.wait(futures);

    for (int i = 0; i < results.length; i++) {
      final key = ItemCode.values[i];
      final value = results[i];

      stats.addAll({key: value});
    }

    return stats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(
        onRegionTap: (String region) {
          setState(() {
            this.region = region;
          });
          Navigator.of(context).pop();
        },
        selectedRegion: region,
      ),
      body: FutureBuilder<Map<ItemCode, List<StatModel>>>(
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

            Map<ItemCode, List<StatModel>> stats = snapshot.data!;
            StatModel pm10RecentStat = stats[ItemCode.PM10]![0];

            // 미세먼지 최근 데이터의 현재 상태
            final status = DataUtils.getCurrentStatusFromItemCodeAndValue(
                value: pm10RecentStat.seoul, itemCode: ItemCode.PM10);

            final filteredByRegion = stats.keys.map((itemCode) {
              final value = stats[itemCode];
              // stats[ItemCode.PM10]![0] 와는 다르게 모든 오염 수치를 다 넣는다.
              final stat = value![0];

              return StatAndStatusModel(
                  statusModel: DataUtils.getCurrentStatusFromItemCodeAndValue(
                      value: stat.getLevelFromRegion(region),
                      itemCode: itemCode),
                  statModel: stat,
                  itemCode: itemCode);
            }).toList();

            return Container(
              color: status.primaryColor,
              child: CustomScrollView(
                slivers: [
                  MainAppBar(
                    stat: pm10RecentStat,
                    status: status,
                    region: region,
                  ),
                  // Sliver 안에 일반 Widget도 사용하게 해준다.
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CategoryCard(
                          region: region,
                          models: filteredByRegion,
                          darkColor: status.darkColor,
                          lightColor: status.lightColor,
                        ),
                        const SizedBox(height: 16),
                        HourlyCard(
                          darkColor: status.darkColor,
                          lightColor: status.lightColor,
                          category: DataUtils.getItemCodeToKrString(
                              itemCode: ItemCode.PM10),
                          region: region,
                          stats: stats[ItemCode.PM10]!,
                        ),
                        const SizedBox(
                          height: 32,
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
