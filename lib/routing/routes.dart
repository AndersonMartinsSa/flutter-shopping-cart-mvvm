import 'package:flutter/material.dart';

abstract class Routes {
  static const String home = "/home";
  static const String cart = "/cart";
  static const String orderConfirmation = "/orderConfirmation";

  static void goToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(home, (route) => false);
  }

  static void goToCard(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.cart);
  }

  static void goToOrderConfirmation(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(orderConfirmation, (route) => false);
  }
}
