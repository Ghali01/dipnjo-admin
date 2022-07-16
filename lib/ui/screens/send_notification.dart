import 'package:admin/logic/controllers/send_notification.dart';
import 'package:admin/logic/models/send_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:admin/logic/models/notification.dart';
import 'package:admin/ui/widgets/appbar.dart';
import 'package:admin/ui/widgets/drawer.dart';
import 'package:admin/utilities/colors.dart';

class SendNotificationArgs {
  TargetType type;
  int? from;
  int? to;
  int? id;
  SendNotificationArgs({
    required this.type,
    this.from,
    this.to,
    this.id,
  });
}

class SendNotificationPage extends StatelessWidget {
  SendNotificationArgs args;

  SendNotificationPage({Key? key, required this.args}) : super(key: key);
  TextEditingController title = TextEditingController(),
      body = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  String? isNotEmpty(String? text) {
    if (text == null || text.isEmpty) {
      return 'this field is required';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SendNotificationCubit(),
      child: BlocListener<SendNotificationCubit, SendNotificationState>(
        listenWhen: (previous, current) => current.done,
        listener: (context, state) => Navigator.of(context).pop(),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, 55),
            child: AppAppBar(title: 'Notification'),
          ),
          drawer: AppDrawer(),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                TextFormField(
                  controller: title,
                  validator: isNotEmpty,
                  cursorColor: AppColors.brown2,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.brown4),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.brown4),
                    ),
                  ),
                ),
                TextFormField(
                  controller: body,
                  validator: isNotEmpty,
                  cursorColor: AppColors.brown2,
                  minLines: 4,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: 'Body',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.brown4),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.brown4),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Builder(builder: (context) {
                      return ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {}
                          context.read<SendNotificationCubit>().send(
                              args.type,
                              title.text,
                              body.text,
                              args.id,
                              args.from,
                              args.to);
                        },
                        child: const Text('Send'),
                      );
                    }),
                    const SizedBox(
                      width: 8,
                    ),
                    BlocSelector<SendNotificationCubit, SendNotificationState,
                        bool>(
                      selector: (state) => state.loading,
                      builder: (context, state) {
                        return state
                            ? const CircularProgressIndicator()
                            : const SizedBox();
                      },
                    )
                  ],
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
