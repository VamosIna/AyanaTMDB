import 'package:ayana_tmdb/app/app.dart';
import 'package:flutter/material.dart';
import 'package:ayana_tmdb/core/di/injector.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await init();
  runApp(const MyApp());
}
