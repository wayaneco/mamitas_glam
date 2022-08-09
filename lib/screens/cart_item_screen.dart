import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:toast/toast.dart';

import '../providers/cart_item_provider.dart';
import '../providers/orders_provider.dart';

import '../widgets/drawer.dart';
import '../widgets/cart_item.dart';

class CartItemScreen extends StatelessWidget {
  static const routeName = '/cart-items';

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    final cartData = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        maintainBottomViewPadding: false,
        child: cartData.getCartItems.isEmpty
            ? SizedBox(
                width: double.infinity,
                child: Flex(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  direction: Axis.vertical,
                  children: [
                    const Text('Ohh nooo!! Your cart is empty'),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                          ProductsOverviewScreen.routeName,
                        );
                      },
                      child: const Text('SHOP PRODUCTS'),
                    )
                  ],
                ),
              )
            : LoaderOverlay(
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(10.0),
                        itemCount: cartData.getCartItems.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 10,
                          mainAxisExtent: 100,
                        ),
                        itemBuilder: (_, index) => ChangeNotifierProvider.value(
                          value: cartData.getCartItems[index],
                          child: CartItem(),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.2),
                            offset: Offset(0, -1),
                            spreadRadius: 2.0,
                            blurRadius: 10.0,
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TOTAL',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Chip(
                            label: Text(
                                '\$${cartData.getAllTotal.toStringAsFixed(2)}'),
                            backgroundColor: Colors.blue,
                            labelStyle: const TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await Provider.of<OrderProvider>(
                          context,
                          listen: false,
                        ).addOrders(
                          cartData.getCartItems,
                          context.loaderOverlay,
                        );
                        cartData.clearCart();
                        Toast.show(
                          'Successfully create an order.',
                          backgroundColor: Colors.blue,
                          gravity: Toast.bottom,
                        );
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        color: Colors.blue,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10.0),
                        child: const Text(
                          'ORDER NOW',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
