import 'package:admin/ui/screens/add_food.dart';
import 'package:admin/ui/screens/advertise.dart';
import 'package:admin/ui/screens/foods.dart';
import 'package:admin/ui/screens/notification.dart';
import 'package:admin/ui/screens/order.dart';
import 'package:admin/ui/screens/orders.dart';
import 'package:admin/ui/screens/proifle.dart';
import 'package:admin/ui/screens/send_notification.dart';
import 'package:admin/ui/screens/update_food.dart';
import 'package:admin/ui/screens/users.dart';
import 'package:flutter/material.dart';

class Routes {
  static const foods = '/foods';
  static const addFood = '/addFood';
  static const updateFood = '/updateFood';
  static const orders = '/orders';
  static const order = '/order';
  static const advertise = '/advertise';
  static const notification = '/notification';
  static const sendNotification = '/sendNotification';
  static const users = '/users';
  static const profile = '/profile';

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
      case orders:
        return MaterialPageRoute(builder: (_) => OrdersPage());
      case order:
        var args = settings.arguments as OrderArgs;
        return MaterialPageRoute(builder: (_) => OrderPage(args: args));
      case advertise:
        return MaterialPageRoute(builder: (_) => const AdvertisePage());
      case notification:
        return MaterialPageRoute(builder: (_) => const NotificationPage());
      case sendNotification:
        var args = settings.arguments as SendNotificationArgs;
        return MaterialPageRoute(
          builder: (_) => SendNotificationPage(
            args: args,
          ),
        );
      case users:
        return MaterialPageRoute(builder: (_) => const UsersPage());

      case profile:
        var args = settings.arguments as ProfileArgs;
        return MaterialPageRoute(
          builder: (_) => ProfilePage(
            args: args,
          ),
        );
    }
  }
}
