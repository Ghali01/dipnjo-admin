import 'package:admin/utilities/colors.dart';
import 'package:flutter/material.dart';

class AppAppBar extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  AppAppBar({Key? key, required this.title, this.actions = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
            color: AppColors.brown2, fontWeight: FontWeight.w700),
      ),
      leading: Navigator.of(context).canPop()
          ? IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.brown2,
              ),
            )
          : IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(
                Icons.menu,
                color: AppColors.brown2,
              ),
            ),
      actions: actions,
    );
  }
}
