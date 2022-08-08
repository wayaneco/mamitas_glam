import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../api/firebase._products_api.dart' as api;
import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  late List<ProductModel> _products = [];
  bool isLoading = true;

  Future fetchProducts({
    bool? initFetch,
  }) async {
    if (initFetch == true) setLoading(true);
    await api.getProducts().then(
      (List<dynamic> products) {
        List<ProductModel> data = products.map(
          (product) {
            return ProductModel(
              id: product['id'],
              title: product['title'],
              description: product['description'],
              imageUrl: product['imageUrl'],
              price: product['price'],
              isFavorite: false,
            );
          },
        ).toList();

        _products = data;
        isLoading = false;
        if (initFetch == true) setLoading(false);
        notifyListeners();
      },
    );
  }

  bool get getLoading => isLoading;

  void setLoading(bool load) {
    isLoading = load;
    notifyListeners();
  }

  List<ProductModel> get products {
    return [..._products];
  }

  List<ProductModel> get favoriteProducts {
    return _products
        .where(
          (prod) => prod.isFavorite,
        )
        .toList();
  }

  Future addProduct(
    String title,
    String description,
    double price,
    String imageUrl,
    loaderOverlay,
  ) {
    loaderOverlay.show();

    return api.addProduct({
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    }).then((DocumentReference docRef) {
      _products.add(
        ProductModel(
          id: docRef.id,
          title: title,
          description: description,
          imageUrl: imageUrl,
          price: price,
          isFavorite: false,
        ),
      );
      notifyListeners();

      loaderOverlay.hide();
    });
  }

  void removeProduct(
    String productId,
    overlay,
  ) {
    overlay.show();
    api.deleteProduct(productId).then((_) {
      _products.removeWhere((prod) => prod.id == productId);

      overlay.hide();
      notifyListeners();
    });
  }

  ProductModel findById(String productId) {
    return _products.firstWhere((prod) => prod.id == productId);
  }

  Future updateProduct(
    String id,
    String title,
    String description,
    double price,
    String imageUrl,
    loaderOverlay,
  ) {
    loaderOverlay.show();

    return api.updateProduct(id, {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
    }).then((_) {
      int index = _products.indexWhere((prod) => prod.id == id);

      _products[index] = ProductModel(
        id: id,
        title: title,
        description: description,
        imageUrl: imageUrl,
        price: price,
        isFavorite: _products[index].isFavorite,
      );

      notifyListeners();
      loaderOverlay.hide();
    });
  }
}
