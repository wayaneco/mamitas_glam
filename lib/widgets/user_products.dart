import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_products.dart';

import '../models/product_model.dart';
import '../providers/product_provider.dart';

class UserProductItem extends StatelessWidget {
  final loaderOverlay;

  const UserProductItem(this.loaderOverlay);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductModel>(context);
    return ListTile(
      leading: Image(
        repeat: ImageRepeat.noRepeat,
        fit: BoxFit.cover,
        width: 100,
        alignment: Alignment.center,
        image: NetworkImage(product.imageUrl),
        errorBuilder: (ctx, obj, trace) => Image.asset(
          'assets/images/default.jpg',
          alignment: Alignment.center,
          fit: BoxFit.cover,
          width: 100,
          repeat: ImageRepeat.repeat,
        ),
      ),
      title: Text(product.title),
      subtitle: Text(product.description),
      isThreeLine: true,
      trailing: Consumer<ProductProvider>(
        builder: (_, productProvider, child) => SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                padding: const EdgeInsets.all(0),
                splashRadius: 1,
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName,
                      arguments: product.id);
                },
              ),
              IconButton(
                padding: const EdgeInsets.all(0),
                splashRadius: 1,
                icon: const Icon(Icons.delete),
                onPressed: () {
                  productProvider.removeProduct(
                    product.id,
                    loaderOverlay,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
