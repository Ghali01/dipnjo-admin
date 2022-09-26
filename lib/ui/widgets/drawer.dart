import 'package:admin/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utilities/colors.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key}) : super(key: key);
  final List items = [
    {'label': 'Menu', 'icon': 'menu', 'route': Routes.foods, 'args': null},
    {'label': 'Orders', 'icon': 'orders', 'route': Routes.orders, 'args': null},
    {
      'label': 'Notifications',
      'icon': 'notification',
      'route': Routes.notification,
      'args': null
    },
    {
      'label': 'Advertise',
      'icon': 'ads',
      'route': Routes.advertise,
      'args': null
    },
    {'label': 'Users', 'icon': 'users', 'route': Routes.users, 'args': null},
    {
      'label': 'Scan QR',
      'icon': 'qr',
      'route': Routes.chargePoints,
      'args': null
    },
    {
      'label': 'Coupons',
      'icon': 'coupon',
      'route': Routes.coupons,
      'args': null
    },
    // {'label': '', 'icon': '', 'route': null, 'args': null},
  ];
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          SizedBox(
            height: 100,
            width: double.infinity,
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Image.asset(
                'assets/images/drawer-header.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          ...(items
              .map((e) => InkWell(
                    onTap: () => Navigator.of(context)
                        .pushReplacementNamed(e['route'], arguments: e['args']),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SvgPicture.asset(
                              'assets/svg/${e['icon']}.svg',
                              width: 30,
                              height: 30,
                              color: AppColors.brown4,
                            ),
                          ),
                          Text(
                            e['label'],
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: AppColors.brown4),
                          )
                        ],
                      ),
                    ),
                  ))
              .toList()),
        ],
      ),
    );
  }
}
