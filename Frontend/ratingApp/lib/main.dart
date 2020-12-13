import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ratingApp/locator.dart';
import 'package:ratingApp/navigation_service.dart';
import 'package:ratingApp/route_paths.dart' as routes;
import 'package:ratingApp/router.dart' as router;


void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        brightness: Brightness.dark
      ),
      onGenerateRoute: router.generateRouting,
      initialRoute: routes.RegisterRoute,
      navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }
}
