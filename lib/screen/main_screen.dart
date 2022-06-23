import 'package:air_pollution/container/category_card.dart';
import 'package:air_pollution/container/hourly_card.dart';
import 'package:air_pollution/components/main_app_bar.dart';
import 'package:air_pollution/components/main_drawer.dart';
import 'package:air_pollution/constants/data_config.dart';
import 'package:air_pollution/model/stat_model.dart';
import 'package:air_pollution/repository/stat_repository.dart';
import 'package:air_pollution/utils/data_utils.dart';
import 'package:dio/dio.dart';
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
    if (serviceKey != null) {
      fetchData(serviceKey!);
    }
  }

  @override
  dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchData(String serviceKey) async {
    try {
      final now = DateTime.now();
      final fetchTime = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
      );

      final box = Hive.box<StatModel>(ItemCode.PM10.name);

      if (box.values.isNotEmpty &&
          box.values.last.dataTime.isAtSameMomentAs(fetchTime)) return;

      List<Future> futures = [];

      //병렬로 비동기 요청하기
      for (ItemCode itemCode in ItemCode.values) {
        futures.add(StatRepository.fetchData(serviceKey, itemCode: itemCode));
      }

      // 요청은 한번에 다 보낸뒤
      // 모든 응답이 도착할때까지 block operation한다.
      // goroutine -> channel 같음
      final results = await Future.wait(futures);

      for (int i = 0; i < results.length; i++) {
        final itemCode = ItemCode.values[i];
        final statModel = results[i];

        final box = Hive.box<StatModel>(itemCode.name);

        for (StatModel stat in statModel) {
          box.put(stat.dataTime.toString(), stat);
        }

        final allKeys = box.keys.toList();

        if (allKeys.length > 24) {
          final deleteKeys = allKeys.sublist(0, allKeys.length - 24);
          box.deleteAll(deleteKeys);
        }
      }
    } on DioError catch (error) {
      // 요청이 안들어갔을 떄 snack bar
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        '인터넷 연결이 원활하지 않습니다.',
        textAlign: TextAlign.center,
      )));
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
    // valueListenableBuilder는 해당 valueListenable에서 listen하고 있는 데이터가 변경됬을때만
    // 재렌더링한다. 상당히 효율적이다.
    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box<StatModel>(ItemCode.PM10.name).listenable(),
        builder: (context, box, widget) {
          if (box.values.isEmpty) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          final recentStat = box.values.toList().last as StatModel;

          final pm10Status = DataUtils.getCurrentStatusFromItemCodeAndValue(
            value: recentStat.getLevelFromRegion(region),
            itemCode: ItemCode.PM10,
          );

          return Scaffold(
            drawer: MainDrawer(
              onRegionTap: (String region) {
                setState(() {
                  this.region = region;
                });
                Navigator.of(context).pop();
              },
              selectedRegion: region,
              lightColor: pm10Status.lightColor,
              darkColor: pm10Status.darkColor,
            ),
            body: Container(
              color: pm10Status.primaryColor,
              child: RefreshIndicator(
                onRefresh: () async {
                  await fetchData(serviceKey!);
                },
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    MainAppBar(
                      isExpanded: isExpanded,
                      stat: recentStat,
                      status: pm10Status,
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
                            darkColor: pm10Status.darkColor,
                            lightColor: pm10Status.lightColor,
                          ),
                          const SizedBox(height: 16),
                          ...ItemCode.values
                              .map((itemCode) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: HourlyCard(
                                      darkColor: pm10Status.darkColor,
                                      lightColor: pm10Status.lightColor,
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
            ),
          );
        });
  }
}
