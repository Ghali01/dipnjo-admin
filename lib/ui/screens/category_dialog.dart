import 'package:admin/logic/controllers/categories.dart';
import 'package:admin/logic/controllers/category_dialog.dart';
import 'package:admin/logic/models/category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryDialog extends StatelessWidget {
  final String name;
  final int? id;
  final bool? visibilty;
  CategoryDialogIntent intent;
  CategoriesCubit categoriesCubit;
  final TextEditingController controller = TextEditingController();
  CategoryDialog(
      {Key? key,
      required this.intent,
      required this.categoriesCubit,
      this.name = '',
      this.id,
      this.visibilty})
      : super(key: key) {
    controller.text = name;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoryDialogCubit(intent, categoriesCubit, visibilty),
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 250,
            height: 140,
            child: BlocConsumer<CategoryDialogCubit, CategoryDialogState>(
              listenWhen: (previous, current) => current.done,
              listener: (context, state) => Navigator.of(context).pop(),
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      intent == CategoryDialogIntent.add
                          ? "Add Categroy"
                          : "Edit Category",
                      style: const TextStyle(fontSize: 26),
                    ),
                    TextField(
                      controller: controller,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        state.loading
                            ? const CircularProgressIndicator()
                            : const SizedBox(),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => context
                                  .read<CategoryDialogCubit>()
                                  .save(controller.text, id),
                              child: Text(
                                intent == CategoryDialogIntent.add
                                    ? "Add"
                                    : "Edit",
                              ),
                            ),
                            intent == CategoryDialogIntent.update
                                ? BlocSelector<CategoryDialogCubit,
                                    CategoryDialogState, bool>(
                                    selector: (state) => state.visiblity!,
                                    builder: (context, state) {
                                      return TextButton(
                                          onPressed: () => context
                                              .read<CategoryDialogCubit>()
                                              .setVisibilty(id!),
                                          child: Text(
                                              state == true ? 'hide' : "show"));
                                    },
                                  )
                                : const SizedBox()
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
