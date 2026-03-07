import 'package:flutter/material.dart';
import 'package:flutter_shopping_cart_mvvm/domain/stories/cart_store.dart';

class CartIconButton extends StatelessWidget {
  final VoidCallback? onTap;

  const CartIconButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cart = CartStore.instance;

    return ListenableBuilder(
      listenable: cart,
      builder: (_, __) {
        final count = cart.products.length;

        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: onTap,
              ),

              if (count > 0)
                Positioned(
                  right: -3,
                  top: -3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      "$count",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
