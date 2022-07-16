import 'package:admin/logic/controllers/proifle.dart';
import 'package:admin/logic/models/notification.dart';
import 'package:admin/logic/models/orders.dart';
import 'package:admin/logic/models/proifle.dart';
import 'package:admin/ui/screens/order.dart';
import 'package:admin/ui/screens/send_notification.dart';
import 'package:admin/ui/widgets/appbar.dart';
import 'package:admin/ui/widgets/drawer.dart';
import 'package:admin/utilities/colors.dart';
import 'package:admin/utilities/routes.dart';
import 'package:admin/utilities/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ProfileArgs {
  Map profileData;
  ProfileArgs({
    required this.profileData,
  });
}

class ProfilePage extends StatelessWidget {
  ProfileArgs args;
  ProfilePage({Key? key, required this.args}) : super(key: key);
  DateFormat dateFormat = DateFormat('yyyy-M-d h:mm a');
  ScrollController genScrollController(ProfileCubit cubit) {
    ScrollController controller = ScrollController();
    controller.addListener(() {
      if (!cubit.state.noMore &&
          !cubit.state.loading &&
          controller.offset >= controller.position.maxScrollExtent &&
          !controller.position.outOfRange) {
        cubit.load().then((value) => null);
      }
    });
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(args.profileData),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 55),
          child: AppAppBar(title: args.profileData['name']),
        ),
        drawer: AppDrawer(),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          buildWhen: (previous, current) => previous.loaded != current.loaded,
          builder: (context, state) {
            if (!state.loaded) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.profileData['name'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.brown2,
                                ),
                              ),
                              Text(
                                state.profileData['email'] ?? '',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                state.profileData['phone'] ?? '',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () => Navigator.of(context).pushNamed(
                                  Routes.sendNotification,
                                  arguments: SendNotificationArgs(
                                      type: TargetType.user,
                                      id: args.profileData['id'])),
                              icon: const Icon(
                                Icons.send,
                                color: AppColors.brown2,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: BlocSelector<ProfileCubit, ProfileState, List>(
                    selector: (state) => state.orders,
                    builder: (context, state) {
                      if (state.isEmpty) {
                        return const Center(
                          child: Text('No Orders'),
                        );
                      }

                      return ListView.builder(
                        controller:
                            genScrollController(context.read<ProfileCubit>()),
                        itemCount: state.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 4,
                            child: InkWell(
                              onTap: () => Navigator.of(context).pushNamed(
                                  Routes.order,
                                  arguments: OrderArgs(id: state[index]['id'])),
                              child: Stack(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox.square(
                                        dimension: 64,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            Server.getAbsoluteUrl(state[index]
                                                    ['items'][0]['food']
                                                ['imageUrl']),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'status ${OrderStatus.values.where((e) => e.code == state[index]['status']).first.name}',
                                                style: const TextStyle(
                                                    color: AppColors.brown2,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            dateFormat.format(DateTime.parse(
                                                state[index]['time'])),
                                            style: const TextStyle(
                                                color: AppColors.brown2,
                                                fontSize: 18),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            'total ${state[index]['total']} jod',
                                            style: const TextStyle(
                                                color: AppColors.brown2,
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
