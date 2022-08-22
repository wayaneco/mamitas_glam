import 'package:flutter/foundation.dart';

class CartModel with ChangeNotifier {
  final String id;
  final String title;
  final int quantity;
  final String imageUrl;
  final double price;
  final String? productId;

  CartModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.quantity,
    required this.price,
    this.productId,
  });
}
