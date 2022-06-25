import 'package:admin/logic/controllers/categories.dart';
import 'package:admin/logic/controllers/category_food.dart';
import 'package:admin/logic/models/category_food.dart';
import 'package:admin/ui/screens/add_food.dart';
import 'package:admin/ui/widgets/foos_item.dart';
import 'package:admin/utilities/routes.dart';
import 'package:admin/utilities/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryFood extends StatelessWidget {
  const CategoryFood({Key? key}) : super(key: key);
  ScrollController createController(CategoryFoodsCubit cubit) {
    ScrollController controller = ScrollController();
    controller.addListener(() {
      if (cubit.state.loaded &&
          !cubit.state.isEnd &&
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
    return BlocSelector<CategoryFoodsCubit, CategoryFoodsState, bool>(
      selector: (state) => state.loaded,
      builder: (context, state) {
        if (!state) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: BlocSelector<CategoryFoodsCubit, CategoryFoodsState,
                      List>(
                    selector: (state) => state.foods,
                    builder: (context, state) {
                      // print(state);
                      return GridView.builder(
                        controller: createController(
                            context.read<CategoryFoodsCubit>()),
                        itemCount: state.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 1200
                                  ? 4
                                  : MediaQuery.of(context).size.width > 900
                                      ? 3
                                      : MediaQuery.of(context).size.width > 700
                                          ? 2
                                          : 1,
                          childAspectRatio: 1.25,
                        ),
                        itemBuilder: (ctx, index) => FoodItem(
                          name: state[index]['name'],
                          id: state[index]['id'],
                          imageUrl:
                              Server.getAbsoluteUrl(state[index]['imageUrl']),
                          price: state[index]['price'].toString(),
                        ),
                      );
                    },
                  ),
                ),
                BlocSelector<CategoryFoodsCubit, CategoryFoodsState, bool>(
                  selector: (state) => state.loading,
                  builder: (context, state) {
                    return state
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : const SizedBox();
                  },
                )
              ],
            ),
            Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(Routes.addFood,
                            arguments: AddFoodArgs(
                              context.read<CategoriesCubit>().state.currentId!,
                            )),
                    child: Icon(Icons.add),
                  ),
                ))
          ],
        );
      },
    );
  }
}
