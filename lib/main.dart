import 'package:air_pollution/constants/custom_theme.dart';
import 'package:air_pollution/screen/main_screen.dart';
import 'package:air_pollution/screen/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

const testBox = 'test';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox(testBox);

  await initController();

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TestScreen(),
      theme: customTheme));
}

initController() async {
  await dotenv.load(fileName: ".env");
}
