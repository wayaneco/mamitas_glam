import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/cart_model.dart';

import '../api/firebase_orders_api.dart' as api;

class OrderProvider with ChangeNotifier {
  User? user;
  final Map<String, Object> _orders = {};
  bool _isLoading = true;

  OrderProvider(this.user);

  Future<void> addOrders(
    List<CartModel> cartItems,
    loaderOverlay,
  ) {
    loaderOverlay.show();
    final cartItemData = cartItems
        .map(
          (item) => {
            'id': item.id,
            'imageUrl': item.imageUrl,
            'title': item.title,
            'price': item.price,
            'quantity': item.quantity,
            'productId': item.productId,
          },
        )
        .toList();

    return api.addOrders(
      {
        'items': FieldValue.arrayUnion(cartItemData),
        'dateOrdered': DateTime.now(),
        'status': 'PENDING',
      },
      user!.uid,
    ).then((order) {
      double total = order['items'].fold(0.0, (prev, current) {
        return prev += (current['quantity'] * current['price']);
      });

      _orders.putIfAbsent(
        order['orderId'],
        () => {
          'orderId': order['orderId'],
          'status': order['status'],
          'dateOrdered': order['dateOrdered'],
          'total': total,
          'orders': order['items'],
        },
      );
      loaderOverlay.hide();
    });
  }

  void setLoading(bool load) {
    _isLoading = load;
    notifyListeners();
  }

  bool get loading => _isLoading;

  Future fetchOrders({bool? initFetch}) async {
    if (initFetch == true) setLoading(true);
    Future.delayed(const Duration(seconds: 3));
    await api.orders(user!.uid).then((orders) {
      for (var order in orders) {
        double total = order['items'].fold(0.0, (prev, current) {
          return prev += (current['quantity'] * current['price']);
        });

        _orders.putIfAbsent(
          order['orderId'],
          () => {
            'orderId': order['orderId'],
            'status': order['status'],
            'dateOrdered': order['dateOrdered'],
            'total': total,
            'orders': order['items'],
          },
        );
      }
      if (initFetch == true) setLoading(false);
    });
  }

  List getAllOrders() {
    return _orders.values.map((val) => val).toList();
  }
}
