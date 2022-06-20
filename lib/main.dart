import 'package:air_pollution/constants/custom_theme.dart';
import 'package:air_pollution/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initController();

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false, home: MainApp(), theme: customTheme));
}

initController() async {
  await dotenv.load(fileName: ".env");
}
