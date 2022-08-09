import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

const COLLECTION_FAVORITES = 'favorites';

Future getFavorites(userId) {
  return firestore
      .collection(COLLECTION_FAVORITES)
      .doc(userId)
      .collection(userId)
      .get()
      .then((QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      final data = doc.data() as dynamic;

      return {
        'favoriteId': doc.id,
        'productId': doc['productId'],
      };
    }).toList();
  });
}

Future addFavorites(productId, userId) {
  return firestore
      .collection(COLLECTION_FAVORITES)
      .doc(userId)
      .collection(userId)
      .add({
        'productId': productId,
      })
      .then(
        (DocumentReference document) => document.get().then(
          (DocumentSnapshot doc) {
            final data = doc.data() as dynamic;
            return {
              'favoriteId': doc.id,
              'productId': doc['productId'],
            };
          },
        ),
      )
      .catchError(
        (_) => false,
      );
}

Future removeFavorites(favoriteId, userId) {
  return firestore
      .collection(COLLECTION_FAVORITES)
      .doc(userId)
      .collection(userId)
      .doc(favoriteId)
      .delete()
      .then(
        (_) => true,
      )
      .catchError(
        (_) => false,
      );
}
