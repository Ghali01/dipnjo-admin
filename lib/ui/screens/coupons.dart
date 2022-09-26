import 'package:admin/logic/controllers/coupons.dart';
import 'package:admin/logic/models/coupons.dart';
import 'package:admin/ui/screens/add_coupon.dart';
import 'package:admin/ui/widgets/appbar.dart';
import 'package:admin/ui/widgets/drawer.dart';
import 'package:admin/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CouponsPage extends StatelessWidget {
  const CouponsPage({Key? key}) : super(key: key);
  ScrollController genScrollController(CouponsCubit cubit) {
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
      create: (context) => CouponsCubit(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 55),
          child: AppAppBar(title: 'Coupons'),
        ),
        drawer: AppDrawer(),
        body: BlocSelector<CouponsCubit, CouponsState, bool>(
          selector: (state) => state.loaded,
          builder: (context, state) {
            if (!state) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Builder(
                    builder: (context) => TextField(
                      onChanged: (v) =>
                          context.read<CouponsCubit>().setTextSearch(v),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: 'Search ',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade500, fontSize: 17),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade500,
                          size: 32,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                      child: BlocSelector<CouponsCubit, CouponsState, List>(
                    selector: (state) => state.coupons,
                    builder: (context, state) {
                      return ListView.builder(
                          controller:
                              genScrollController(context.read<CouponsCubit>()),
                          itemCount: state.length,
                          itemBuilder: (context, index) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state[index]['key'],
                                        style: const TextStyle(
                                            color: AppColors.brown2,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        state[index]['type'] == 'p'
                                            ? '${state[index]['value']}%'
                                            : '${state[index]['value']} jod',
                                        style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 19,
                                        ),
                                      ),
                                      Text(
                                        'used by ${state[index]['usedBy']}',
                                        style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 19,
                                        ),
                                      ),
                                    ],
                                  ),
                                  state[index]['loading'] == true
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : state[index]['enabled']
                                          ? IconButton(
                                              onPressed: () => context
                                                  .read<CouponsCubit>()
                                                  .setStatus(state[index]['id'],
                                                      false),
                                              icon: const Icon(
                                                Icons.close,
                                                color: AppColors.brown2,
                                              ),
                                            )
                                          : IconButton(
                                              onPressed: () => context
                                                  .read<CouponsCubit>()
                                                  .setStatus(
                                                      state[index]['id'], true),
                                              icon: const Icon(
                                                Icons.done,
                                                color: AppColors.brown2,
                                              ),
                                            )
                                ],
                              ));
                    },
                  )),
                  BlocSelector<CouponsCubit, CouponsState, bool>(
                    selector: (state) => state.loading,
                    builder: (context, state) => state
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () async {
              var data = await showDialog(
                  context: context, builder: (_) => AddCouponDialog());
              if (data != null) {
                context.read<CouponsCubit>().add(data);
              }
            },
            backgroundColor: AppColors.brown4,
            child: const Icon(Icons.add),
          );
        }),
      ),
    );
  }
}
