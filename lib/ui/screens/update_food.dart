import 'dart:io';

import 'package:admin/logic/controllers/update_food.dart';
import 'package:admin/logic/models/update_food.dart';
import 'package:admin/ui/screens/offer_dialog.dart';
import 'package:admin/ui/widgets/appbar.dart';
import 'package:admin/utilities/colors.dart';
import 'package:admin/utilities/routes.dart';
import 'package:admin/utilities/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class UpdateFoodArgs {
  int id;
  UpdateFoodArgs(this.id);
}

class UpdateFoodPage extends StatelessWidget {
  UpdateFoodArgs args;
  UpdateFoodPage({Key? key, required this.args}) : super(key: key);
  TextEditingController name = TextEditingController(),
      price = TextEditingController(),
      points = TextEditingController(),
      desc = TextEditingController();
  DateFormat dateFormat = DateFormat('yyyy-M-d H:m');
  String? isNotEmpty(String? text) {
    if (text == null || text.isEmpty) {
      return 'this field should not be empty';
    }
  }

  String? validatePrice(String? text) {
    if (text == null || text.isEmpty) {
      return 'this field should not be empty';
    } else {
      RegExp regex = RegExp(r'(^\d+$)|(^\d+\.{1}\d+$)');
      if (!regex.hasMatch(text)) {
        return 'enter valid price';
      }
    }
  }

  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateFoodCubit(args.id),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 55),
          child: AppAppBar(title: 'Order'),
        ),
        resizeToAvoidBottomInset: false,
        body: BlocBuilder<UpdateFoodCubit, UpdateFoodState>(
          buildWhen: (previous, current) =>
              previous.loaded != current.loaded ||
              ((!current.loaded) && previous.error != current.error),
          builder: (context, state) {
            if (!state.loaded) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      state.error,
                      style: const TextStyle(color: Colors.red),
                    )
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Form(
                        key: formKey,
                        child: Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                cursorColor: AppColors.brown1,
                                controller: name..text = state.data!['name'],
                                validator: isNotEmpty,
                                decoration: const InputDecoration(
                                  hintText: "Name",
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.brown2,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                cursorColor: AppColors.brown1,
                                controller: price
                                  ..text = state.data!['price'].toString(),
                                validator: validatePrice,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'\d|\.?')),
                                ],
                                decoration: const InputDecoration(
                                  hintText: "Price",
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.brown2,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                cursorColor: AppColors.brown1,
                                controller: points
                                  ..text =
                                      (state.data!['points'] ?? '').toString(),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                  hintText: "Repalce Point",
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.brown2,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                cursorColor: AppColors.brown1,
                                controller: desc..text = state.data!['desc'],
                                minLines: 3,
                                maxLines: 7,
                                decoration: const InputDecoration(
                                  hintText: 'Description',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.brown2,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                      MediaQuery.of(context).size.width > 700
                          ? Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 300,
                                    child: BlocSelector<UpdateFoodCubit,
                                        UpdateFoodState, File?>(
                                      selector: (state) => state.imageFile,
                                      builder: (context, state2) {
                                        return Image(
                                          image: (state2 != null
                                              ? FileImage(state2)
                                              : NetworkImage(
                                                  Server.getAbsoluteUrl(
                                                      state.data!['imageUrl']),
                                                )) as ImageProvider<Object>,
                                          fit: BoxFit.fill,
                                          loadingBuilder: (context, child,
                                                  loadingProgress) =>
                                              loadingProgress == null ||
                                                      loadingProgress
                                                              .expectedTotalBytes ==
                                                          loadingProgress
                                                              .cumulativeBytesLoaded
                                                  ? child
                                                  : const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocSelector<UpdateFoodCubit, UpdateFoodState, bool>(
                        selector: (state) => state.loading,
                        builder: (context, state) => state
                            ? const CircularProgressIndicator()
                            : const SizedBox(),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Builder(
                        builder: (context) => ElevatedButton(
                          onPressed: () =>
                              context.read<UpdateFoodCubit>().setImage(),
                          child: Text('select image'),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      BlocSelector<UpdateFoodCubit, UpdateFoodState, bool>(
                        selector: (state) => state.visiblity!,
                        builder: (context, state) {
                          return ElevatedButton(
                              onPressed: () => context
                                  .read<UpdateFoodCubit>()
                                  .changeVisiblity(),
                              child: Text(state ? 'hide' : 'show'));
                        },
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Builder(
                          builder: (context) => ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<UpdateFoodCubit>().save(
                                      name.text,
                                      desc.text,
                                      price.text,
                                      points.text);
                                }
                              },
                              child: Text('save'))),
                    ],
                  ),
                  Expanded(
                    child: Flex(
                      direction: MediaQuery.of(context).size.width > 700
                          ? Axis.horizontal
                          : Axis.vertical,
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            Row(
                              children: [
                                const Text('Addtions'),
                                Builder(builder: (context) {
                                  return IconButton(
                                      onPressed: () => context
                                          .read<UpdateFoodCubit>()
                                          .addAddition(),
                                      icon: Icon(Icons.add));
                                })
                              ],
                            ),
                            Expanded(
                              child: BlocSelector<UpdateFoodCubit,
                                  UpdateFoodState, List>(
                                selector: (state) => state.addtions,
                                builder: (context, state) {
                                  return ListView.builder(
                                    controller: ScrollController(),
                                    itemCount: state.length,
                                    itemBuilder: (ctx, index) {
                                      GlobalKey<FormState> key = GlobalKey();
                                      return Form(
                                        key: key,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                cursorColor: AppColors.brown1,
                                                validator: isNotEmpty,
                                                controller: state[index]
                                                    ['name'],
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'name',
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors.brown2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Text(':'),
                                            Expanded(
                                              child: TextFormField(
                                                cursorColor: AppColors.brown1,
                                                controller: state[index]
                                                    ['price'],
                                                validator: validatePrice,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'\d|\.?')),
                                                ],
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'price',
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: AppColors.brown2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            state[index]['loading']
                                                ? const CircularProgressIndicator()
                                                : const SizedBox(),
                                            !state[index]['added']
                                                ? IconButton(
                                                    onPressed: () {
                                                      if (key.currentState!
                                                          .validate()) {
                                                        ctx
                                                            .read<
                                                                UpdateFoodCubit>()
                                                            .saveAddition(
                                                                index);
                                                      }
                                                    },
                                                    icon: const Icon(
                                                      Icons.done,
                                                      color: AppColors.brown2,
                                                    ))
                                                : const SizedBox(),
                                            IconButton(
                                                onPressed: () => ctx
                                                    .read<UpdateFoodCubit>()
                                                    .removeAddition(index),
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ))
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        )),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('Offer'),
                                  ElevatedButton(
                                    onPressed: () async {
                                      Map offer = await showDialog(
                                          context: context,
                                          builder: (_) =>
                                              OfferDialog(food: args.id));
                                      context
                                          .read<UpdateFoodCubit>()
                                          .setOffer(offer);
                                    },
                                    child: Text('set offer'),
                                  )
                                ],
                              ),
                              BlocSelector<UpdateFoodCubit, UpdateFoodState,
                                  Map?>(
                                selector: (state) => state.offer,
                                builder: (context, state) => state != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'type ${state['type'] == '1' ? 'Percent' : 'New Price'}'),
                                          Text(
                                            'value ${state['value']}${state['type'] == '1' ? '%' : ''}',
                                          ),
                                          Text(
                                              'end date ${dateFormat.format(DateTime.parse(state['end']))}'),
                                        ],
                                      )
                                    : const SizedBox(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocSelector<UpdateFoodCubit, UpdateFoodState, String>(
                      selector: (state) => state.error,
                      builder: (context, state) => Text(
                            state,
                            style: const TextStyle(color: Colors.red),
                          ))
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
