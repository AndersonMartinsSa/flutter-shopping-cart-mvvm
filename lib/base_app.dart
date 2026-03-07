import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/routing/app_router.dart';
import 'package:flutter_shopping_cart_mvvm/routing/routes.dart';

class BaseApp extends StatelessWidget {
  const BaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      initialRoute: Routes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
