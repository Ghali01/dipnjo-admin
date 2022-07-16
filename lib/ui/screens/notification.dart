import 'package:admin/logic/controllers/notification.dart';
import 'package:admin/logic/models/notification.dart';
import 'package:admin/ui/screens/send_notification.dart';
import 'package:admin/ui/widgets/appbar.dart';
import 'package:admin/ui/widgets/drawer.dart';
import 'package:admin/utilities/colors.dart';
import 'package:admin/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 55),
          child: AppAppBar(title: 'Notification'),
        ),
        drawer: AppDrawer(),
        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            return Column(
              children: [
                RadioListTile<TargetType>(
                  title: const Text(
                    'All',
                    style: TextStyle(
                        color: AppColors.brown2, fontWeight: FontWeight.w700),
                  ),
                  activeColor: AppColors.brown1,
                  value: TargetType.all,
                  groupValue: state.type,
                  onChanged: (v) =>
                      context.read<NotificationCubit>().setType(v!),
                ),
                RadioListTile<TargetType>(
                  title: const Text(
                    'Age',
                    style: TextStyle(
                        color: AppColors.brown2, fontWeight: FontWeight.w700),
                  ),
                  activeColor: AppColors.brown1,
                  value: TargetType.age,
                  groupValue: state.type,
                  onChanged: (v) =>
                      context.read<NotificationCubit>().setType(v!),
                ),
                RangeSlider(
                  values: RangeValues(
                      (state.from).toDouble(), (state.to).toDouble()),
                  max: DateTime.now().year.toDouble(),
                  min: 1950,
                  activeColor: AppColors.brown1,
                  onChanged: state.type == TargetType.age
                      ? (v) => context.read<NotificationCubit>().setRange(
                            v.start.toInt(),
                            v.end.toInt(),
                          )
                      : null,
                ),
                state.from != null
                    ? Text(
                        '${state.from}-${state.to}',
                        style: TextStyle(
                            color: state.type == TargetType.age
                                ? AppColors.brown1
                                : Colors.grey.shade700),
                      )
                    : const SizedBox(),
                ElevatedButton(
                    onPressed: () {
                      NotificationState state =
                          context.read<NotificationCubit>().state;
                      Navigator.of(context).pushNamed(Routes.sendNotification,
                          arguments: SendNotificationArgs(
                              type: state.type,
                              from: state.from,
                              to: state.to));
                    },
                    child: const Text('Next'))
              ],
            );
          },
        ),
      ),
    );
  }
}
