import 'package:flutter_shopping_cart_mvvm/ui/home/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get _viewmodels {
  return [ChangeNotifierProvider(create: (context) => HomeViewModel())];
}

List<SingleChildWidget> get providers {
  return [
    ..._viewmodels,
  ];
}
