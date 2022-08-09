import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../api/firebase_cart_api.dart' as api;

import '../models/cart_model.dart';

class CartProvider with ChangeNotifier {
  User? user;
  final Map<String, CartModel> _cartItems = {};

  CartProvider(this.user);

  List<CartModel> get getCartItems {
    return _cartItems.entries.map((entry) => entry.value).toList();
  }

  void fetchCartItems() async {
    await api.fetchCartItems(user!.uid).then((cartList) {
      cartList.forEach((data) {
        _cartItems.putIfAbsent(
          data['id'],
          () => CartModel(
            id: data['id'],
            title: data['title'],
            imageUrl: data['imageUrl'],
            quantity: data['quantity'],
            price: data['price'],
            productId: data['productId'],
          ),
        );
      });

      notifyListeners();
    });
  }

  Future addCartItem(
    String productId,
    String title,
    double price,
    String imageUrl,
    loaderOverlay,
  ) async {
    loaderOverlay.show();

    await api.addCartItem(
      {
        'productId': productId,
        'imageUrl': imageUrl,
        'price': price,
        'title': title,
        'quantity': 1,
        'timestamp': DateTime.now(),
      },
      user!.uid,
    ).then((id) {
      _cartItems.putIfAbsent(
        id,
        () => CartModel(
          id: id,
          title: title,
          quantity: 1,
          price: price,
          imageUrl: imageUrl,
          productId: productId,
        ),
      );

      loaderOverlay.hide();
      notifyListeners();
    });
  }

  Future updateQuantity(
    String id,
    increment,
    loaderOverlay,
  ) async {
    loaderOverlay.show();
    await api
        .updateQuantity(
      id,
      increment,
      user!.uid,
    )
        .then((data) {
      _cartItems.update(
        id,
        (existingCartItem) => CartModel(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: increment
              ? existingCartItem.quantity + 1
              : existingCartItem.quantity - 1,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
        ),
      );

      loaderOverlay.hide();
      notifyListeners();
    });
  }

  Future removeCartItem(
    String id,
    loaderOverlay,
  ) async {
    loaderOverlay.show();
    await api.deleteCartItem(id, user!.uid).then((_) {
      _cartItems.remove(id);

      loaderOverlay.hide();
      notifyListeners();
    });
  }

  void decreaseCartItem(String productId) {
    _cartItems.update(
      productId,
      (existingItem) => CartModel(
        id: existingItem.id,
        imageUrl: existingItem.imageUrl,
        price: existingItem.price,
        quantity: existingItem.quantity - 1,
        title: existingItem.title,
      ),
    );

    notifyListeners();
  }

  int get getTotalItems {
    return _cartItems.length;
  }

  double get getAllTotal {
    double total = _cartItems.entries.fold<double>(0.0, (previousValue, entry) {
      return previousValue += (entry.value.price * entry.value.quantity);
    });

    return total;
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
