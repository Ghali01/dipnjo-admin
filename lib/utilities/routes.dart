import 'package:admin/ui/screens/add_food.dart';
import 'package:admin/ui/screens/foods.dart';
import 'package:admin/ui/screens/update_food.dart';
import 'package:flutter/material.dart';

class Routes {
  static const foods = '/foods';
  static const addFood = '/addFood';
  static const updateFood = '/updateFood';

  static Route? generator(RouteSettings settings) {
    switch (settings.name) {
      case foods:
        return MaterialPageRoute(builder: (_) => FoodsPage());
      case addFood:
        var args = settings.arguments as AddFoodArgs;
        return MaterialPageRoute(
          builder: (_) => AddFoodPage(
            args: args,
          ),
        );
      case updateFood:
        var args = settings.arguments as UpdateFoodArgs;
        return MaterialPageRoute(
          builder: (_) => UpdateFoodPage(
            args: args,
          ),
        );
    }
  }
}
