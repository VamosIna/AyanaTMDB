import 'package:ayana_tmdb/app/app.dart';
import 'package:flutter/material.dart';
import 'package:ayana_tmdb/core/di/injector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}
