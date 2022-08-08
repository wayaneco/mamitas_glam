import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../providers/cart_item_provider.dart';

import '../models/cart_model.dart';

class CartItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CartModel cartItem = Provider.of<CartModel>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context);

    return Dismissible(
      key: ValueKey<String>(cartItem.id),
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        color: Colors.grey.withOpacity(0.1),
        child: const Icon(
          Icons.delete,
          size: 30,
        ),
      ),
      onResize: () {
        cartProvider.removeCartItem(
          cartItem.id,
          context.loaderOverlay,
        );
      },
      child: Card(
        child: Row(
          children: [
            SizedBox(
              width: 150,
              child: Image.network(
                cartItem.imageUrl,
                fit: BoxFit.cover,
                repeat: ImageRepeat.noRepeat,
                alignment: Alignment.topCenter,
                errorBuilder: (ctx, obj, trace) => Image.asset(
                  'assets/images/default.jpg',
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                  repeat: ImageRepeat.repeat,
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      '\$ ${cartItem.price.toString()}',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 50,
              child: Consumer<CartProvider>(
                builder: (_, item, child) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: IconButton(
                        onPressed: () => item.updateQuantity(
                          cartItem.id,
                          true,
                          context.loaderOverlay,
                        ),
                        icon: const Icon(
                          Icons.add,
                          size: 15,
                        ),
                        splashColor: Colors.transparent,
                        splashRadius: 15,
                        padding: const EdgeInsets.all(2.0),
                        constraints: const BoxConstraints(
                          maxHeight: 20,
                          maxWidth: 20,
                        ),
                      ),
                    ),
                    Text(cartItem.quantity.toString()),
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          if (cartItem.quantity == 1) {
                            await cartProvider.removeCartItem(
                              cartItem.id,
                              context.loaderOverlay,
                            );
                          } else {
                            await cartProvider.updateQuantity(
                              cartItem.id,
                              false,
                              context.loaderOverlay,
                            );
                          }
                        },
                        icon: const Text('-'),
                        splashColor: Colors.transparent,
                        splashRadius: 15,
                        padding: const EdgeInsets.all(2.0),
                        constraints: const BoxConstraints(
                          maxHeight: 20,
                          maxWidth: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
