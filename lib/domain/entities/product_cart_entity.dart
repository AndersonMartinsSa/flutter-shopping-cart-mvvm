import 'package:flutter_shopping_cart_mvvm/domain/entities/product_entity.dart';

class ProductCartEntity {
  final ProductEntity product;
  int quantity;

  ProductCartEntity({
    required this.product,
    this.quantity = 1,
  });

  ProductCartEntity copyWith({
    ProductEntity? product,
    int? quantity,
  }) {
    return ProductCartEntity(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductCartEntity && other.product == product;
  }

  @override
  int get hashCode => product.hashCode;
}
