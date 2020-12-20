import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ratingApp/route_paths.dart' as routes;
import 'package:ratingApp/ui/pages/add_item.dart';
import 'package:ratingApp/ui/pages/home.dart';
import 'package:ratingApp/ui/pages/rating_page.dart';
import 'package:ratingApp/ui/pages/auth/register.dart';
import 'package:ratingApp/ui/pages/auth/signin.dart';

Route<dynamic> generateRouting(RouteSettings settings){
  switch(settings.name){
    case routes.HomeRoute:
      return MaterialPageRoute(builder: (context) => Home());
    case routes.RatingRoute:
      return MaterialPageRoute(builder: (context) => RatingPage(entry: settings.arguments));
    case routes.AddItemRoute:
      return MaterialPageRoute(builder: (context) => AddItem());
    case routes.SignInRoute:
      return MaterialPageRoute(builder: (context) => SignIn());
    case routes.RegisterRoute:
      return MaterialPageRoute(builder: (context) => Register());
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text('No path for ${settings.name}'),
          ),
        ),
      );
  }
}