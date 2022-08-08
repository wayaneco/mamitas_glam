import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../widgets/drawer.dart';
import '../providers/cart_item_provider.dart';
import '../screens/cart_item_screen.dart';
import '../widgets/product_grid.dart';

enum FilterOptions { all, favorites }

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products';

  const ProductsOverviewScreen();

  @override
  ProductsOverviewScreenState createState() => ProductsOverviewScreenState();
}

class ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  FilterOptions options = FilterOptions.all;
  bool _initLoading = false;

  void redirectToCartPage(ctx) {
    Navigator.of(ctx).pushNamed(CartItemScreen.routeName);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initLoading == false) {
      Provider.of<ProductProvider>(context).fetchProducts(initFetch: true);
      Provider.of<CartProvider>(context).fetchCartItems();

      setState(() {
        _initLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = Provider.of<ProductProvider>(context).getLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopify"),
        actions: [
          GestureDetector(
            onTap: () => redirectToCartPage(context),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.shopping_cart_outlined),
                const SizedBox(
                  width: 8.0,
                ),
                Positioned(
                  right: 4,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.all(2.0),
                    constraints: const BoxConstraints(
                      minHeight: 15,
                      minWidth: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.orange,
                    ),
                    child: Consumer<CartProvider>(
                      builder: (_, item, child) => AnimatedSwitcher(
                        duration: const Duration(
                          seconds: 1,
                        ),
                        switchInCurve: Curves.linearToEaseOut,
                        child: Text(
                          item.getTotalItems.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 10.0),
                          key: ValueKey(
                            item.getTotalItems.toString(),
                          ),
                        ),
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(
                          scale: animation,
                          child: child,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          PopupMenuButton(
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: FilterOptions.all,
                child: Text('All'),
              ),
              PopupMenuItem(
                value: FilterOptions.favorites,
                child: Text('Favorites'),
              )
            ],
            initialValue: options,
            onSelected: (FilterOptions selectedValue) => setState(() {
              options = selectedValue;
            }),
            child: const Icon(Icons.more_vert),
          ),
        ],
        automaticallyImplyLeading: true,
      ),
      drawer: const AppDrawer(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : LoaderOverlay(
              child: SafeArea(
                child: ProductGrid(options == FilterOptions.favorites),
              ),
            ),
    );
  }
}
