import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/exceptions/product_fetch_exception.dart';
import 'package:flutter_shopping_cart_mvvm/routing/routes.dart';
import 'package:flutter_shopping_cart_mvvm/ui/home/home_viewmodel.dart';
import 'package:flutter_shopping_cart_mvvm/ui/widgets/cart_icon_button.dart';
import 'package:flutter_shopping_cart_mvvm/ui/widgets/product_card.dart';
import 'package:flutter_shopping_cart_mvvm/ui/widgets/resut_builder.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeViewModel viewModel;

  @override
  void initState() {
    viewModel = context.read();
    viewModel.getProducts();
    super.initState();
  }

  void _tryAgainOnTap() {
    viewModel.getProducts();
  }

  Future<void> _onRefresh() async {
    viewModel.getProducts();
  }

  void _cartIconOnTap() {
    Routes.goToCard(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Store"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [CartIconButton(onTap: _cartIconOnTap)],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ResultBuilder<List<ProductEntity>>(
          command: viewModel.productsCmd,
          onSuccess: (context, products) {
            return successWidget(products ?? []);
          },
          onLoading: (context) => loadingWidget(),
          onError: (context, error) {
            String message = "Unable to load products.";
            if (error is ProductFetchException) {
              message = error.message;
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(message),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _tryAgainOnTap,
                    child: Text("Try again"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget successWidget(List<ProductEntity> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }

  Widget loadingWidget() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        return ProductCard.loading();
      },
    );
  }
}
