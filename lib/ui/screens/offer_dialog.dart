import 'package:admin/logic/controllers/offer_dialog.dart';
import 'package:admin/logic/models/offer_dialog.dart';
import 'package:admin/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfferDialog extends StatelessWidget {
  final int food;
  OfferDialog({Key? key, required this.food}) : super(key: key);
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController value = TextEditingController(),
      date = TextEditingController(text: '2022-6-17 23:00');
  String? validateDate(String? text) {
    if (text == null || text.isEmpty) {
      return 'this field should not be empty';
    } else {
      RegExp regEx = RegExp(r'^\d{4}-\d{1,2}-\d{1,2} \d{1,2}:\d{1,2}$');
      if (!regEx.hasMatch(text)) {
        return 'enter valid date';
      }
    }
  }

  String? validatePrice(String? text) {
    if (text == null || text.isEmpty) {
      return 'this field should not be empty';
    } else {
      RegExp regex = RegExp(r'(^\d+$)|(^\d+\.{1}\d+$)');
      if (!regex.hasMatch(text)) {
        return 'enter valid value';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OfferDialogCubit(),
      child: BlocListener<OfferDialogCubit, OfferDialogState>(
        listenWhen: (previous, current) => current.done,
        listener: (context, state) => Navigator.of(context).pop(state.offer),
        child: Dialog(
          child: SizedBox(
            width: 200,
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Builder(
                      builder: (context) {
                        return DropdownButtonFormField<String>(
                            value: '1',
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.brown2,
                                ),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: '1',
                                child: Text("percent"),
                              ),
                              DropdownMenuItem(
                                value: '2',
                                child: Text("new price"),
                              ),
                            ],
                            onChanged: (v) =>
                                context.read<OfferDialogCubit>().setType(v!));
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      cursorColor: AppColors.brown1,
                      controller: value,
                      validator: validatePrice,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'\d|\.?'))
                      ],
                      decoration: const InputDecoration(
                        hintText: "Offer Value",
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
                      controller: date,
                      validator: validateDate,
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'\d|-|:| '))
                      ],
                      decoration: const InputDecoration(
                        hintText: 'yyyy-mm-dd hh:MM',
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
                    Builder(builder: (context) {
                      return ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context
                                  .read<OfferDialogCubit>()
                                  .save(food, value.text, date.text);
                            }
                          },
                          child: Text('save'));
                    }),
                    BlocSelector<OfferDialogCubit, OfferDialogState, String>(
                      selector: (state) => state.error,
                      builder: (context, state) => Text(
                        state,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    BlocSelector<OfferDialogCubit, OfferDialogState, bool>(
                      selector: (state) => state.loading,
                      builder: (context, state) => state
                          ? const CircularProgressIndicator()
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
