import 'package:admin/firebase_options.dart';
import 'package:admin/ui/screens/foods.dart';
import 'package:admin/utilities/colors.dart';
import 'package:admin/utilities/notifications.dart';
import 'package:admin/utilities/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var fbMessages = FirebaseMessaging.onMessage.asBroadcastStream();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.subscribeToTopic('admin');
  FirebaseMessaging.instance.onTokenRefresh.listen(
    (event) async => await FirebaseMessaging.instance.subscribeToTopic('admin'),
  );
  await initNoitification();
  FirebaseMessaging.onBackgroundMessage(handleNotification);
  fbMessages.listen((event) => handleNotification(event).then((value) => null));
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Routes.orders,
      onGenerateRoute: Routes.generator,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            actionsIconTheme: IconThemeData(color: AppColors.brown4),
          ),
          fontFamily: 'Montserrat Alternates',
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.brown4))),
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all(AppColors.brown4))),
          progressIndicatorTheme:
              const ProgressIndicatorThemeData(color: AppColors.brown2),
          buttonTheme:
              ButtonThemeData(splashColor: AppColors.brown1.withOpacity(.4)),
          primaryColor: AppColors.brown2,
          splashColor: AppColors.brown1,
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: AppColors.brown1.withOpacity(.5))),
    );
  }
}
