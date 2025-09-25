import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ayana_tmdb/core/di/injector.dart' as di;
import 'package:hive_flutter/hive_flutter.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Init Hive
    await Hive.initFlutter();


    // Init DI
    await di.init();

    runApp(await builder());
  }, (error, stack) {
    debugPrint('Uncaught error: $error');
    debugPrint('$stack');
  });
}
