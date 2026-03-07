import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/routing/routes.dart';
import 'package:flutter_shopping_cart_mvvm/ui/cart/cart_page.dart';
import 'package:flutter_shopping_cart_mvvm/ui/home/home_page.dart';
import 'package:flutter_shopping_cart_mvvm/ui/order_confirmation/order_confirmation_page.dart';

abstract class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case Routes.cart:
        return MaterialPageRoute(builder: (_) => const CartPage());
      case Routes.orderConfirmation:
        return MaterialPageRoute(builder: (_) => const OrderConfirmationPage());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Rota não encontrada"))),
        );
    }
  }
}
