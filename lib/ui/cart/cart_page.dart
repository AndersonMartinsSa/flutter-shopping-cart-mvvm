import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_cart_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/exceptions/cart_item_limit_exceeded_exception.dart';
import 'package:flutter_shopping_cart_mvvm/domain/exceptions/checkout_exception.dart';
import 'package:flutter_shopping_cart_mvvm/domain/stories/cart_store.dart';
import 'package:flutter_shopping_cart_mvvm/routing/routes.dart';
import 'package:flutter_shopping_cart_mvvm/ui/cart/cart_viewmodel.dart';
import 'package:flutter_shopping_cart_mvvm/ui/widgets/resut_builder.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late final CartViewModel viewModel;

  @override
  void initState() {
    viewModel = context.read();
    configListiners();
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  void configListiners() {
    viewModel.checkoutCmd.addListener(() {
      if (viewModel.checkoutCmd.completed) {
        Routes.goToOrderConfirmation(context);
        return;
      }

      if (viewModel.checkoutCmd.error) {
        String messageError = "Checkout Failed";
        if (viewModel.checkoutCmd.result is CheckoutException) {
          messageError =
              (viewModel.checkoutCmd.result as CheckoutException).message;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(messageError)));
        return;
      }
    });
  }

  void _addProduct(ProductEntity product) {
    if (viewModel.checkoutCmd.isRunning) {
      return;
    }
    try {
      viewModel.cartStore.add(product);
    } on CartItemLimitExceededException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  void _removeProduct(ProductEntity product) {
    if (viewModel.checkoutCmd.isRunning) {
      return;
    }
    if (viewModel.cartStore.isLastProduct(product)) {
      _removeAllProducts(product);
      return;
    }

    viewModel.cartStore.remove(product);
  }

  void _checkout() {
    if (viewModel.checkoutCmd.isRunning) {
      return;
    }
    viewModel.checkoutCmd.execute();
  }

  void _removeAllProducts(ProductEntity product) {
    if (viewModel.checkoutCmd.isRunning) {
      return;
    }
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Remove Item",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "Are you sure you want to remove this item from your cart?",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        viewModel.cartStore.removeAllOfProduct(product);
                        Navigator.pop(context);
                      },
                      child: const Text("Remove"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Consumer<CartStore>(
        builder: (context, cartStore, child) {
          if (cartStore.products.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text('Your cart is empty.'),
                ],
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartStore.products.length,
                  itemBuilder: (context, index) {
                    final ProductCartEntity cartItem =
                        cartStore.products[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Image.network(
                              cartItem.product.image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItem.product.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(cartItem.product.price.formattedValue),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle),
                                  onPressed: () =>
                                      _removeProduct(cartItem.product),
                                ),
                                Text('${cartItem.quantity}'),
                                IconButton(
                                  icon: const Icon(Icons.add_circle),
                                  onPressed: () =>
                                      _addProduct(cartItem.product),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      _removeAllProducts(cartItem.product),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sub total:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          cartStore.totalPrice.formattedValue,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Shipping:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          cartStore.shipping.formattedValue,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Price:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          cartStore.totalCart.formattedValue,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _checkout,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: ResultBuilder(
                          command: viewModel.checkoutCmd,
                          onSuccess: (context, value) {
                            return const Text(
                              'Proceed to Checkout',
                              style: TextStyle(fontSize: 18),
                            );
                          },
                          onLoading: (context) => SizedBox(
                            height: 16,
                            width: 16,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          onEmpty: (context) => const Text(
                            'Proceed to Checkout',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
