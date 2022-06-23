import 'package:air_pollution/containers/category_card.dart';
import 'package:air_pollution/containers/hourly_card.dart';
import 'package:air_pollution/components/main_app_bar.dart';
import 'package:air_pollution/components/main_drawer.dart';
import 'package:air_pollution/constants/data_config.dart';
import 'package:air_pollution/models/stat_model.dart';
import 'package:air_pollution/utils/data_utils.dart';
import 'package:air_pollution/viewModels/stat_view_model.dart';
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
      StatViewModel.fetchPollution(serviceKey: serviceKey!, context: context);
    }
  }

  @override
  dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
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
          final pm10RecentStat = box.values.toList().last as StatModel;

          final pm10Status = DataUtils.getCurrentStatusFromItemCodeAndValue(
            value: pm10RecentStat.getLevelFromRegion(region),
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
                  await StatViewModel.fetchPollution(
                      serviceKey: serviceKey!, context: context);
                },
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    MainAppBar(
                      isExpanded: isExpanded,
                      stat: pm10RecentStat,
                      status: pm10Status,
                      region: region,
                      dateTime: pm10RecentStat.dataTime,
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
