import 'package:flutter/material.dart';
import 'package:ratingApp/locator.dart';
import 'package:ratingApp/navigation_service.dart';
import 'package:ratingApp/route_paths.dart' as routes;
import 'package:ratingApp/router.dart' as router;

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: router.generateRouting,
      initialRoute: routes.HomeRoute,
      navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }
}
