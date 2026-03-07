import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/app_theme.dart';
import 'package:flutter_shopping_cart_mvvm/routing/app_router.dart';
import 'package:flutter_shopping_cart_mvvm/routing/routes.dart';

class BaseApp extends StatelessWidget {
  const BaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.light(),
      initialRoute: Routes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
