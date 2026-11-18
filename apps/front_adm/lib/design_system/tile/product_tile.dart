import 'package:design_system/design_system.dart' as design_system;
import 'package:flutter/material.dart';

import '../../features/products/domain/model/product_model.dart';

class ProductTile extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductTile({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => design_system.ProductTile(
        name: product.name,
        category: product.category,
        price: product.price,
        imageUrl: product.imageUrl,
        onTap: onTap,
      );
}
