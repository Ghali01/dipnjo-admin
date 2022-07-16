import 'package:admin/ui/screens/order.dart';
import 'package:admin/ui/widgets/appbar.dart';
import 'package:admin/ui/widgets/drawer.dart';
import 'package:admin/utilities/routes.dart';
import 'package:admin/utilities/server.dart';
import 'package:intl/intl.dart';
import 'package:admin/logic/controllers/orders.dart';
import 'package:admin/logic/models/orders.dart';
import 'package:admin/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersPage extends StatelessWidget {
  OrdersPage({Key? key}) : super(key: key);

  DateFormat dateFormat = DateFormat('yyyy-M-d h:mm a');
  ScrollController genScrollController(OrdersCubit cubit) {
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
      create: (context) => OrdersCubit(),
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 55),
          child: AppAppBar(
            title: 'Orders',
            actions: [
              BlocSelector<OrdersCubit, OrdersState, bool>(
                selector: (state) => state.reloading,
                builder: (context, state) {
                  return state
                      ? const CircularProgressIndicator(
                          // color: Colors.white,
                          )
                      : IconButton(
                          onPressed: () {
                            context.read<OrdersCubit>().reload();
                          },
                          icon: const Icon(
                            Icons.refresh,
                            // color: Colors.white,
                          ));
                  ;
                },
              )
            ],
          ),
        ),
        body: BlocSelector<OrdersCubit, OrdersState, bool>(
          selector: (state) => state.loaded,
          builder: (context, state) {
            if (!state) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 8,
                    ),
                    BlocSelector<OrdersCubit, OrdersState, String?>(
                      selector: (state) => state.filterStatus,
                      builder: (context, state) {
                        return DropdownButton<String>(
                            value: state,
                            hint: const Text('Order Status'),
                            items: (OrderStatus.values
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.code,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList()
                              ..insert(
                                  0,
                                  const DropdownMenuItem(
                                    value: null,
                                    child: Text('All'),
                                  ))),
                            onChanged: (v) =>
                                context.read<OrdersCubit>().setStatus(v));
                      },
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    BlocSelector<OrdersCubit, OrdersState, String?>(
                      selector: (state) => state.filterMethod,
                      builder: (context, state) {
                        return DropdownButton<String>(
                            value: state,
                            hint: const Text('Pay Method'),
                            items: (PayMethod.values
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.code,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList()
                              ..insert(
                                  0,
                                  const DropdownMenuItem(
                                    value: null,
                                    child: Text('All'),
                                  ))),
                            onChanged: (v) =>
                                context.read<OrdersCubit>().setMethod(v));
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: BlocSelector<OrdersCubit, OrdersState, List>(
                    selector: (state) => state.orders,
                    builder: (context, state) {
                      if (state.isEmpty) {
                        return const Center(
                          child: Text('No Orders'),
                        );
                      }

                      return ListView.builder(
                        controller:
                            genScrollController(context.read<OrdersCubit>()),
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
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Builder(builder: (context) {
                                      if (state[index]['loading'] == true) {
                                        return const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: SizedBox.square(
                                              dimension: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              )),
                                        );
                                      }
                                      List statusL = OrderStatus.values
                                          .where((element) =>
                                              element.code ==
                                              state[index]['status'])
                                          .first
                                          .nextStatus(
                                              state[index]['payMethod']);
                                      if (statusL.isEmpty) {
                                        return const SizedBox();
                                      }
                                      return PopupMenuButton<String>(
                                        iconSize: 20,
                                        itemBuilder: (context) => statusL
                                            .map((e) => PopupMenuItem<String>(
                                                  value: e.code,
                                                  child: Text(e.name),
                                                ))
                                            .toList(),
                                        onSelected: (v) => context
                                            .read<OrdersCubit>()
                                            .setItemStatus(
                                                v, state[index]['id']),
                                      );
                                    }),
                                  ),
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
                                                'user ${state[index]['user']['name']}',
                                                style: const TextStyle(
                                                    color: AppColors.brown2,
                                                    fontSize: 18),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
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
