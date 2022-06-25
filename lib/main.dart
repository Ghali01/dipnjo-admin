import 'package:admin/ui/screens/foods.dart';
import 'package:admin/utilities/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Routes.foods,
      onGenerateRoute: Routes.generator,
    );
  }
}
