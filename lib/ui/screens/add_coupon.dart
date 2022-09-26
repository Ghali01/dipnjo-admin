import 'package:admin/logic/controllers/add_coupon.dart';
import 'package:admin/logic/controllers/offer_dialog.dart';
import 'package:admin/logic/models/add_coupon.dart';
import 'package:admin/logic/models/offer_dialog.dart';
import 'package:admin/utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCouponDialog extends StatelessWidget {
  AddCouponDialog({Key? key}) : super(key: key);
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController value = TextEditingController(),
      keyC = TextEditingController();
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
        return 'enter valid value';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCouponCubit(),
      child: BlocListener<AddCouponCubit, AddCouponState>(
        listenWhen: (previous, current) => current.done,
        listener: (context, state) => Navigator.of(context).pop(state.data),
        child: Dialog(
          child: SizedBox(
            width: 200,
            height: 330,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Builder(
                      builder: (context) {
                        return DropdownButtonFormField<String>(
                            value: 'p',
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.brown2,
                                ),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'p',
                                child: Text("percent"),
                              ),
                              DropdownMenuItem(
                                value: 'c',
                                child: Text("amount"),
                              ),
                            ],
                            onChanged: (v) =>
                                context.read<AddCouponCubit>().setType(v!));
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      cursorColor: AppColors.brown1,
                      controller: keyC,
                      decoration: const InputDecoration(
                        hintText: "Key",
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
                      controller: value,
                      validator: validatePrice,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        hintText: "Coupon Value",
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
                                  .read<AddCouponCubit>()
                                  .save(keyC.text, int.parse(value.text));
                            }
                          },
                          child: Text('save'));
                    }),
                    BlocSelector<AddCouponCubit, AddCouponState, String>(
                      selector: (state) => state.error,
                      builder: (context, state) => Text(
                        state,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    BlocSelector<AddCouponCubit, AddCouponState, bool>(
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
