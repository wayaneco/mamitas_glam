import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

const COLLECTION_CART = 'cart';

Future fetchCartItems(userId) {
  return firestore
      .collection(COLLECTION_CART)
      .doc(userId)
      .collection(userId)
      .orderBy('timestamp', descending: false)
      .get()
      .then(
        (QuerySnapshot snapshot) => snapshot.docs.map(
          (DocumentSnapshot docs) {
            final data = docs.data() as dynamic;

            return {
              'id': docs.id,
              'title': data['title'],
              'imageUrl': data['imageUrl'],
              'price': data['price'],
              'quantity': data['quantity'],
            };
          },
        ).toList(),
      )
      .catchError(
        (_) => Future.error('Error fetching cart items.'),
      );
}

Future addCartItem(item, id) {
  return firestore
      .collection(COLLECTION_CART)
      .doc(id)
      .collection(id)
      .add(item)
      .then(
    (DocumentReference document) {
      return document.get().then((DocumentSnapshot snapshot) {
        final data = snapshot.data() as dynamic;

        return snapshot.id;
      });
    },
  ).catchError(
    (_) => Future.error('Error adding ${item['title']}'),
  );
}

Future updateQuantity(id, bool increment, userId) {
  return firestore
      .collection(COLLECTION_CART)
      .doc(userId)
      .collection(userId)
      .doc(id)
      .update(
        {'quantity': FieldValue.increment(increment ? 1 : -1)},
      )
      .then((_) => true)
      .catchError(
        (_) => Future.error('Error updating $id'),
      );
}

Future deleteCartItem(cartId, userId) {
  return firestore
      .collection(COLLECTION_CART)
      .doc(userId)
      .collection(userId)
      .doc(cartId)
      .delete()
      .then((_) => true)
      .catchError(
        (_) => Future.error('Error deleting $cartId'),
      );
}
