import 'package:air_pollution/constants/custom_theme.dart';
import 'package:air_pollution/models/stat_model.dart';
import 'package:air_pollution/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

const testBox = 'test';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initController();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const MainApp(),
    theme: customTheme,
  ));
}

initController() async {
  await dotenv.load(fileName: ".env");

  await Hive.initFlutter();

  // StatModel Type의 Hive 사용하기
  Hive.registerAdapter<StatModel>(StatModelAdapter());
  Hive.registerAdapter<ItemCode>(ItemCodeAdapter());

  await Hive.openBox(testBox);

  for (ItemCode itemCode in ItemCode.values) {
    await Hive.openBox<StatModel>(itemCode.name);
  }
}
