import 'package:air_pollution/components/category_card.dart';
import 'package:air_pollution/components/hourly_card.dart';
import 'package:air_pollution/components/main_app_bar.dart';
import 'package:air_pollution/components/main_drawer.dart';
import 'package:air_pollution/constants/custom_theme.dart';
import 'package:air_pollution/repository/stat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String? serviceKey = dotenv.env['SERVICE_KEY'];

  @override
  void initState() {
    super.initState();
    if (serviceKey != null) {
      fetchData(serviceKey!);
    }
  }

  fetchData(String serviceKey) async {
    final statModels = await StatRepository.fetchData(serviceKey);

    print(statModels);
  }

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
