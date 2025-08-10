import 'package:flutter/material.dart';
import 'package:score_tracker/app/routes.dart';
import 'package:score_tracker/app/theme/app_theme.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doti Score tracker',
      theme: buildAppTheme(),
      initialRoute: Routes.splash,
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
