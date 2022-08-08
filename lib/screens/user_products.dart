import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../screens/edit_products.dart';
import '../widgets/user_products.dart';
import '../widgets/drawer.dart';

import '../providers/product_provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-product';

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).products;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: products.isEmpty
          ? const Center(
              child: Text('No data'),
            )
          : LoaderOverlay(
              child: ListView.builder(
                itemBuilder: (_, i) => ChangeNotifierProvider.value(
                  value: products[i],
                  child: UserProductItem(context.loaderOverlay),
                ),
                itemCount: products.length,
              ),
            ),
    );
  }
}
