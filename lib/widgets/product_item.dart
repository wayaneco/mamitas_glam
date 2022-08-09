import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shop_app/providers/product_provider.dart';

import '../screens/single_product_screen.dart';

import '../models/product_model.dart';
import '../providers/cart_item_provider.dart';

class ProductItem extends StatelessWidget {
  const ProductItem();

  void handleOnTap(ctx) {
    Navigator.pushNamed(ctx, SingleProductScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final ProductModel product =
        Provider.of<ProductModel>(context, listen: false);

    final productProvider = Provider.of<ProductProvider>(context);
    Function addCartItem =
        Provider.of<CartProvider>(context, listen: false).addCartItem;

    return Card(
      child: GridTile(
        footer: GridTileBar(
          leading: GestureDetector(
            onTap: () async {
              context.loaderOverlay.show();
              product.isFavorite
                  ? await productProvider.removeToFavorites(product.id)
                  : await productProvider.addToFavorites(product.id);
              context.loaderOverlay.hide();
            },
            child: Consumer<ProductModel>(
              builder: (ctx, _, child) => Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_outline,
              ),
            ),
          ),
          trailing: GestureDetector(
            onTap: () async {
              await addCartItem(
                product.id,
                product.title,
                product.price,
                product.imageUrl,
                context.loaderOverlay,
              );
            },
            child: const Icon(
              Icons.shopping_bag_outlined,
            ),
          ),
          backgroundColor: Colors.black,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
        child: GestureDetector(
          onTap: () => handleOnTap(context),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (ctx, obj, trace) => Image.asset(
              'assets/images/default.jpg',
              alignment: Alignment.bottomCenter,
              fit: BoxFit.cover,
              repeat: ImageRepeat.repeat,
            ),
          ),
        ),
      ),
    );
  }
}
