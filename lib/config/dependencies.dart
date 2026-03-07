import 'package:dio/dio.dart';
import 'package:flutter_shopping_cart_mvvm/data/repositories/product_repository_impl.dart';
import 'package:flutter_shopping_cart_mvvm/data/service/product_service.dart';
import 'package:flutter_shopping_cart_mvvm/domain/repositories/product_repository.dart';
import 'package:flutter_shopping_cart_mvvm/ui/home/home_viewmodel.dart';
import 'package:flutter_shopping_cart_mvvm/utils/environments.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get _viewmodels {
  return [
    ChangeNotifierProvider(
      create: (context) => HomeViewModel(productRepository: context.read()),
    ),
  ];
}

List<SingleChildWidget> get _services {
  return [
    Provider(
      create: (context) =>
          ProductServiceImpl(dio: context.read()) as ProductService,
    ),
  ];
}

List<SingleChildWidget> get _repositories {
  return [
    Provider(
      create: (context) =>
          ProductRepositoryImpl(productService: context.read())
              as ProductRepository,
    ),
  ];
}

List<SingleChildWidget> get providers {
  return [
    Provider(
      create: (context) => Dio(BaseOptions(baseUrl: Environments.fakestoreapi)),
    ),
    ..._services,
    ..._repositories,
    ..._viewmodels,
  ];
}
