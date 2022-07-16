import 'package:admin/logic/controllers/categories.dart';
import 'package:admin/logic/controllers/category_food.dart';
import 'package:admin/logic/models/categories.dart';
import 'package:admin/ui/screens/category_food.dart';
import 'package:admin/ui/widgets/appbar.dart';
import 'package:admin/ui/widgets/categories_tabs.dart';
import 'package:admin/ui/widgets/drawer.dart';
import 'package:admin/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodsPage extends StatelessWidget {
  FoodsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 55),
        child: AppAppBar(title: 'Menu'),
      ),
      drawer: AppDrawer(),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CategoriesCubit()),
          BlocProvider(create: (_) => CategoryFoodsCubit())
        ],
        child: BlocConsumer<CategoriesCubit, CategoriesState>(
          listenWhen: (previous, current) =>
              previous.currentId != current.currentId,
          listener: (ctx, state) =>
              ctx.read<CategoryFoodsCubit>().setId(state.currentId!),
          buildWhen: (previous, current) =>
              previous.loaded != current.loaded ||
              previous.categories != current.categories ||
              ((!current.loaded) && previous.error != current.error),
          builder: (context, state) {
            if (!state.loaded) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    Text(
                      state.error,
                      style: const TextStyle(color: Colors.red),
                    )
                  ],
                ),
              );
            } else {
              if (state.categories!.isEmpty) {
                return Column(
                  children: [
                    CategoriesTabs(categories: state.categories!),
                    const Expanded(child: Center(child: Text('no categories'))),
                  ],
                );
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CategoriesTabs(categories: state.categories!),
                  const Expanded(
                    child: CategoryFood(),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
