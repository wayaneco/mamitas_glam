import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

const COLLECTION_ORDERS = 'orders';

Future<List<Map<String, dynamic>>> orders(userId) {
  return firestore
      .collection(COLLECTION_ORDERS)
      .doc(userId)
      .collection(userId)
      .orderBy('dateOrdered', descending: true)
      .get()
      .then((QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      final data = doc.data() as dynamic;

      return {
        'orderId': doc.id,
        'dateOrdered': (data['dateOrdered'] as Timestamp).toDate(),
        'status': data['status'],
        'items': data['items'],
      };
    }).toList();
  });
}

Future<dynamic> addOrders(cartItem, userId) async {
  return firestore
      .collection(COLLECTION_ORDERS)
      .doc(userId)
      .collection(userId)
      .add(cartItem)
      .then(
    (DocumentReference document) async {
      final data = await document.get().then((DocumentSnapshot snapshot) {
        return snapshot.data() as dynamic;
      });

      WriteBatch writeBatch = firestore.batch();

      await data['items'].forEach((item) {
        DocumentReference ref = firestore.collection('cart').doc(item['id']);
        writeBatch.delete(ref);
      });

      await writeBatch.commit();

      return {
        'orderId': document.id,
        'dateOrdered': (data['dateOrdered'] as Timestamp).toDate(),
        'status': data['status'],
        'items': data['items'],
      };
    },
  );
}
