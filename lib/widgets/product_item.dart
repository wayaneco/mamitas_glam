import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shop_app/providers/product_provider.dart';

import '../screens/single_product_screen.dart';

import '../models/product_model.dart';
import '../providers/cart_item_provider.dart';

class ProductItem extends StatefulWidget {
  ProductModel product;
  ProductItem(this.product);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  Uint8List? bytes;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    (() async {
      http.Response response = await http.get(
        Uri.parse(widget.product.imageUrl),
      );
      final convertedImage = const Base64Encoder().convert(response.bodyBytes);
      setState(() {
        bytes = const Base64Decoder().convert(convertedImage);
        loading = false;
      });
    }());
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Card(
      child: GridTile(
        footer: GridTileBar(
          leading: GestureDetector(
            onTap: () async {
              context.loaderOverlay.show();
              widget.product.isFavorite
                  ? await productProvider.removeToFavorites(widget.product.id)
                  : await productProvider.addToFavorites(widget.product.id);
              context.loaderOverlay.hide();
            },
            child: Icon(
              widget.product.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_outline,
            ),
          ),
          trailing: GestureDetector(
            onTap: () async {
              await cartProvider.addCartItem(
                widget.product.id,
                widget.product.title,
                widget.product.price,
                widget.product.imageUrl,
                context.loaderOverlay,
              );
            },
            child: const Icon(
              Icons.shopping_bag_outlined,
            ),
          ),
          backgroundColor: Colors.black,
          title: Text(
            widget.product.title,
            textAlign: TextAlign.center,
          ),
        ),
        child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, SingleProductScreen.routeName,
                  arguments: {
                    'image': bytes,
                    'id': widget.product.id,
                  });
            },
            child: Hero(
              tag: widget.product.id,
              child: loading == false
                  ? Image.memory(
                      bytes as Uint8List,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      errorBuilder: (ctx, obj, trace) => Image.asset(
                        'assets/images/default.jpg',
                        alignment: Alignment.bottomCenter,
                        fit: BoxFit.cover,
                        repeat: ImageRepeat.repeat,
                      ),
                    )
                  : Image.asset(
                      'assets/images/default.jpg',
                      alignment: Alignment.bottomCenter,
                      fit: BoxFit.cover,
                      repeat: ImageRepeat.repeat,
                    ),
            )),
      ),
    );
  }
}
