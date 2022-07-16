import 'dart:io';

import 'package:admin/logic/controllers/add_advertise.dart';
import 'package:admin/logic/controllers/advertise.dart';
import 'package:admin/logic/models/add_advertise.dart';
import 'package:admin/logic/models/advertise.dart';
import 'package:admin/ui/widgets/appbar.dart';
import 'package:admin/ui/widgets/drawer.dart';
import 'package:admin/utilities/colors.dart';
import 'package:admin/utilities/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdvertisePage extends StatelessWidget {
  const AdvertisePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdvertiseCubit(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 55),
          child: AppAppBar(title: 'Ads'),
        ),
        drawer: AppDrawer(),
        body: BlocBuilder<AdvertiseCubit, AdvertiseState>(
          builder: (context, state) {
            if (!state.loaded) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: state.items!.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: AppColors.white1,
                          borderRadius: BorderRadius.circular(10)),
                      child: SizedBox.square(
                        dimension: 92,
                        child: Image.network(
                          Server.getAbsoluteUrl(
                              state.items![index]['imageUrl']),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.items![index]['title'],
                            style: const TextStyle(
                              color: AppColors.brown1,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            state.items![index]['subTitle'],
                            style: const TextStyle(
                              color: AppColors.brown2,
                              fontSize: 19,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: state.items![index]['loading'] == true
                          ? const CircularProgressIndicator()
                          : IconButton(
                              onPressed: () => context
                                  .read<AdvertiseCubit>()
                                  .delete(state.items![index]['id']),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                    )
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () async {
                String? raw = await showDialog(
                    context: context, builder: (_) => _AddDialog());
                if (raw != null) {
                  context.read<AdvertiseCubit>().add(raw);
                }
              },
              backgroundColor: AppColors.brown4,
              child: Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}

class _AddDialog extends StatelessWidget {
  _AddDialog({Key? key}) : super(key: key);

  TextEditingController title = TextEditingController(),
      subtitle = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  String? isNotEmpty(String? text) {
    if (text == null || text.isEmpty) {
      return 'this field is required';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddAdvertiseCubit(),
      child: Dialog(
        child: BlocListener<AddAdvertiseCubit, AddAdvertiseState>(
          listenWhen: (previous, current) => current.done,
          listener: (context, state) {
            Navigator.of(context).pop(state.rawData);
          },
          child: BlocSelector<AddAdvertiseCubit, AddAdvertiseState, bool>(
            selector: (state) => state.loaded,
            builder: (context, state) {
              if (!state) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: title,
                        cursorColor: AppColors.brown2,
                        validator: isNotEmpty,
                        decoration: const InputDecoration(
                          labelText: 'title',
                          labelStyle: TextStyle(color: AppColors.brown4),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.brown4,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.brown4,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: subtitle,
                        cursorColor: AppColors.brown2,
                        maxLines: 2,
                        minLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'subtitle',
                          labelStyle: TextStyle(color: AppColors.brown4),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.brown4,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.brown4,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      BlocBuilder<AddAdvertiseCubit, AddAdvertiseState>(
                        buildWhen: (previous, current) =>
                            previous.food != current.food,
                        builder: (context, state) {
                          return DropdownButtonFormField<int>(
                            value: state.food,
                            validator: (v) {
                              if (v == null) {
                                return 'this field is required';
                              }
                            },
                            items: state.foods!
                                .map((e) => DropdownMenuItem<int>(
                                      value: e['id'],
                                      child: Text(e['name']),
                                    ))
                                .toList(),
                            onChanged: (v) =>
                                context.read<AddAdvertiseCubit>().setFood(v!),
                            decoration: const InputDecoration(
                              labelText: 'food',
                              labelStyle: TextStyle(color: AppColors.brown4),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.brown4,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.brown4,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Builder(
                          builder: (context) => ElevatedButton(
                              onPressed: () => context
                                  .read<AddAdvertiseCubit>()
                                  .sleectImage(),
                              child: const Text('Select Image'))),
                      BlocSelector<AddAdvertiseCubit, AddAdvertiseState,
                          String?>(
                        selector: (state) => state.image,
                        builder: (context, state) => Text(state != null
                            ? state.split(Platform.isWindows ? '\\' : '/').last
                            : ''),
                      ),
                      BlocSelector<AddAdvertiseCubit, AddAdvertiseState,
                          String?>(
                        selector: (state) => state.image,
                        builder: (context, state) {
                          return state != null
                              ? ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      context
                                          .read<AddAdvertiseCubit>()
                                          .save(title.text, subtitle.text);
                                    }
                                  },
                                  child: const Text('Save'))
                              : const SizedBox();
                        },
                      ),
                      BlocSelector<AddAdvertiseCubit, AddAdvertiseState,
                          String>(
                        selector: (state) => state.error,
                        builder: (context, state) {
                          return Text(
                            state,
                            style: const TextStyle(color: Colors.red),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      BlocSelector<AddAdvertiseCubit, AddAdvertiseState, bool>(
                        selector: (state) => state.loading,
                        builder: (context, state) {
                          return state
                              ? const CircularProgressIndicator()
                              : const SizedBox();
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
