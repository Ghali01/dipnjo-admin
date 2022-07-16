import 'package:admin/ui/screens/update_food.dart';
import 'package:admin/utilities/colors.dart';
import 'package:admin/utilities/routes.dart';
import 'package:flutter/material.dart';

class FoodItem extends StatelessWidget {
  final int id;
  final String name, imageUrl, price;

  const FoodItem({
    Key? key,
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.fill,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null ||
                            loadingProgress.expectedTotalBytes ==
                                loadingProgress.cumulativeBytesLoaded
                        ? child
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      price,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () => Navigator.of(context).pushNamed(
                            Routes.updateFood,
                            arguments: UpdateFoodArgs(id)),
                        icon: const Icon(
                          Icons.edit,
                          color: AppColors.brown1,
                        ))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
