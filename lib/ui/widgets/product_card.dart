import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_cart_entity.dart';
import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';
import 'package:flutter_shopping_cart_mvvm/ui/home/home_viewmodel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity? product;
  final bool isLoading;

  const ProductCard({super.key, required this.product}) : isLoading = false;

  const ProductCard.loading({super.key}) : product = null, isLoading = true;

  @override
  Widget build(BuildContext context) {
    onCartItemLimitExceeded(String message) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }

    if (isLoading) {
      return _buildSkeleton();
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: product!.image,
                  fit: BoxFit.contain,
                  progressIndicatorBuilder: (context, url, progress) {
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              product!.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              product!.price.formattedValue,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: Consumer<HomeViewModel>(
              builder: (context, viewModel, child) {
                final ProductCartEntity? productInCart = viewModel
                    .getProductInCart(product!);

                return productInCart != null
                    ? _buildQuantitySelector(
                        context: context,
                        product: product!,
                        quantity: productInCart.quantity,
                        onAddProduct: (product) => viewModel.addProduct(
                          product: product,
                          onCartItemLimitExceeded: onCartItemLimitExceeded,
                        ),
                        onRemoveProduct: (product) =>
                            viewModel.removeProduct(product),
                      )
                    : ElevatedButton(
                        onPressed: () => viewModel.addProduct(
                          product: product,
                          onCartItemLimitExceeded: onCartItemLimitExceeded,
                        ),
                        child: const Text("Add to cart"),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector({
    required BuildContext context,
    required ProductEntity product,
    required int quantity,
    required Function(ProductEntity) onRemoveProduct,
    required Function(ProductEntity) onAddProduct,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () => onRemoveProduct(product),
        ),
        Text(
          quantity.toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => onAddProduct(product),
        ),
      ],
    );
  }

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 14,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Container(
              height: 12,
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Container(
              height: 16,
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: Colors.white,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
