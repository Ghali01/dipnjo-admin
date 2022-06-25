import 'dart:io';

import 'package:admin/logic/controllers/add_food.dart';
import 'package:admin/logic/models/add_food.dart';
import 'package:admin/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddFoodArgs {
  int category;
  AddFoodArgs(this.category);
}

class AddFoodPage extends StatelessWidget {
  AddFoodArgs args;
  AddFoodPage({Key? key, required this.args}) : super(key: key);
  TextEditingController name = TextEditingController(),
      price = TextEditingController(),
      points = TextEditingController(),
      desc = TextEditingController();
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
      create: (context) => AddFoodCubit(),
      child: BlocListener<AddFoodCubit, AddFoodState>(
        listenWhen: (previous, current) => current.done,
        listener: (context, state) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.foods, (route) => route.settings.name == Routes.foods);
        },
        child: Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: name,
                    validator: isNotEmpty,
                    decoration: InputDecoration(hintText: "Name"),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: price,
                    validator: validatePrice,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'\d|\.?')),
                    ],
                    decoration: InputDecoration(hintText: "Price"),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: points,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(hintText: "Repalce Point"),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: desc,
                    minLines: 3,
                    maxLines: 7,
                    decoration: InputDecoration(hintText: 'Description'),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Builder(
                          builder: (context) => ElevatedButton(
                            onPressed: () =>
                                context.read<AddFoodCubit>().setImage(),
                            child: Text('select image'),
                          ),
                        ),
                        BlocBuilder<AddFoodCubit, AddFoodState>(
                          buildWhen: (previous, current) =>
                              previous.imageError != current.imageError ||
                              previous.image != current.image,
                          builder: (context, state) {
                            return Text(state.image != null
                                ? state.image!
                                    .split(Platform.isWindows ? '\\' : '/')
                                    .last
                                : state.imageError ?? "");
                          },
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Text('Addtions'),
                      Builder(builder: (context) {
                        return IconButton(
                            onPressed: () =>
                                context.read<AddFoodCubit>().addAddition(),
                            icon: Icon(Icons.add));
                      })
                    ],
                  ),
                  Expanded(
                    child: BlocSelector<AddFoodCubit, AddFoodState, List>(
                      selector: (state) => state.addtions,
                      builder: (context, state) {
                        return ListView.builder(
                          controller: ScrollController(),
                          itemCount: state.length,
                          itemBuilder: (ctx, index) => Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  validator: isNotEmpty,
                                  controller: state[index]['name'],
                                  decoration: InputDecoration(hintText: 'name'),
                                ),
                              ),
                              const Text(':'),
                              Expanded(
                                child: TextFormField(
                                  controller: state[index]['price'],
                                  validator: validatePrice,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'\d|\.?')),
                                  ],
                                  decoration:
                                      InputDecoration(hintText: 'price'),
                                ),
                              ),
                              IconButton(
                                  onPressed: () => ctx
                                      .read<AddFoodCubit>()
                                      .removeAddition(index),
                                  icon: const Icon(Icons.delete))
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Builder(
                          builder: (context) => ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context.read<AddFoodCubit>().save(
                                      name.text,
                                      args.category,
                                      desc.text,
                                      price.text,
                                      points.text);
                                }
                              },
                              child: Text('save'))),
                      const SizedBox(
                        width: 8,
                      ),
                      BlocSelector<AddFoodCubit, AddFoodState, bool>(
                        selector: (state) => state.loading,
                        builder: (context, state) => state
                            ? const CircularProgressIndicator()
                            : const SizedBox(),
                      )
                    ],
                  ),
                  BlocSelector<AddFoodCubit, AddFoodState, String>(
                      selector: (state) => state.error,
                      builder: (context, state) => Text(
                            state,
                            style: const TextStyle(color: Colors.red),
                          ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
