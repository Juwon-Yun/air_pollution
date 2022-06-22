import 'package:air_pollution/components/category_card.dart';
import 'package:air_pollution/components/hourly_card.dart';
import 'package:air_pollution/components/main_app_bar.dart';
import 'package:air_pollution/components/main_drawer.dart';
import 'package:air_pollution/constants/data_config.dart';
import 'package:air_pollution/model/stat_model.dart';
import 'package:air_pollution/repository/stat_repository.dart';
import 'package:air_pollution/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String? serviceKey = dotenv.env['SERVICE_KEY'];
  String region = regions[0];

  bool isExpanded = true;
  ScrollController scrollController = ScrollController();

  @override
  initState() {
    super.initState();

    scrollController.addListener(scrollListener);
  }

  @override
  dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchData(String serviceKey) async {
    // Map<ItemCode, List<StatModel>> stats = {};

    List<Future> futures = [];

    //병렬로 비동기 요청하기
    for (ItemCode itemCode in ItemCode.values) {
      futures.add(StatRepository.fetchData(serviceKey, itemCode: itemCode));
    }
    // final statModels =
    //     await StatRepository.fetchData(serviceKey, itemCode: itemCode);
    //
    // stats.addAll({itemCode: statModels});

    // 요청은 한번에 다 보내고
    // 모든 응답이 도착할때까지 block operation한다.
    // goroutine -> channel 같음
    final results = await Future.wait(futures);

    for (int i = 0; i < results.length; i++) {
      final key = ItemCode.values[i];
      final value = results[i];

      final box = Hive.box<StatModel>(key.name);

      for (StatModel stat in value) {
        box.put(stat.dataTime.toString(), stat);
      }
    }
  }

  scrollListener() {
    bool isExpanded = scrollController.offset < 500 - kToolbarHeight;
    if (isExpanded != this.isExpanded) {
      setState(() {
        this.isExpanded = isExpanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box<StatModel>(ItemCode.PM10.name).listenable(),
        builder: (context, box, widget) {
          final recentStat = box.values.toList().last as StatModel;

          final status = DataUtils.getCurrentStatusFromItemCodeAndValue(
            value: recentStat.getLevelFromRegion(region),
            itemCode: ItemCode.PM10,
          );
          // PM10
          // box.value.toList().last

          return Scaffold(
            drawer: MainDrawer(
              onRegionTap: (String region) {
                setState(() {
                  this.region = region;
                });
                Navigator.of(context).pop();
              },
              selectedRegion: region,
              lightColor: status.lightColor,
              darkColor: status.darkColor,
            ),
            body: Container(
              color: status.primaryColor,
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  MainAppBar(
                    isExpanded: isExpanded,
                    stat: recentStat,
                    status: status,
                    region: region,
                    dateTime: recentStat.dataTime,
                  ),
                  // Sliver 안에 일반 Widget도 사용하게 해준다.
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CategoryCard(
                          region: region,
                          darkColor: status.darkColor,
                          lightColor: status.lightColor,
                        ),
                        const SizedBox(height: 16),
                        ...ItemCode.values
                            .map((itemCode) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: HourlyCard(
                                    darkColor: status.darkColor,
                                    lightColor: status.lightColor,
                                    region: region,
                                    itemCode: itemCode,
                                  ),
                                ))
                            .toList(),
                        const SizedBox(
                          height: 16,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
