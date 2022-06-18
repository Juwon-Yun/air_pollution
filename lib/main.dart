import 'package:air_pollution/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

main() {
  runApp(MaterialApp(home: MainApp()));
}

initApp() {
  print(dotenv.env['SERVICE_KEY']);
}
