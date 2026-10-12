import 'package:driver_diary/app/di/locator.dart';
import 'package:driver_diary/app/my_app.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const MyApp());
}
