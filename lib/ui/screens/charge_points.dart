import 'package:admin/logic/controllers/charge_points.dart';
import 'package:admin/logic/models/charge_points.dart';
import 'package:admin/ui/widgets/appbar.dart';
import 'package:admin/ui/widgets/drawer.dart';
import 'package:admin/utilities/colors.dart';
import 'package:admin/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChargePointsPage extends StatelessWidget {
  ChargePointsPage({Key? key}) : super(key: key);
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController controller = TextEditingController();
  String? isNotEmpty(String? text) {
    if (text == null || text.isEmpty) {
      return 'this field is required';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChargePointsCubit(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 55),
          child: AppAppBar(title: 'Scan QR'),
        ),
        drawer: AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: controller,
                  validator: isNotEmpty,
                  cursorColor: AppColors.brown1,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: "Points Count",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.brown4),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.brown4),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                BlocBuilder<ChargePointsCubit, ChargePointState>(
                  builder: (context, state) {
                    return state.loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                var token = await Navigator.of(context)
                                    .pushNamed(Routes.qrScan);
                                if (token != null) {
                                  context
                                      .read<ChargePointsCubit>()
                                      .setToken(token as String);
                                  context
                                      .read<ChargePointsCubit>()
                                      .charge(int.parse(controller.text));
                                }
                              }
                            },
                            child: const Text('Scan'));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
