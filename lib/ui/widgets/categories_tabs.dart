import 'package:admin/logic/controllers/categories.dart';
import 'package:admin/logic/models/category_dialog.dart';
import 'package:admin/ui/screens/category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesTabs extends StatelessWidget {
  List categories;
  CategoriesTabs({Key? key, required this.categories}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) => TextButton.icon(
                icon: InkWell(
                  child: const Icon(Icons.edit),
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => CategoryDialog(
                      intent: CategoryDialogIntent.update,
                      categoriesCubit: context.read<CategoriesCubit>(),
                      name: categories[index]['name'],
                      id: categories[index]['id'],
                      visibilty: categories[index]['visiblity'],
                    ),
                  ),
                ),
                onPressed: () => context
                    .read<CategoriesCubit>()
                    .setCategory(categories[index]['id']),
                label: Text(categories[index]['name']),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (ctx) => CategoryDialog(
                      intent: CategoryDialogIntent.add,
                      categoriesCubit: context.read<CategoriesCubit>())),
              child: Icon(Icons.add))
        ],
      ),
    );
  }
}
