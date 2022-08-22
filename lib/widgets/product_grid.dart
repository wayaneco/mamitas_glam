import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';

import '../providers/product_provider.dart';

import '../models/product_model.dart';

class ProductGrid extends StatelessWidget {
  final bool isFavorited;

  const ProductGrid(this.isFavorited);

  @override
  Widget build(BuildContext context) {
    ProductProvider productsData = Provider.of<ProductProvider>(context);

    List<ProductModel> products =
        isFavorited ? productsData.favoriteProducts : productsData.products;

    return RefreshIndicator(
      onRefresh: () async {
        await productsData.fetchProducts();
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (_, i) => ProductItem(products[i]),
        itemCount: products.length,
      ),
    );
  }
}
