import 'package:admin/logic/models/order.dart';
import 'package:admin/logic/models/orders.dart';
import 'package:admin/ui/widgets/appbar.dart';
import 'package:admin/utilities/colors.dart';
import 'package:admin/utilities/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:admin/logic/controllers/order.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class OrderArgs {
  int id;
  OrderArgs({
    required this.id,
  });
}

class OrderPage extends StatelessWidget {
  OrderArgs args;
  OrderPage({Key? key, required this.args}) : super(key: key);
  final DateFormat format = DateFormat('M/d h:m');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 55),
        child: AppAppBar(title: 'Order'),
      ),
      body: BlocProvider(
          create: (context) => OrderCubit(args.id),
          child: BlocBuilder<OrderCubit, OrderState>(
            buildWhen: (previous, current) => previous.loaded != current.loaded,
            builder: (context, state) {
              if (!state.loaded) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                children: [
                  ...(state.data!['items']
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Card(
                              elevation: 4,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: SizedBox.square(
                                          dimension: 80,
                                          child: Image.network(
                                            Server.getAbsoluteUrl(
                                                e['food']['imageUrl']),
                                            fit: BoxFit.fill,
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              e['food']['name'],
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: AppColors.brown2),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              e['count'].toString(),
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: AppColors.brown2),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${e['total']} JOD',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: AppColors.brown2),
                                            ),
                                          ],
                                        ),
                                        e['freeItems'] > 0
                                            ? Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'free: ${e['freeItems']}',
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color:
                                                            AppColors.brown2),
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    'points ${e['usedPoints']}',
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color:
                                                            AppColors.brown2),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(),
                                        e['note'].isNotEmpty
                                            ? Text(
                                                'note: ${e['note']}',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: AppColors.brown2),
                                              )
                                            : const SizedBox(),
                                        e['additions'].isNotEmpty
                                            ? ListView(
                                                shrinkWrap: true,
                                                children: [
                                                  const Text(
                                                    'Additions',
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        color:
                                                            AppColors.brown2),
                                                  ),
                                                  ...(e['additions']
                                                      .map(
                                                        (a) => Row(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color: AppColors
                                                                      .brown2,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              width: 10,
                                                              height: 10,
                                                            ),
                                                            const SizedBox(
                                                              width: 8,
                                                            ),
                                                            Text(
                                                              a['name'],
                                                              style: const TextStyle(
                                                                  fontSize: 20,
                                                                  color: AppColors
                                                                      .brown2),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                      .toList())
                                                ],
                                              )
                                            : const SizedBox()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList()),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'User:',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.brown2,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  state.data!['user']['name'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: AppColors.brown2,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total:',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.brown2,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  state.data!['total'].toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: AppColors.brown2,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Delivery Fee:',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.brown2,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  state.data!['fee'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: AppColors.brown2,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Status:',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.brown2,
                                      fontWeight: FontWeight.w700),
                                ),
                                BlocSelector<OrderCubit, OrderState, String>(
                                  selector: (state) => state.status!.name,
                                  builder: (context, state) {
                                    return Text(
                                      state,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: AppColors.brown2,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Pay Method:',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.brown2,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  PayMethod.values
                                      .where((element) =>
                                          element.code ==
                                          state.data!['payMethod'])
                                      .first
                                      .name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: AppColors.brown2,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Recieve Time:',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.brown2,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  state.data!['recieveTime'] != null
                                      ? state.data!['recieveTime']
                                      : 'ASAP',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: AppColors.brown2,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Date:',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.brown2,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  format.format(
                                      DateTime.parse(state.data!['time'])),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: AppColors.brown2,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Address:',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.brown2,
                                      fontWeight: FontWeight.w700),
                                ),
                                Expanded(
                                  child: Text(
                                    state.data!['location']['details'],
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: AppColors.brown2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Builder(builder: (context) {
                              if (state.data!['coupon'] == null) {
                                return const SizedBox();
                              }
                              String text;
                              if (state.data!['coupon']['type'] == 'p') {
                                text =
                                    state.data!['coupon']['value'].toString() +
                                        '%';
                              } else {
                                text =
                                    state.data!['coupon']['value'].toString() +
                                        " JOD";
                              }
                              return Row(
                                children: [
                                  const Text(
                                    'Coupon:',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: AppColors.brown2,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Expanded(
                                    child: Text(
                                      text,
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: AppColors.brown2,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 7,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 250,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    double.parse(
                                        state.data!['location']['lat']),
                                    double.parse(
                                        state.data!['location']['lng']),
                                  ),
                                  zoom: 20),
                              zoomGesturesEnabled: false,
                              zoomControlsEnabled: false,
                              scrollGesturesEnabled: false,
                              rotateGesturesEnabled: false,
                              markers: {
                                Marker(
                                    markerId: const MarkerId('user'),
                                    position: LatLng(
                                        double.parse(
                                            state.data!['location']['lat']),
                                        double.parse(
                                            state.data!['location']['lng'])))
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      color: Colors.black,
                                      size: 32,
                                    ),
                                    Text(
                                      state.data!['location']['name'],
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 12),
                                  child: Text(
                                    state.data!['location']['details'],
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 12),
                                    child: Text(
                                      'Mobile: ${state.data!['user']['phone']}',
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<OrderCubit, OrderState>(
                        buildWhen: (previous, current) =>
                            previous.nextStatus != current.nextStatus ||
                            previous.status != current.status,
                        builder: (context, state) => state.status!
                                .nextStatus(state.data!['payMethod'])
                                .isNotEmpty
                            ? DropdownButton<OrderStatus>(
                                value: state.nextStatus ?? state.status,
                                items: (state.status!
                                    .nextStatus(state.data!['payMethod'])
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.name),
                                      ),
                                    )
                                    .toList()
                                  ..insert(
                                    0,
                                    DropdownMenuItem(
                                      value: state.status!,
                                      child: Text(state.status!.name),
                                    ),
                                  )),
                                onChanged: (v) => context
                                    .read<OrderCubit>()
                                    .setNextStatus(v!),
                              )
                            : const SizedBox(),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      BlocBuilder<OrderCubit, OrderState>(
                        builder: (context, state) => state.nextStatus == null ||
                                state.nextStatus == state.status
                            ? const SizedBox()
                            : state.loading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: () =>
                                        context.read<OrderCubit>().save(),
                                    child: const Text('Save')),
                      )
                    ],
                  ),
                ],
              );
            },
          )),
    );
  }
}
