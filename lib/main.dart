import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/base_app.dart';
import 'package:flutter_shopping_cart_mvvm/config/dependencies.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: providers, child: const BaseApp()));
}
