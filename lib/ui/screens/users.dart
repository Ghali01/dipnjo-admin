import 'package:admin/logic/controllers/users.dart';
import 'package:admin/logic/models/users.dart';
import 'package:admin/ui/screens/proifle.dart';
import 'package:admin/ui/widgets/appbar.dart';
import 'package:admin/ui/widgets/drawer.dart';
import 'package:admin/utilities/colors.dart';
import 'package:admin/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);
  ScrollController genScrollController(UsersCubit cubit) {
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
      create: (context) => UsersCubit(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 55),
          child: AppAppBar(title: 'Users'),
        ),
        drawer: AppDrawer(),
        body: BlocSelector<UsersCubit, UsersState, bool>(
          selector: (state) => state.loaded,
          builder: (context, state) {
            if (!state) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Builder(
                    builder: (context) => TextField(
                          onChanged: (v) =>
                              context.read<UsersCubit>().setTextSearch(v),
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            hintText: 'Search',
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
                        )),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: BlocSelector<UsersCubit, UsersState, List>(
                    selector: (state) => state.users,
                    builder: (context, state) {
                      return ListView.builder(
                        controller:
                            genScrollController(context.read<UsersCubit>()),
                        itemCount: state.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(
                            state[index]['name'],
                            style: const TextStyle(color: AppColors.brown4),
                          ),
                          onTap: () => Navigator.of(context).pushNamed(
                              Routes.profile,
                              arguments:
                                  ProfileArgs(profileData: state[index])),
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
