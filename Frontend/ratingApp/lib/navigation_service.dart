import 'package:flutter/cupertino.dart';

class NavigationService{
  final GlobalKey<NavigatorState> navigatorKey =
  new GlobalKey<NavigatorState>();

  /*Future<dynamic> navigateTo(String routeName){
    return navigatorKey.currentState.pushNamed(routeName);
  }*/
  Future<dynamic> navigateTo(String routeName, {dynamic args}){
    return navigatorKey.currentState.pushNamed(routeName, arguments: args);
  }

  void goBack(){
    return navigatorKey.currentState.pop();
  }
}