import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

const COLLECTION_PRODUCT = 'products';

Future<List<dynamic>> getProducts() {
  return firestore.collection(COLLECTION_PRODUCT).get().then(
    (QuerySnapshot snapshot) {
      return snapshot.docs.map(
        (DocumentSnapshot doc) {
          if (doc.exists) {
            final product = doc.data() as dynamic;

            return {
              'id': doc.id,
              'title': product['title'],
              'description': product['description'],
              'price': product['price'],
              'imageUrl': product['imageUrl'],
            };
          }
        },
      ).toList();
    },
  );
}

Future<DocumentReference<Object?>> addProduct(product) {
  return firestore.collection(COLLECTION_PRODUCT).add(product).then(
    (DocumentReference document) {
      return document;
    },
  ).catchError(
    (error) {
      return error;
    },
  );
}

Future deleteProduct(productId) async {
  return firestore
      .collection(COLLECTION_PRODUCT)
      .doc(productId)
      .delete()
      .then((_) => true)
      .catchError(
        (_) => false,
      );
}

Future<bool> updateProduct(productId, productData) {
  return firestore
      .collection(COLLECTION_PRODUCT)
      .doc(productId)
      .update({
        'title': productData['title'],
        'description': productData['description'],
        'imageUrl': productData['imageUrl'],
        'price': productData['price'],
      })
      .then(
        (_) => true,
      )
      .catchError(
        (_) => false,
      );
}
